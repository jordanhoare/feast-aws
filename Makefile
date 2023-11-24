include .env
export

export TF_BACKEND_DIR="infrastructure/aws/modules/backend"
export DEV_ENV_DIR="infrastructure/aws/environments/dev"

init-terraform:
	cd $(TF_BACKEND_DIR) && terraform init

apply-terraform:
	cd $(TF_BACKEND_DIR) && terraform apply -auto-approve

init-feast-infra:
	cd $(DEV_ENV_DIR) &&  terraform init

apply-feast-infra:
	cd $(DEV_ENV_DIR) &&  terraform apply -auto-approve

repository-plan:
	poetry run feast -c repository plan

repository-apply:
	poetry run feast -c repository apply

run_server:
	poetry run python -m server

run_client:
	cd ui && yarn start

lint-format:
	poetry run mypy server repository tests
	poetry run isort server/ repository/ tests/
	poetry run black server repository tests
	poetry run flake8 server/ repository/ tests/
