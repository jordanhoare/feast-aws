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
- [Getting Started](#getting-started)
- [Project Structure](#project-structure)
- [Usage](#usage)
- [Development](#development)
- [Contributing](#contributing)
- [Additional Features](#additional-features)
- [Resources](#resources)
- [License](#license)

<br>

## Project Overview
The feast-aws project is an solution designed to streamline feature management in machine learning workflows using [Feast](https://feast.dev/), a popular open-source feature store, on AWS cloud infrastructure. 

The project encapsulates a full-feature lifecycle management process, from defining and storing features to serving them for ML models in production. It combines the power of Feast with the scalability and robustness of AWS, creating a versatile environment for managing and deploying features at scale.

<br>

## Architecture

Overview of the project architecture. Include a link or image of `aws_architecture.png` from the `docs` directory for a visual representation.


![Architecture](docs/aws_architecture.png)

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

1. Navigate to the infrastructure directory:

   ```bash
   cd infrastructure/aws
   ```

2. Initialize Terraform:

   ```bash
   terraform init
   ```

3. Apply Terraform scripts to create resources:

   ```bash
   terraform apply
   ```

   Confirm the action in the CLI when prompted.

<br>

### Understanding Makefile Commands

The `Makefile` in the root directory contains several commands to simplify project operations:

- `plan`: Runs `feast plan` to show the planned changes to the feature store.
  
  ```bash
  make plan
  ```

- `apply`: Applies the planned changes to the feature store.

  ```bash
  make apply
  ```

- `serve`: Serves the Feast feature store for local development.

  ```bash
  make serve
  ```

- `run_server`: Runs the FastAPI server.

  ```bash
  make run_server
  ```

- `run_client`: Starts the React client application.

  ```bash
  make run_client
  ```

Each command is tailored to abstract complex CLI operations into simpler make commands, enhancing the development and deployment experience.

<br>

### Running the Project

After setting up the infrastructure and understanding the Makefile commands, you can start the various components of the project:

1. Start the FastAPI server:

   ```bash
   make run_server
   ```

2. In a separate terminal, start the React client application:

   ```bash
   make run_client
   ```

You should now have the FastAPI server, React client, and optionally the Feast UI running, ready for development and testing.

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
  - [ ] Implement user-friendly and responsive UI design.

- [ ] **Deployment Strategy**
  - [ ] Plan and execute the deployment of the React app.
  - [ ] Consider using AWS Amplify or S3 with CloudFront.
  - [ ] Ensure secure and efficient routing to the backend service.

### Infrastructure as Code with Terraform

- [ ] **AWS Infrastructure Provisioning**
  - [ ] Use Terraform for provisioning AWS infrastructure.
  - [ ] Implement IAM roles, permissions, and service deployments.
  - [ ] Regularly review and update infrastructure configurations.

- [ ] **Remote State Management**
  - [ ] Set up Terraform for remote state management in S3.
  - [ ] Facilitate team collaboration on infrastructure changes.
  - [ ] Ensure security and consistency of Terraform states.

### CI/CD with GitHub Actions

- [ ] **CI/CD for Backend Service (FastAPI)**
  - [ ] Set up automated build and test pipelines for every commit and pull request.
  - [ ] Configure Docker containerization for the FastAPI service.
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
