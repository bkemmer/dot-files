# create a function to test if a command exists
command_exists() {
  command -v "$1" >/dev/null 2>&1
}

command_exists ffmpeg || sudo apt update && sudo apt install -y ffmpeg
command_exists batcat && sudo apt install -y bat
command_exists zoxide  && sudo apt install -y zoxide
command_exists stow && sudo apt install -y stow

if ! command_exists lazygit ; then
  LAZYGIT_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | \grep -Po '"tag_name": *"v\K[^"]*')
  LAZYGIT_ARCH=$(uname -m | sed -e 's/aarch64/arm64/')
  curl -Lo lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/download/v${LAZYGIT_VERSION}/lazygit_${LAZYGIT_VERSION}_Linux_${LAZYGIT_ARCH}.tar.gz"
  tar xf lazygit.tar.gz lazygit
  sudo install lazygit -D -t /usr/local/bin/
fi


if ! command_exists nvim ; then
  curl -Lo nvim.tar.gz "https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.tar.gz"
  tar xf nvim.tar.gz
  sudo install nvim-linux-x86_64/bin/nvim -D -t /usr/local/bin/
  rm -rf nvim-linux-x86_64 nvim.tar.gz
fi





