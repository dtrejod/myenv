#!/usr/bin/env bash

set -xeo pipefail

CUR_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"

ln -sf "$CUR_DIR/pkgs/bash/bashrc" ~/.bashrc
ln -sf "$CUR_DIR/pkgs/vim/vimrc" ~/.vimrc
ln -sf "$CUR_DIR/pkgs/tmux/tmux.conf" ~/.tmux.conf
ln -sf "$CUR_DIR/pkgs/bash/inputrc" ~/.inputrc
ln -sf "$CUR_DIR/submodules/oh-my-bash" ~/.oh-my-bash
if [[ ! -d ~/.config/nvim/init.vim ]]; then
    mkdir -p ~/.config/nvim
fi

# VIM
ln -sf "$CUR_DIR/pkgs/nvim/init.vim" ~/.config/nvim/init.vim
if [[ ! -d ~/.vim/ftplugin ]]; then
   mkdir -p ~/.vim/ftplugin
fi
for s in $(ls $CUR_DIR/pkgs/vim/.vim/ftplugin/*.*); do
   ln -sf "$s" ~/.vim/ftplugin
done

# Source bashrc to pickup changes
source ~/.bashrc

# Use exisiting .gitconfig if it exists
if [[ ! -f ~/.gitconfig ]]; then
   ln -sf "$CUR_DIR/pkgs/git/gitconfig" ~/.gitconfig
fi

if [[ -e ~/.local/bin/ ]]; then
   for s in $(ls $CUR_DIR/bin/*.*); do
      ln -sf "$s" ~/.local/bin/
   done
else
   echo "WARN: '~/.local/bin' does not exist."
fi

# Download vim package manager
if [[ ! -f ~/.vim/autoload/plug.vim ]]; then
curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
       https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
fi

# Install all vim plugins
vim +'PlugPlugUpgrade --sync' +qa
vim +'PlugUpdate --sync' +qa

echo "Done!"
