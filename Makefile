.DEFAULT_GOAL := print

.PHONY: update_vscode
.PHONY: update_macos_vscode
.PHONY: install_vscode_extensions
.PHONY: lambda_deploy
.PHONY: lint 
.PHONY: test

update_vscode: ## Update the vscode config files for ubuntu-like SO
	cp vscode/settings.json ${HOME}/.config/Code/User/settings.json
	cp vscode/keybidings.json ${HOME}/.config/Code/User/keybidings.json

update_macos_vscode: ## Same but for MACOS
	cp vscode/settings.json ${HOME}/Library/Application\ Support/Code/User/settings.json
	cp vscode/keybidings.json ${HOME}/Library/Application\ Support/Code/User/keybidings.json

install_vscode_extensions: ## install or update the vscode extensions
	grep -v // vscode/extensions | xargs -L1 code --force --install-extension

print: ## print this message with all availables make commands
	@grep '^[^#[:space:]\.].*:' Makefile

lambda_deploy: ## Generate files to deploy the lambda as a zip file (expecting venv folder)
	zip lambda_deployment_package.zip -r venv/lib/python3.10/site-packages
	zip lambda_deployment_package.zip lambda_function.py

lint: ## pass the ruff linter
	ruff check --fix

test: ## run the tests
	pytest tests/
