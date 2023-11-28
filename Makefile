include .env
export

export TF_BACKEND_DIR="infrastructure/aws/modules/backend"
export DEV_ENV_DIR="infrastructure/aws/environments/dev"


init-remote-infra:
	cd $(TF_BACKEND_DIR) && terraform init

plan-remote-infra:
	cd $(TF_BACKEND_DIR) && terraform plan

apply-remote-infra:
	cd $(TF_BACKEND_DIR) && terraform apply -auto-approve

destroy-feast:
	cd $(DEV_ENV_DIR) &&  terraform destroy

init-feast-infra:
	cd $(DEV_ENV_DIR) &&  terraform init

fmt-feast-infra:
	cd $(DEV_ENV_DIR) &&  terraform fmt

plan-feast-infra:
	cd $(DEV_ENV_DIR) &&  terraform plan

apply-feast-infra:
	cd $(DEV_ENV_DIR) &&  terraform apply -auto-approve

repository-plan:
	poetry run feast -c repository plan

repository-apply:
	poetry run feast -c repository apply

run-server:
	poetry run python -m server

run-client:
	cd ui && yarn start

lint-format:
	poetry run mypy server repository tests
	poetry run isort server/ repository/ tests/
	poetry run black server repository tests
	poetry run flake8 server/ repository/ tests/

build-run-ui:
	docker build -f ui/Dockerfile -t ui .
	docker run -d -p 3000:80 ui

build-run-server:
	docker build -f server/Dockerfile -t server .
	docker run -d -p 8000:8080 --env-file .env server

compose:
	docker-compose --env-file .env up -d --build

clean-up:
	docker volume prune
	docker system prune
