include .env
export

plan:
	poetry run feast -c repository plan

apply:
	poetry run feast -c repository apply

serve:
	poetry run feast -c repository serve