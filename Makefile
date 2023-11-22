include .env
export

plan:
	cd repository && poetry run feast plan

apply:
	cd repository && poetry run feast apply
