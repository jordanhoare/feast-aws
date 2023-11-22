
```
feast-aws
├─ .gitignore
├─ Makefile
├─ client
│  ├─ feature_store.yaml
│  └─ test_fetch.py
├─ driver_stats.parquet
├─ infrastructure
│  ├─ .DS_Store
│  └─ aws
│     ├─ .terraform
│     │  └─ providers
│     │     └─ registry.terraform.io
│     │        └─ hashicorp
│     │           └─ aws
│     │              └─ 5.26.0
│     │                 └─ darwin_arm64
│     │                    └─ terraform-provider-aws_v5.26.0_x5
│     ├─ .terraform.lock.hcl
│     ├─ main.tf
│     ├─ outputs.tf
│     └─ variables.tf
├─ poetry.lock
├─ pyproject.toml
├─ repository
│  ├─ common
│  │  ├─ __init__.py
│  │  ├─ entities.py
│  │  └─ sources.py
│  ├─ driver_stats
│  │  ├─ __init__.py
│  │  ├─ fields.py
│  │  ├─ transformations.py
│  │  └─ views.py
│  ├─ feature_store.yaml
│  └─ services.py
└─ tests
   └─ __init__.py
```