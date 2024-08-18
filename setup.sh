#!/bin/bash

set -eu

sudo apt update
sudo apt install -y apache2-utils psmisc net-tools tmux tree make jq neovim direnv

# apache2-utils: abのため
# psmisc: pstreeのため
# net-tools: ifconfigのため

sudo su - isucon
cd ~

# asdf
git clone https://github.com/asdf-vm/asdf.git ~/.asdf --branch v0.14.0
echo . "$HOME/.asdf/asdf.sh" >> ~/.bashrc
echo . "$HOME/.asdf/completions/asdf.bash" >> ~/.bashrc

# shellcheck disable=SC1090
. ~/.bashrc

asdf plugin-add alp https://github.com/asdf-community/asdf-alp.git
asdf install alp latest
asdf global alp latest
