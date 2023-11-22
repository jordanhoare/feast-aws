
```
feast-aws
├─ Makefile
├─ README.md
├─ client
│  ├─ feature_store.yaml
│  └─ test_fetch.py
├─ driver_stats.parquet
├─ infrastructure
│  └─ aws
│     ├─ .terraform
│     │  └─ ...
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
│  │  ├─ services.py
│  │  ├─ transformations.py
│  │  └─ views.py
│  └─ feature_store.yaml
├─ tests
│  └─ __init__.py
└─ ui
   ├─ .gitignore
   ├─ package-lock.json
   ├─ package.json
   ├─ project-list.json
   ├─ public
   │  ├─ ...
   └─ src
      ├─ App.css
      ├─ App.js
      ├─ App.test.js
      ├─ index.css
      ├─ index.js
      ├─ logo.svg
      ├─ reportWebVitals.js
      └─ setupTests.js

```