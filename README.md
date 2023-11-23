
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
```
feast-aws
├─ .git
│  ├─ COMMIT_EDITMSG
│  ├─ config
│  ├─ description
│  ├─ FETCH_HEAD
│  ├─ HEAD
│  ├─ hooks
│  │  ├─ applypatch-msg.sample
│  │  ├─ commit-msg.sample
│  │  ├─ fsmonitor-watchman.sample
│  │  ├─ post-update.sample
│  │  ├─ pre-applypatch.sample
│  │  ├─ pre-commit.sample
│  │  ├─ pre-merge-commit.sample
│  │  ├─ pre-push.sample
│  │  ├─ pre-rebase.sample
│  │  ├─ pre-receive.sample
│  │  ├─ prepare-commit-msg.sample
│  │  ├─ push-to-checkout.sample
│  │  └─ update.sample
│  ├─ index
│  ├─ info
│  │  └─ exclude
│  ├─ logs
│  │  ├─ HEAD
│  │  └─ refs
│  │     ├─ heads
│  │     │  └─ master
│  │     └─ remotes
│  │        └─ origin
│  │           ├─ HEAD
│  │           └─ master
│  ├─ objects
│  │  ├─ 0d
│  │  │  └─ bc643c0c98acecf5cbf62d8a6eac4372620e6e
│  │  ├─ 0e
│  │  │  └─ 0de3f31f9bab3f20b82c35c78e34315c2d9dfb
│  │  ├─ 32
│  │  │  └─ 155381f8d6e07daca966f119f77df6df8f1126
│  │  ├─ 4b
│  │  │  └─ 9d1e9823b8551267797826f1f80ff753695433
│  │  ├─ 4e
│  │  │  └─ 20029f57d81828633c05695442e0ad0450af4e
│  │  ├─ 92
│  │  │  └─ c26ffe52b50b0a567a560610bcb079337e8326
│  │  ├─ a7
│  │  │  └─ 63501d0a6dbb4617d652aaf0c1cad145b7cd57
│  │  ├─ b0
│  │  │  └─ cbae0ac987566950296e0e2dbbcaecaa0802d7
│  │  ├─ c6
│  │  │  └─ 45beb5be2bb648f8a425ab625590e921962cfd
│  │  ├─ e0
│  │  │  └─ d6c7b7223fe7f27bf4461de82f0743e6a51e00
│  │  ├─ e3
│  │  │  └─ 6596cd9e39658bbe5e93fc58b95f6297dab831
│  │  ├─ ee
│  │  │  └─ efaa2501e5c4ab3699d6e096af0cb2dcb49c28
│  │  ├─ f1
│  │  │  └─ 4b3bf87f786e67f064fa0b0e73ed485a439e1d
│  │  ├─ fd
│  │  │  └─ d65ea44c2d1665c5c3e6d368d92b87d7bff1c2
│  │  ├─ info
│  │  └─ pack
│  │     ├─ pack-0c47599e6edf5d4b59d7dd3be38c79af7c2da435.idx
│  │     └─ pack-0c47599e6edf5d4b59d7dd3be38c79af7c2da435.pack
│  ├─ ORIG_HEAD
│  ├─ packed-refs
│  └─ refs
│     ├─ heads
│     │  └─ master
│     ├─ remotes
│     │  └─ origin
│     │     ├─ HEAD
│     │     └─ master
│     └─ tags
├─ .gitignore
├─ docs
│  └─ aws_architecture.png
├─ driver_stats.parquet
├─ infrastructure
│  └─ aws
│     ├─ .terraform.lock.hcl
│     ├─ main.tf
│     ├─ outputs.tf
│     └─ variables.tf
├─ Makefile
├─ poetry.lock
├─ pyproject.toml
├─ README.md
├─ repository
│  ├─ common
│  │  ├─ entities.py
│  │  ├─ sources.py
│  │  └─ __init__.py
│  ├─ driver_stats
│  │  ├─ services.py
│  │  ├─ transformations.py
│  │  ├─ views.py
│  │  └─ __init__.py
│  └─ feature_store.yaml
├─ server
│  ├─ api
│  │  ├─ endpoints
│  │  │  ├─ hello.py
│  │  │  └─ __init__.py
│  │  └─ __init__.py
│  ├─ core
│  │  ├─ application.py
│  │  ├─ config.py
│  │  ├─ logger.py
│  │  └─ __init__.py
│  ├─ __init__.py
│  └─ __main__.py
├─ tests
│  └─ __init__.py
└─ ui
   ├─ .gitignore
   ├─ package-lock.json
   ├─ package.json
   ├─ project-list.json
   ├─ public
   │  ├─ favicon.ico
   │  ├─ index.html
   │  ├─ logo192.png
   │  ├─ logo512.png
   │  ├─ manifest.json
   │  └─ robots.txt
   ├─ README.md
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