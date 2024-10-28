.PHONY: lambda_deploy

setup:
	pip install --upgrade pip
	pip install -r requirements.txt

lint:
	ruff check --fix
	ruff format

test:
	pytest tests/

cov:
	coverage run --parallel -m pytest tests/
	coverage combine
	coverage lcov -o lcov.info

lambda_deploy: ## Generate files to deploy the lambda as a zip file (expecting venv folder)
	mkdir package
	zip package/lambda_deployment_package.zip -r venv/lib/python3.10/site-packages
	zip package/lambda_deployment_package.zip lambda_function.py

