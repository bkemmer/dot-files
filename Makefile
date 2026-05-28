.DEFAULT_GOAL := help

.PHONY: symlink_linux_vscode
.PHONY: symlink_macos_vscode
.PHONY: install_vscode_extensions
.PHONY: setup
.PHONY: help

OSTYPE := $(shell uname -msr)

symlink_linux_vscode: ## Update the vscode config files for ubuntu-like SO
	ln -sf ${PWD}/vscode/settings.json ${HOME}/.config/Code/User/settings.json
	ln -sf ${PWD}/vscode/keybindings.json ${HOME}/.config/Code/User/keybindings.json

symlink_macos_vscode: ## Same but for MACOS
	# For Antigravity
	ln -sf ${PWD}/vscode/settings.json ${HOME}/Library/Application\ Support/Antigravity/User/settings.json
	ln -sf ${PWD}/vscode/keybindings.json ${HOME}/Library/Application\ Support/Antigravity/User/keybindings.json
	# For old vscode
	ln -sf ${PWD}/vscode/settings.json ${HOME}/Library/Application\ Support/Code/User/settings.json
	ln -sf ${PWD}/vscode/keybindings.json ${HOME}/Library/Application\ Support/Code/User/keybindings.json
install_vscode_extensions: ## install or update the vscode extensions
	grep -v // vscode/extensions | xargs -L1 code --force --install-extension

setup: ## Setup the environment
	@echo "Setting up the environment"
	./scripts/nvim/pre_install.sh
	# @[[ "${OSTYPE}" == "darwin"* ]] && echo 'MacOS homebrew installs' && ./scripts/macos/homebrew_commands.sh
	# [[ "${OSTYPE}" == linux-gnu* ]] && echo 'Linux installs' && ./scripts/linux/setup.sh
	./scripts/nvim/post_install.sh

help: ## Show available make targets
	@awk 'BEGIN {FS = ":.*##"; printf "Usage: make \033[36m<target>\033[0m\n\nTargets:\n"} /^[a-zA-Z_-]+:.*##/ { printf "  \033[36m%-28s\033[0m %s\n", $$1, $$2 }' $(MAKEFILE_LIST)

