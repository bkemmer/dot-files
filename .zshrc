# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

ZSH_THEME="spaceship"

plugins=(
	safe-paste
	git
	zsh-syntax-highlighting
	zsh-autosuggestions
)

source $ZSH/oh-my-zsh.sh

# create a function to test if a command exists
command_exists() {
  command -v "$1" >/dev/null 2>&1
}

# User configuration
export MANPATH="/usr/local/man:$MANPATH"


# Preferred editor
if command_exists nvim; then
	export VIMCONFIG="$HOME/.config/nvim"
	export VISUAL=nvim
  export EDITOR='nvim'
	alias vim=nvim
  alias vi=nvim
  alias v=nvim
else
	export VIMCONFIG="$HOME/.vim"
  export EDITOR='vim'
fi

# Test if ~/.aliases exists and source it
if [[ -f $HOME/.aliases ]]; then
    source $HOME/.aliases
fi

# pyenv
export PYENV_ROOT="$HOME/.pyenv"
[[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"

# venv wrapper
[[ -f $HOME/.venv_wrapper ]] && source $HOME/.venv_wrapper
# enabling C-s in vim
stty -ixon

# red hat specific
if [[ "$OSTYPE" == "linux-gnu" ]]; then
	if cat /etc/*-release | grep -q 'Red Hat Enterprise Linux'; then
		source $HOME/.functions
		source $HOME/.rhel_configs
    [[ -f $HOME/.rhel_others ]] && source $HOME/.rhel_configs
	fi
fi
# if [[ "$OSTYPE" == "darwin"* ]]; then
# 	vim="/usr/local/bin/vim"
# fi

# bat theme
export BAT_THEME="Catppuccin Mocha"

# using bat as a colorizing pager for `man`
export MANPAGER="sh -c 'sed -u -e \"s/\\x1B\[[0-9;]*m//g; s/.\\x08//g\" | bat -p -lman'"

# fzf entry
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# neofetch
if command_exists neofetch; then neofetch; fi

export RIPGREP_CONFIG_PATH=$HOME/.ripgreprc

