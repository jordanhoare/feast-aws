# Repository: 

**Overview:**
The `feast apply` command automates the setup and maintenance of the Feast feature store. It involves a series of coordinated steps that load configurations, prepare the registry and repository, and apply changes to the feature store's infrastructure and metadata, ensuring that the feature store is always in sync with the defined configurations.

<br>

## Feast CLI: `feast apply`

The `feast apply` command is a crucial part of the Feast workflow. It's responsible for configuring and updating the Feast feature store based on the definitions provided in the Feast configuration files. This process involves several key steps, each handled by specific functions within the Feast codebase.

- Initially, the command creates an instance of `FeatureStore` using the YAML file configuration. This step is essential for initializing the feature store with the correct settings and parameters as defined by the user.
- Subsequently, it invokes the `apply()` method on the `FeatureStore` instance. This method is the core of the `feast apply` command, where the actual application of configurations and updates to the feature store takes place.

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

### CLI Replacement Hypothesis
**Hypothesis**
You can bypass the direct use of the feast apply CLI command and instead interact directly with a FeatureStore instance, potentially running as a service. This approach would involve programmatically managing the feature store's configuration and operations, which is essentially what the feast apply command automates.

Theoretically, if you correctly set up a FeatureStore instance to be managed as a service, you could remove the requirement of having a feature_store.yml in every directory where you define or use features. Instead, you would only need the feature_store.yml configuration file on the server where the FeatureStore instance is running (in which case, you no longer need to maintain a 'feature_store.yml' or a list of sources (?) and can instead programmatically define this using a [RepoConfig](https://github.com/feast-dev/feast/blob/052182bcca046e35456674fc7d524825882f4b35/sdk/python/feast/repo_config.py#L133) and [DataSource](https://github.com/feast-dev/feast/blob/052182bcca046e35456674fc7d524825882f4b35/sdk/python/feast/data_source.py#L168).

Ultimately with this approach, it is possible to create a custom that can published to a private repository/library that enables end users to simply pip install a library.  Under the hood the SDK can make HTTP calls to the Rest API service (service module in this repository).  Engineers then control what source are available in which environment programatically.

**For example:**
In a jupyter notebook on a private network:

```python
!pip install fs-sdk
```

```python
import fs_sdk as fs

sources: List = fs.get_file_source_list()
```