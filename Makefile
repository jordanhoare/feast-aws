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

plan:
	poetry run feast -c repository plan

apply:
	poetry run feast -c repository apply

serve:
	poetry run feast -c repository serve

ui:
	poetry run feast -c repository ui

run_server:
	poetry run python -m server

run_client:
	cd ui && yarn start