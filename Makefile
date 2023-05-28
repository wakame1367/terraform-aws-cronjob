.PHONY: setup

run: setup

setup:
	cd envs/production && terraform init

upgrade:
	cd envs/production && terraform init -upgrade

plan_prod:
	cd envs/production && terraform plan

apply_prod:
	cd envs/production && terraform apply

destroy_prod:
	cd envs/production && terraform apply -destroy

fmt:
	terraform fmt -recursive

tflint:
	cd envs/production && tflint
