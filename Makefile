update_vscode: ## Update the vscode config files for ubuntu
	cp vscode/settings.json ${HOME}/.config/Code/User/settings.json
	cp vscode/keybidings.json ${HOME}/.config/Code/User/keybidings.json

update_macos_vscode: ## Same but for MACOS
	cp vscode/settings.json ${HOME}/Library/Application\ Support/Code/User/settings.json
	cp vscode/keybidings.json ${HOME}/Library/Application\ Support/Code/User/keybidings.json

install_vscode_extensions: ## install or update the vscode extensions
	grep -v // extensions | xargs -L1 code --force --install-extension
