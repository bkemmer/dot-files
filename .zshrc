# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

ZSH_THEME="spaceship"

plugins=(
	git
	zsh-syntax-highlighting
	zsh-autosuggestions
)

source $ZSH/oh-my-zsh.sh

# User configuration
export MANPATH="/usr/local/man:$MANPATH"


# Preferred editor
if [[ -x nvim ]] || [[ -x /usr/bin/nvim ]] || [[ -x /usr/local/bin/nvim ]]; then
	export VIMCONFIG="$HOME/.config/nvim"
	export VISUAL=nvim
	alias vim=nvim
	alias vi=nvim
else
	export VIMCONFIG="$HOME/.vim"
fi

# Test if ~/.aliases exists and source it
if [ -f $HOME/.aliases ]; then
    source $HOME/.aliases
fi

# pyenv
export PYENV_ROOT="$HOME/.pyenv"
[[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"

# enabling C-s in vim
stty -ixon

# red hat specific
if [[ "$OSTYPE" == "linux-gnu" ]]; then
	if cat /etc/*-release | grep -q 'Red Hat Enterprise Linux'; then
		source $HOME/.functions
		source $HOME/.rhel_apps
	fi
fi
# if [[ "$OSTYPE" == "darwin"* ]]; then
# 	vim="/usr/local/bin/vim"
# fi

# fzf entry

[[ -f $HOME/.fzf.zsh ]] && source $HOME/.fzf.zsh
[[ -d $VIMCONFIG/pack/plugins/start/fzf/bin ]] && export PATH=$PATH:$VIMCONFIG/pack/plugins/start/fzf/bin

