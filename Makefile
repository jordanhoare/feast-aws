include .env
export

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