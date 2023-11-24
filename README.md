<br />
<div align="center">
  <a href="https://streamlit.io/">
    <img src="https://github.com/feast-dev/artwork/blob/master/feast-logos/icon/color/feast_icon-color.png" alt="Logo" width="auto" height="120">
  </a>

<h3 align="center">Feast on AWS</h3>

  <p align="center">
    A scalable implementation of feature store management on AWS using the open-source framework <a href="https://feast.dev/"><strong>Feast</strong></a>.
    <br />
  </p>
</div>

<br>


## Table of Contents
- [Project Overview](#project-overview)
- [Architecture](#architecture)
- [Technology Stack](#Technology-Stack)
- [Getting Started](#getting-started)
- [Project Structure](#project-structure)
- [Development Plan](#development-plan)
- [Resources](#resources)

<br>

## Project Overview
The feast-aws project is an solution designed to streamline feature management in machine learning workflows using [Feast](https://feast.dev/), a popular open-source feature store, on AWS cloud infrastructure. 

The project encapsulates a full-feature lifecycle management process, from defining and storing features to serving them for ML models in production. It combines the power of Feast with the scalability and robustness of AWS, creating a versatile environment for managing and deploying features at scale.

<br>

## Architecture

Overview of the project architecture. 

![Architecture1](https://1650793599-files.gitbook.io/~/files/v0/b/gitbook-legacy-files/o/assets%2F-LqPPgcuCulk4PnaI4Ob%2Fsync%2F49670e2005498ff506655d32bb31331a38a45810.png?generation=1611862944091987&alt=media)

<br>

## Technology Stack

This section provides an overview of the technology stack used in this project, with links to the official websites or repositories for more information. Each technology has been selected to ensure the best performance, scalability, and ease of use for our machine learning workflow implementation on AWS.

- [Feast](https://feast.dev/) - An open-source feature store for machine learning, enabling easy management and serving of features for training and inference.

- [FastAPI](https://fastapi.tiangolo.com/) - A modern, fast (high-performance), web framework for building APIs with Python 3.7+ based on standard Python type hints.

- [Snowflake](https://www.snowflake.com/) - A cloud data platform that provides a data warehouse-as-a-service designed for the cloud, supporting various data workloads.

- [React](https://reactjs.org/) - A JavaScript library for building user interfaces, maintained by Facebook and a community of individual developers and companies.

- [Terraform](https://www.terraform.io/) - An open-source infrastructure as code software tool that provides a consistent CLI workflow to manage hundreds of cloud services.

- [GitHub Actions](https://github.com/features/actions) - GitHub's solution to automation, CI/CD, and workflow integration, directly integrated with GitHub repositories.

- [Apache Airflow](https://airflow.apache.org/) - A platform to programmatically author, schedule, and monitor workflows, allowing you to orchestrate complex computational workflows.

- [DBT](https://www.getdbt.com/) - A data processing framework, based on Python, that allows applying transformations on data inside data warehouses like Snowflake, Redshift, BigQuery, and PostgreSQL.

- [Apache Spark](https://spark.apache.org/) - A unified analytics engine for large-scale data processing, with built-in modules for streaming, SQL, machine learning, and graph processing.

- [AWS RDS](https://aws.amazon.com/rds/) - Amazon Relational Database Service (RDS) makes it easy to set up, operate, and scale a relational database in the cloud.

- [AWS Aurora](https://aws.amazon.com/rds/aurora/) - An automated and scalable MySQL and PostgreSQL-compatible relational database with up to five times the performance of standard MySQL databases and three times the performance of standard PostgreSQL databases.

- [AWS ElastiCache](https://aws.amazon.com/elasticache/) - A fully managed in-memory data store, compatible with Redis or Memcached, that provides a high-performance, scalable, and cost-effective caching solution.

- [AWS S3](https://aws.amazon.com/s3/) - Amazon Simple Storage Service (S3) is an object storage service offering industry-leading scalability, data availability, security, and performance.

- [AWS EKS](https://aws.amazon.com/eks/) - Amazon Elastic Kubernetes Service (EKS) is a managed Kubernetes service that makes it easy to run Kubernetes on AWS without needing to install and operate your own Kubernetes control plane.

<br>

## Getting Started
This guide will walk you through setting up and running the feast-aws project. The project is structured to manage infrastructure using Terraform, define and store features using Feast, and provide a user interface and API server for interaction.

<br>

### Requirements
Before starting, ensure you have the following installed:

- [Git](https://git-scm.com/) for command-line interface
- [Poetry](https://python-poetry.org/) for dependency management and packaging
- [Docker](https://docs.docker.com/get-docker/) for developing, shipping, and running applications
- [Yarn](#) for the React UI
- [Terraform](#) for infastructure management

<br>

### Cloning the Repository

Start by cloning the repository to your local machine:

```bash
git clone https://github.com/jordanhoare/feast-aws.git
cd feast-aws
poetry install
```

<br>

### Setting Up Infrastructure

The project uses Terraform scripts located in the `infrastructure/aws` directory to manage AWS resources.



#### Configuring A Remote Backend For State Management

These instructions assumes you do not already have a remote backend for Terraform already created, and provides a step by step command process to do so with AWS S3 (to store state files) and DynamoDB (to state lock during team collaboration). 

1. Initialize Terraform:

   ```bash
   make init-remote-infra
   ```

2. Apply Terraform scripts to a remote backend:

   ```bash
   make apply-remote-infra
   ```

   Confirm the action in the CLI when prompted.

   **Important**
   - Create a copy of the ./infastructure/aws/modules/backend/terraform.tfstate for safe keeping and ensure it isn't checked into Git.
   
   - Write down the outputted values to your environment variables (> .env)
    ```bash
    BUCKET_NAME=terraform-state-storage-00000
    DYNAMODB_TABLE_NAME=terraform-state-lock-00000

    # (Optional) Refresh your .env variables
    $ source .env 
    ```


<br>

#### Configuring A Remote Backend For State Management

> If you haven't configured a remote backend for state management, see previous step.

1. Initialize Terraform for Feast Infastructure:

   ```bash
   make init-feast-infra
   ```

2. Apply Terraform scripts to a remote backend:

   ```bash
   make apply-feast-infra
   ```

   Confirm the action in the CLI when prompted.

<br>

### Understanding Makefile Commands

The `Makefile` in the root directory contains several commands to simplify project operations:

- `repository-plan`: Runs `feast plan` to show the planned changes to the feature store.
  
  ```bash
  make repository-plan
  ```

- `repository-apply`: Applies the planned changes to the feature store.

  ```bash
  make repository-apply
  ```

- `run-server`: Runs the FastAPI server.

  ```bash
  make run-server
  ```

- `run-client`: Starts the React client application (polling the FastAPI server).

  ```bash
  make run-client
  ```

- `lint-format`: Performs recommend linting and formatting of python libraries.

  ```bash
  make run-client
  ```

Each command is tailored to abstract complex CLI operations into simpler make commands, enhancing the development and deployment experience.

<br>

### Running the Project

After setting up the infrastructure and understanding the Makefile commands, you can start the various components of the project:

#### Individual Services

1. Start the FastAPI server:

   ```bash
   make run-server
   ```

2. In a separate terminal, start the React client application:

   ```bash
   make run-client
   ```

#### A Composed Docker Desktop Container

1. Build and run the contains on a single network locally:

   ```bash
   make compose
   ```

#### Individual Containers

1. Build and start the FastAPI server:

   ```bash
   make build-run-server
   ```

2. Build and start the React client application:

   ```bash
   make build-run-ui
   ```

You should now have the FastAPI server, and the Feast UI running, ready for development and testing.

<br>

## Project Structure
Outline the structure of the project and describe the purpose of each top-level directory.

| Directory/File        | Description                                       |
|-----------------------|---------------------------------------------------|
| `infrastructure/aws`  | Terraform scripts for AWS resource management     |
| `repository`          | Library of feature declarations for Feast        |
| `server`              | FastAPI server interfacing with the Feast API    |
| `ui`                  | React frontend application                        |
| `tests`               | Test suite for the project                        |
| `Makefile`            | Commands for running modules and other operations |
| `pyproject.toml`      | Python project metadata and dependencies         |

<br>

## Development Plan

This section outlines the planned development features for the Feast-based machine learning workflow implementation on AWS, along with specific tasks under each feature.

### Feature Management with Feast

- [ ] **Feature Service Definition**
  - [ ] Define and refine feature services in Feast.
  - [ ] Ensure coverage of all necessary features for ML models.
  - [ ] Regularly update and maintain feature definitions.

- [ ] **Feature Registry**
  - [ ] Continue using S3 bucket for Feast registry.
  - [ ] Evaluate and document requirements for migrating the registry to Postgres.
  - [ ] Research and decide between AWS RDS and Aurora for Postgres hosting.
  - [ ] Design and document the migration strategy.
  - [ ] Test Postgres integration in a staging environment.
  - [ ] Implement the migration in the production environment.

- [ ] **Online Store with AWS ElastiCache**
  - [ ] Set up AWS ElastiCache as the online store.
  - [ ] Integrate ElastiCache with Feast.
  - [ ] Test and validate real-time feature serving.

- [ ] **Offline Store with Snowflake**
  - [ ] Integrate Snowflake as the offline store.
  - [ ] Leverage Feast's native materialization engine.
  - [ ] Ensure efficient data storage and retrieval.

### Data Ingestion and Processing

- [ ] **Streaming Ingestion with Spark Streaming**
  - [ ] Implement Spark Streaming for real-time data ingestion.
  - [ ] Integrate Spark Streaming with Feast.
  - [ ] Test and validate streaming data processing.

- [ ] **Batch Processing with DBT**
  - [ ] Utilize DBT for batch transformations.
  - [ ] Integrate DBT with data stores and Feast.
  - [ ] Ensure accuracy and efficiency of batch processing.

### Backend Service Development

- [ ] **FastAPI Backend**
  - [ ] Develop and expand the FastAPI backend service.
  - [ ] Ensure effective interfacing with the Feast Python API.
  - [ ] Implement robust error handling and logging.

- [ ] **Deployment on AWS EKS**
  - [ ] Configure and deploy the backend service on AWS EKS.
  - [ ] Optimize for scalability and reliability.
  - [ ] Set up monitoring and alerting mechanisms.

### Frontend UI Service

- [ ] **React App Development**
  - [ ] Develop the UI service using the Feast NPM package.
  - [ ] Ensure effective communication with the backend service.

- [ ] **Deployment Strategy**
  - [ ] Plan and execute the deployment of the React app.
  - [ ] Consider using AWS Amplify or S3 with CloudFront.

### Infrastructure as Code with Terraform

- [ ] **AWS Infrastructure Provisioning**
  - [ ] Use Terraform for provisioning AWS infrastructure.
  - [ ] Implement IAM roles, permissions, and service deployments.

- [ ] **Remote State Management**
  - [x] Set up Terraform for remote state management in S3.
  - [x] Facilitate team collaboration on infrastructure changes with DynamoDB.

### CI/CD with GitHub Actions

- [ ] **CI/CD for Backend Service (FastAPI)**
  - [ ] Set up automated build and test pipelines for every commit and pull request.
  - [x] Configure Docker containerization for the FastAPI service.
  - [ ] Automate deployment to AWS EKS or other chosen environments upon successful tests and reviews.

- [ ] **CI/CD for Frontend Service (React App)**
  - [ ] Implement automated build and testing for the React application.
  - [ ] Integrate deployment steps to host the app on AWS Amplify or S3 with CloudFront.
  - [ ] Ensure environment-specific configurations are managed securely.

- [ ] **CI/CD for Feast Feature Store**
  - [ ] Automate updates and deployments of Feast configurations and feature definitions.
  - [ ] Set up validation checks for Feast configuration files.
  - [ ] Integrate automated deployment to update the feature store in the cloud environment.

- [ ] **Terraform Infrastructure Versioning and Deployment**
  - [ ] Implement CI pipeline steps for Terraform `fmt` and `validate` to ensure code quality and syntax correctness.
  - [ ] Configure automated Terraform `plan` execution on pull requests for visibility and review of infrastructure changes.
  - [ ] Automate Terraform `apply` for staging and production, with manual approval steps for production deployments.
  - [ ] Securely manage and version Terraform state files, using services like Terraform Cloud or AWS S3 with state locking.

- [ ] **CI/CD for Data Processing Pipelines (Spark/DBT)**
  - [ ] Create pipelines for testing and deploying data processing scripts and DBT models.
  - [ ] Ensure version control and testing for all data transformation and processing code.
  - [ ] Automate deployment of data pipelines to the appropriate data processing services.

- [ ] **CI/CD for Scheduled Jobs (Airflow)**
  - [ ] Set up CI/CD for Airflow DAGs to ensure they are tested before deployment.
  - [ ] Automate the deployment of DAGs to the Airflow environment.
  - [ ] Implement version control and rollback capabilities for DAGs.

<br>

## Resources
- Official Feast Docs: [Feast Docs](https://docs.feast.dev/)
- Official Feast API Reference: [API Reference](https://rtd.feast.dev/en/master/)

```
feast-aws
├─ .github
│  └─ workflows
│     ├─ code-quality.yml
│     ├─ infrastructure.yml
│     ├─ server-cd.yml
│     ├─ server-ci.yml
│     ├─ ui-cd.yml
│     └─ ui-ci.yml
├─ .gitignore
├─ Makefile
├─ README.md
├─ data
│  └─ driver_stats.parquet
├─ docs
│  └─ aws_architecture.png
├─ infrastructure
│  └─ aws
│     ├─ environments
│     │  └─ dev
│     │     ├─ main.tf
│     │     ├─ outputs.tf
│     │     └─ variables.tf
│     └─ modules
│        ├─ backend
│        │  ├─ main.tf
│        │  ├─ outputs.tf
│        │  └─ variables.tf
│        ├─ eks
│        │  ├─ main.tf
│        │  ├─ outputs.tf
│        │  └─ variables.tf
│        ├─ elasticache
│        │  ├─ main.tf
│        │  ├─ outputs.tf
│        │  └─ variables.tf
│        ├─ rds
│        │  ├─ main.tf
│        │  ├─ outputs.tf
│        │  └─ variables.tf
│        ├─ s3
│        │  ├─ main.tf
│        │  ├─ outputs.tf
│        │  └─ variables.tf
│        └─ vpc
│           ├─ main.tf
│           ├─ outputs.tf
│           └─ variables.tf
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
├─ server
│  ├─ Dockerfile
│  ├─ __init__.py
│  ├─ __main__.py
│  ├─ api
│  │  ├─ __init__.py
│  │  └─ endpoints
│  │     ├─ __init__.py
│  │     ├─ features.py
│  │     ├─ projects.py
│  │     └─ registry.py
│  └─ core
│     ├─ __init__.py
│     ├─ application.py
│     ├─ config.py
│     └─ logger.py
├─ setup.cfg
├─ tests
│  └─ __init__.py
└─ ui
   ├─ .dockerignore
   ├─ .gitignore
   ├─ Dockerfile
   ├─ README.md
   ├─ package.json
   ├─ public
   │  ├─ favicon.ico
   │  ├─ index.html
   │  ├─ logo192.png
   │  ├─ logo512.png
   │  ├─ manifest.json
   │  └─ robots.txt
   ├─ src
   │  ├─ App.css
   │  ├─ App.js
   │  ├─ App.test.js
   │  ├─ index.css
   │  ├─ index.js
   │  ├─ logo.svg
   │  ├─ reportWebVitals.js
   │  └─ setupTests.js
   └─ yarn.lock

```