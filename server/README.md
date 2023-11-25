# Server

## Feast CLI: `serve`

The Feast CLI's `serve` command is designed to start a local feature server, enabling real-time feature serving. This command is particularly useful for testing and development purposes. However, when scaling to a production-grade solution, several considerations and adaptations are necessary.

When the `serve` command is executed, it performs the following operations:

1. **Initialization**: It starts by creating a `FeatureStore` instance, which is essential for managing and serving feature data.

2. **Server Startup**: The command then initializes and starts a local server, making the feature store's capabilities available over a network.

<br>

### Detailed Workflow

**Initialization Step**
The `serve_command` function in the CLI handler initiates the server startup process. It creates a `FeatureStore` instance using the repository configuration.

Source: [cli.serve_command()](https://github.com/feast-dev/feast/blob/052182bcca046e35456674fc7d524825882f4b35/sdk/python/feast/cli.py#L675C1-L698C6)
```py
def serve_command(
    ctx: click.Context,
    host: str,
    port: int,
    type_: str,
    no_access_log: bool,
    no_feature_log: bool,
    workers: int,
    keep_alive_timeout: int,
    registry_ttl_sec: int = 5,
):
    """Start a feature server locally on a given port."""
    store = create_feature_store(ctx)
    store.serve(
        host=host,
        port=port,
        type_=type_,
        no_access_log=no_access_log,
        no_feature_log=no_feature_log,
        workers=workers,
        keep_alive_timeout=keep_alive_timeout,
        registry_ttl_sec=registry_ttl_sec,
    )
```

<br>


**Feature Store Creation**
The `create_feature_store` function sets up the FeatureStore instance, preparing the necessary environment and configuration.

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

**Server Execution**
The `serve` method in the FeatureStore class handles the actual server startup, configuring and launching a local feature server.

Source: [FeatureStore.serve()](https://github.com/feast-dev/feast/blob/052182bcca046e35456674fc7d524825882f4b35/sdk/python/feast/feature_store.py#L2222)
```py
    def serve(
        self,
        host: str,
        port: int,
        type_: str,
        no_access_log: bool,
        no_feature_log: bool,
        workers: int,
        keep_alive_timeout: int,
        registry_ttl_sec: int,
    ) -> None:
        """Start the feature consumption server locally on a given port."""
        ... # Omitted for brevity
        feature_server.start_server(
            self,
            host=host,
            port=port,
            no_access_log=no_access_log,
            workers=workers,
            keep_alive_timeout=keep_alive_timeout,
            registry_ttl_sec=registry_ttl_sec,
        )
```

<br>

**Server Startup**
The `start_server` function in the feature_server module is responsible for configuring and running the Gunicorn server with Feast-specific settings.

Source: [feature_server.start_server()](https://github.com/feast-dev/feast/blob/052182bcca046e35456674fc7d524825882f4b35/sdk/python/feast/feature_server.py#L225)
```py
class FeastServeApplication(gunicorn.app.base.BaseApplication):
    def __init__(self, store: "feast.FeatureStore", **options):
        self._app = get_app(
            store=store,
            registry_ttl_sec=options.get("registry_ttl_sec", 5),
        )
        self._options = options
        super().__init__()

    ... # Omitted for brevity
        
def start_server(
    store: "feast.FeatureStore",
    host: str,
    port: int,
    no_access_log: bool,
    workers: int,
    keep_alive_timeout: int,
    registry_ttl_sec: int = 5,
):
    FeastServeApplication(
        store=store,
        bind=f"{host}:{port}",
        accesslog=None if no_access_log else "-",
        workers=workers,
        keepalive=keep_alive_timeout,
        registry_ttl_sec=registry_ttl_sec,
    ).run()
```

<br>

## Caveats

In a production environment, scaling the out-of-the-box serve command poses several challenges:

#### Configuration Management
Consistency of the feature_store.yaml across different services and instances is crucial. Any discrepancy can lead to inconsistent feature serving.

#### Scalability
The default server setup may not be optimized for high-traffic scenarios, requiring a more robust and scalable server architecture.

#### Security and Access Control
Ensuring secure access to the feature store and managing permissions can be complex in a distributed environment.

<br>

### Implications and Solutions

To address these challenges, one solution is to create an abstraction layer using a FastAPI server that encapsulates a FeatureStore instance. This approach offers several advantages:

1. Centralized Configuration: By hosting the feature_store.yaml on a central server, you ensure consistency across all instances.
1. Enhanced Scalability: FastAPI provides more flexibility and scalability options compared to the default Feast server, allowing for better handling of high traffic and complex workloads.
1. Improved Security: Integrating security measures and access control becomes more manageable with a dedicated server setup.
