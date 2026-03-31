sudo apt update && sudo apt install stow ripgrep fd-find fzf bat
alias bat=batcat

wget https://github.com/neovim/neovim/releases/download/v0.12.0/nvim-linux-x86_64.tar.gz
mkdir -p /home/sagemaker-user/.local/bin
tar xvfz nvim-linux-x86_64.tar.gz -C ~/.local/nvim --strip-components=1

ln -s /home/sagemaker-user/.local/nvim/bin/nvim /home/sagemaker-user/.local/bin/nvim
PATH=$PATH:/home/sagemaker-user/.local/bin

