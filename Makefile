.DEFAULT_GOAL := print

.PHONY: symlink_linux_vscode
.PHONY: symlink_macos_vscode
.PHONY: install_vscode_extensions
.PHONY: setup

symlink_linux_vscode: ## Update the vscode config files for ubuntu-like SO
	ln -s ${PWD}/vscode/settings.json ${HOME}/.config/Code/User/settings.json
	ln -s ${PWD}/vscode/keybidings.json ${HOME}/.config/Code/User/keybidings.json

symlink_macos_vscode: ## Same but for MACOS
	ln -s ${PWD}/vscode/settings.json ${HOME}/Library/Application\ Support/Code/User/settings.json
	ln -s ${PWD}/vscode/keybidings.json ${HOME}/Library/Application\ Support/Code/User/keybidings.json

install_vscode_extensions: ## install or update the vscode extensions
	grep -v // vscode/extensions | xargs -L1 code --force --install-extension

setup: ## Setup the environment
	@echo "Setting up the environment"
	./scripts/nvim/pre_install.sh
	./scripts/nvim/install_vim_plugins.py
	./scripts/nvim/post_install.sh

print: ## print this message with all availables make commands
	@grep '^[^#[:space:]\.].*:' Makefile

