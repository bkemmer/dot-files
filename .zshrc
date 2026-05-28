# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# pyenv
PYENV_ROOT="$HOME/.pyenv"
if [[ -d $PYENV_ROOT/bin ]] then
  export PYENV_ROOT
  export PATH="$PYENV_ROOT/bin:$PATH"
  eval "$(pyenv init -)"
fi

# Added by Antigravity
[[ -d $HOME/.antigravity/antigravity/bin ]] && export PATH="$HOME/.antigravity/antigravity/bin:$PATH"

# Add cargo binaries
[[ -d $HOME/.cargo/bin ]] && export PATH="$HOME/.cargo/bin:$PATH"

# opencode
export PATH=$HOME/.opencode/bin:$PATH

ZSH_THEME="spaceship"

plugins=(
	safe-paste
	git
	zsh-syntax-highlighting
	zsh-autosuggestions
  zsh-vi-mode
)

source $ZSH/oh-my-zsh.sh

[[ -f $HOME/.functions ]] && source $HOME/.functions

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

# venv wrapper
[[ -f $HOME/.venv_wrapper ]] && source $HOME/.venv_wrapper
# enabling C-s in vim
stty -ixon

# red hat specific
if [[ "$OSTYPE" == "linux-gnu" ]]; then
	if grep -q 'Red Hat Enterprise Linux' /etc/*-release; then
    [[ -f $HOME/.rhel_others ]] && source $HOME/.rhel_configs
  else
    [[ -f $HOME/.popos_configs ]] && source $HOME/.popos_configs
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

# fastfetch
if command_exists fastfetch; then fastfetch; fi

export RIPGREP_CONFIG_PATH=$HOME/.ripgreprc

eval "$(zoxide init zsh)"
