OSH_THEME="vscode"

completions=(
    git
    composer
    ssh
    tmux
)

plugins=(
    git
    bashmarks
    tmux-autoattach
)

# Aliases
alias nvidia_monitor="watch -n0.1 nvidia-smi"

alias python="/usr/bin/python3"

alias cve="source ./venv/bin/activate"
alias dve="source ~/projects/venv/bin/activate"

# install tmux
if ! command -v tmux &> /dev/null
then
    sudo apt install -y tmux
fi

# install htop
if ! command -v htop &> /dev/null
then
    sudo apt install -y htop
fi
# Get current branch
alias gcb='git rev-parse --abbrev-ref HEAD | xclip'
# alias gcb='git rev-parse --abbrev-ref HEAD | clip.exe'
# export TERM=xterm-256color
# alias tmux="tmux -2"

# # start tmux
# if command -v tmux &> /dev/null && [ -n "$PS1" ] && [[ ! "$TERM" =~ screen ]] && [[ ! "$TERM" =~ tmux ]] && [ -z "$TMUX" ]; then
#     exec tmux
# fi

