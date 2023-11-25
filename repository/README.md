# Repository: 

<br>

## Feast CLI: `feast apply`

The `feast apply` command automates the setup and maintenance of the Feast feature store. It involves a series of coordinated steps that load configurations, prepare the registry and repository, and apply changes to the feature store's infrastructure and metadata, ensuring that the feature store is always in sync with the defined configurations.

- Initially, the command creates an instance of `FeatureStore` using the YAML file configuration. This step is essential for initializing the feature store with the correct settings and parameters as defined by the user.

- Subsequently, it invokes the `apply()` method on the `FeatureStore` instance. This method is the core of the `feast apply` command, where the actual application of configurations and updates to the feature store takes place.

The apply() method in Feast does not deploy a **feature store** in the traditional sense of deploying an application or service. Instead, it registers and updates feature definitions, entities, and feature views in the Feast registry and updates the infrastructure (AKA: data sources) as needed (like creating tables in the online store).


<br>

### Detailed Workflow

**CLI Command Handler:**
The `apply_total_command` function in the CLI handler starts the process. It loads the repository configuration and calls the `apply_total` function with the necessary parameters.

Source: '[cli.apply()](https://github.com/feast-dev/feast/blob/052182bcca046e35456674fc7d524825882f4b35/sdk/python/feast/cli.py#L471C49-L471C49)'
```py
@cli.command("apply", cls=NoOptionDefaultFormat)
def apply_total_command(ctx: click.Context, skip_source_validation: bool):
    """
    Create or update a feature store deployment
    """
    ... # Omitted for brevity
    repo_config = load_repo_config(repo, fs_yaml_file)
    apply_total(repo_config, repo, skip_source_validation)
```


<br>

**Applying Total Configurations:**
The `apply_total` function orchestrates the overall process. It prepares the registry and repository and then calls `apply_total_with_repo_instance` to apply the configurations.

Source: '[repo_operations.apply_total()](https://github.com/feast-dev/feast/blob/052182bcca046e35456674fc7d524825882f4b35/sdk/python/feast/repo_operations.py#L355)'
```py
def apply_total(repo_config: RepoConfig, repo_path: Path, skip_source_validation: bool):
    ... # Omitted for brevity
    project, registry, repo, store = _prepare_registry_and_repo(repo_config, repo_path)
    apply_total_with_repo_instance(store, project, registry, repo, skip_source_validation)
```

<br>

**Preparing Registry and Repository:**
The `_prepare_registry_and_repo` function initializes the `FeatureStore` with the given configuration and extracts the project, registry, and repository details.

Source: '[repo_operations._prepare_registry_and_repo()](https://github.com/feast-dev/feast/blob/052182bcca046e35456674fc7d524825882f4b35/sdk/python/feast/repo_operations.py#L225)'
```py
def _prepare_registry_and_repo(repo_config, repo_path):
    store = FeatureStore(config=repo_config)
    project = store.project
    registry = store.registry
    repo = parse_repo(repo_path)
    ... # Omitted for brevity
    return project, registry, repo, store
```

<br>

**Applying Configurations with Repository Instance:**
The `apply_total_with_repo_instance` function takes the prepared components and applies the necessary changes to the feature store, including registering or deleting objects as specified.

Source: '[repo_operations.apply_total_with_repo_instance()](https://github.com/feast-dev/feast/blob/052182bcca046e35456674fc7d524825882f4b35/sdk/python/feast/repo_operations.py#L286)'
```py
def apply_total_with_repo_instance(
    store: FeatureStore,
    project: str,
    registry: Registry,
    repo: RepoContents,
):
    ... # Omitted for brevity
    all_to_apply, all_to_delete = extract_objects_for_apply_delete(project, registry, repo)
    store.apply(all_to_apply, objects_to_delete=all_to_delete, partial=False)
```

<br>

**FeatureStore Apply Method:**
Finally, the `apply` method of `FeatureStore` is where the objects are registered or updated in the Feast registry, and the infrastructure is updated accordingly.

Source: '[FeatureStore.apply()](https://github.com/feast-dev/feast/blob/052182bcca046e35456674fc7d524825882f4b35/sdk/python/feast/feature_store.py#L771)'
```py
def apply(
    self,
    objects: Union[DataSource, Entity, FeatureView, ... List[FeastObject]],
    objects_to_delete: Optional[List[FeastObject]] = None,
    partial: bool = True,
):
    """Register objects to metadata store and update related infrastructure.

    This method registers one or more definitions (e.g., Entity, FeatureView) and updates these objects in the Feast registry. 
    It also updates the infrastructure (e.g., create tables in an online store) and commits the updated registry. All operations are idempotent.
    """
    if not isinstance(objects, Iterable):
        objects = [objects]
    if not objects_to_delete:
        objects_to_delete = []

    # Separating objects into different categories
    entities_to_update = [ob for ob in objects if isinstance(ob, Entity)]
    views_to_update = [ob for ob in objects if isinstance(ob, FeatureView) and not isinstance(ob, StreamFeatureView)]
    ... # Omitted for brevity

    # Validate and make inferences
    self._validate_all_feature_views(views_to_update, odfvs_to_update, request_views_to_update, sfvs_to_update)
    self._make_inferences(data_sources_to_update, entities_to_update, views_to_update, odfvs_to_update, sfvs_to_update, services_to_update)

    # Add all objects to the registry and update the provider's infrastructure
    for ds in data_sources_to_update:
        self._registry.apply_data_source(ds, project=self.project, commit=False)
    ... # Omitted for brevity

    if not partial:
        # Delete all registry objects that should not exist
        entities_to_delete = [ob for ob in objects_to_delete if isinstance(ob, Entity)]
        ... # Omitted for brevity

        for data_source in data_sources_to_delete:
            self._registry.delete_data_source(data_source.name, project=self.project, commit=False)
        ... # Omitted for brevity

    tables_to_delete: List[FeatureView] = views_to_delete + sfvs_to_delete if not partial else []
    tables_to_keep: List[FeatureView] = views_to_update + sfvs_to_update

    self._get_provider().update_infra(
        project=self.project,
        tables_to_delete=tables_to_delete,
        tables_to_keep=tables_to_keep,
        entities_to_delete=entities_to_delete if not partial else [],
        entities_to_keep=entities_to_update,
        partial=partial,
    )

    self._registry.commit()
```


<br>

## FeastStore: `materialize`

The default Feast materialization process is an in-memory process, which pulls data from the offline store before writing it to the online store. However, this process does not scale for large data sets, since it's executed on a single-process.

Feast supports pluggable [Materialization Engines](https://docs.feast.dev/getting-started/architecture-and-components/batch-materialization-engine), that allow the materialization process to be scaled up. Aside from the local process, Feast supports a [Snowflake materialization engine](https://docs.feast.dev/reference/batch-materialization/snowflake), and a [Bytewax-based materialization engine](https://docs.feast.dev/reference/batch-materialization/bytewax).

<br>

The `materialize` command ...

- Initially, ...

<br>

### Detailed Workflow

**__TODO__**
The `apply_materialization` function in the CLI handler starts the process. It loads the repository configuration and calls the `materialize` function with request views.

Source: '[Registry.apply_materialization()](https://github.com/feast-dev/feast/blob/052182bcca046e35456674fc7d524825882f4b35/sdk/python/feast/infra/registry/registry.py#L464C9-L464C30)'
```py
... # Omitted for brevity
def materialize_command(
    ctx: click.Context, start_ts: str, end_ts: str, views: List[str]
):
    """
    Run a (non-incremental) materialization job to ingest data into the online store. Feast
    will read all data between START_TS and END_TS from the offline store and write it to the
    online store. If you don't specify feature view names using --views, all registered Feature
    Views will be materialized.
    """
    store = create_feature_store(ctx)
    store.materialize(
        feature_views=None if not views else views,
        start_date=utils.make_tzaware(parser.parse(start_ts)),
        end_date=utils.make_tzaware(parser.parse(end_ts)),
    )
```

<br>

**__TODO__**
The `create_feature_store` function ...

Source: '[repo_operations.create_feature_store()](https://github.com/feast-dev/feast/blob/052182bcca046e35456674fc7d524825882f4b35/sdk/python/feast/repo_operations.py#L334)'
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

**__TODO__**
The `materialize` function ...

Source: '[FeatureStore.materialize()](https://github.com/feast-dev/feast/blob/052182bcca046e35456674fc7d524825882f4b35/sdk/python/feast/feature_store.py#L1342C9-L1342C20)'
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

**__TODO__**
The `` function ...

Source: '[]()'
```py
... # Omitted for brevity
```








- You're right that an instance of FeatureStore requires access to a feature_store.yaml configuration file. This file defines the configuration for the feature store, including the registry, online and offline store configurations, and other settings.

- In a production environment, this file needs to be accessible to any service or application that initializes a FeatureStore instance.




## Scheduler Directly Using feature_store.yaml:
For this approach, you would integrate a scheduler like Apache Airflow directly with Feast. The scheduler would need access to the feature_store.yaml and the Feast SDK to run materialization jobs.

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

## Scheduler Communicating with FastAPI Server:
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