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
