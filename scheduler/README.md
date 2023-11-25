# Scheduler

## Feast CLI: `materialize`

The Feast CLI's `materialize` command is a critical component in the Feast workflow, enabling the transfer of data from the offline store to the online store for real-time access. This process is essential for keeping the online store updated with the latest feature data, ensuring that machine learning models have access to the most recent and relevant information.

When the `materialize` command is executed, it triggers a series of operations:

1. **Initialization**: The command starts by initializing a `FeatureStore` instance. This is done by reading the configuration from the `feature_store.yaml` file, which contains all the necessary settings and definitions for the feature store.

2. **Materialization Process**: The core of the materialization process involves reading data from the specified time range (between `start_date` and `end_date`) from the offline store and writing it to the online store. This is done for each feature view specified in the command or for all registered feature views if none are specified.

3. **Provider Interaction**: The `FeatureStore` instance interacts with the provider to execute the materialization for each feature view. The provider is responsible for the actual data transfer between the offline and online stores.

4. **Registry Update**: After the materialization is complete, the `FeatureStore` updates the registry with information about the materialized data. This step is crucial for tracking the state and history of materialized data in the feature store.

<br>

### Detailed Workflow

**Initialization Step**
The `materialize_command` function in the CLI handler initiates the materialization process. It creates a `FeatureStore` instance using the repository configuration.

Source: [cli.materialize_command()](https://github.com/feast-dev/feast/blob/052182bcca046e35456674fc7d524825882f4b35/sdk/python/feast/cli.py#L531)
```py
... # Omitted for brevity
def materialize_command(
    ctx: click.Context, start_ts: str, end_ts: str, views: List[str]
):
    store = create_feature_store(ctx)
    store.materialize(
        feature_views=None if not views else views,
        start_date=utils.make_tzaware(parser.parse(start_ts)),
        end_date=utils.make_tzaware(parser.parse(end_ts)),
    )
```

<br>

**Feature Store Creation**
The `create_feature_store` function is responsible for setting up the FeatureStore instance. It prepares the environment and configuration necessary for the feature store to operate.

Source: [repo_operations.create_feature_store()](https://github.com/feast-dev/feast/blob/052182bcca046e35456674fc7d524825882f4b35/sdk/python/feast/repo_operations.py#L334)
```py
def create_feature_store(
    ctx: click.Context,
) -> FeatureStore:
    ... # Omitted for brevity
    repo_path = Path(tempfile.mkdtemp())
    with open(repo_path / "feature_store.yaml", "wb") as f:
        f.write(config_bytes)
    return FeatureStore(repo_path=ctx.obj["CHDIR"], fs_yaml_file=fs_yaml_file)
```

<br>

**Materialization Execution**
The `materialize` function in the FeatureStore class is where the actual materialization process takes place. It iterates over each feature view and instructs the provider to transfer data from the offline store to the online store.

Source: [FeatureStore.materialize()](https://github.com/feast-dev/feast/blob/052182bcca046e35456674fc7d524825882f4b35/sdk/python/feast/feature_store.py#L1342C9-L1342C20)
```py
def materialize(
    self,
    start_date: datetime,
    end_date: datetime,
    feature_views: Optional[List[str]] = None,
) -> None:
    """Materialize data from the offline store into the online store."""
    ... # Omitted for brevity
    provider = self._get_provider()
    feature_views_to_materialize = self._get_feature_views_to_materialize(feature_views)

    for feature_view in feature_views_to_materialize:
        provider.materialize_single_feature_view(
            config=self.config,
            feature_view=feature_view,
            start_date=start_date,
            end_date=end_date,
            registry=self._registry,
            project=self.project,
            tqdm_builder=lambda length: tqdm(total=length, ncols=100),
        )
        self._registry.apply_materialization(feature_view, self.project, start_date, end_date)
```

<br>

## Caveats

Every instance of FeatureStore requires access to a `feature_store.yaml` configuration file. This file needs to be accessible to any service or application that initializes a FeatureStore instance - making consistency of the `feature_store.yaml` across different services and instances crucial. 

In a production environment, especially one that scales and evolves over time, it's not practical or efficient to include every model serving service or scheduler service within a single monorepo for the sole purpose of accessing the feature_store.yaml. 

<br>

### Implications for Materialization and Feature Access

- **Materialization Jobs**: For materialization jobs, the scheduler (in this case Airflow) needs access to the `feature_store.yaml` to execute materialization scripts correctly.

- **Feature Retrieval**: Services that need to retrieve online feature data also require access to the `feature_store.yaml` to understand the structure and definitions of the features.

<br>

## Addressing Accessibility Challenges

### Option 1: Scheduler Directly Using `feature_store.yaml`
For this approach, you would integrate a scheduler like Apache Airflow directly with Feast. The scheduler would need access to the feature_store.yaml and the Feast SDK to run materialization jobs.  This would require any scheduler to be maintained within the Feature Store repository, alongside it's definitions. 

```
feast-aws
├─ .github
│  └─ workflows
│     └─ ...
├─ infrastructure
│  └─ aws
│     └─ ...
├─ repository
│  ├─ feature_store.yaml
│  └─ feast_jobs # Directory for Feast materialization scripts
│     └─ daily_materialization.py # Example script for daily materialization
├─ scheduler # Apache Airflow or similar scheduler
│  ├─ dags # Airflow DAGs directory
│  │  └─ feast_materialization_dag.py # DAG for triggering Feast materialization
│  └─ ...
├─ server
│  └─ ...
└─ ui
   └─ ...
```

<br>

### Option 2: Scheduler Communicating with FastAPI Server
In this approach, the scheduler makes HTTP requests to your FastAPI server, which then interacts with Feast. The FastAPI server acts as an intermediary between the scheduler and Feast. 

```
feast-aws
├─ .github
│  └─ workflows
│     └─ ...
├─ infrastructure
│  └─ aws
│     └─ ...
├─ repository
│  └─ feature_store.yaml
├─ server
│  ├─ main.py # FastAPI main application file
│  ├─ feast_operations # Directory for Feast operation handlers
│  │  └─ materialize.py # Handler for materialization endpoint
│  └─ ...
├─ scheduler # Apache Airflow or similar scheduler
│  ├─ dags # Airflow DAGs directory
│  │  └─ feast_http_request_dag.py # DAG for making HTTP requests to FastAPI server
│  └─ ...
└─ ui
   └─ ...
```