#!/usr/bin/env bash

set -xeo pipefail

CUR_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"

ln -sf "$CUR_DIR/pkgs/bash/bashrc" ~/.bashrc
ln -sf "$CUR_DIR/pkgs/vim/vimrc" ~/.vimrc
ln -sf "$CUR_DIR/pkgs/tmux/tmux.conf" ~/.tmux.conf
ln -sf "$CUR_DIR/pkgs/bash/inputrc" ~/.inputrc

# oh-my-bash
ln -sfn "$CUR_DIR/submodules/oh-my-bash" ~/.oh-my-bash
set +x
source ~/.oh-my-bash/tools/upgrade.sh # Upgrade oh-my-bash
set -x

# VIM
if [[ ! -d ~/.vim/ftplugin ]]; then
   mkdir -p ~/.vim/ftplugin
fi
for s in $(ls $CUR_DIR/pkgs/vim/.vim/ftplugin/*.*); do
   ln -sfn "$s" ~/.vim/ftplugin
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

# Ghostty
case "$(uname -s)" in
    Linux*)
        if [[ ! -f ~/.local/bin/ghostty/config ]]; then
            ln -s $CUR_DIR/pkgs/ghostty/config ~/.local/bin/ghostty/config
        fi
        ;;
    Darwin*)
        if [[ ! -f ~/Library/Application\ Support/com.mitchellh.ghostty/config ]]; then
            ln -s $CUR_DIR/pkgs/ghostty/config ~/Library/Application\ Support/com.mitchellh.ghostty/config
        fi
        ;;
    *)
        echo "WARN: Unknown OS. Skipping ghostty configuration setup."
        ;;
esac


# Download vim package manager
if [[ ! -f ~/.vim/autoload/plug.vim ]]; then
curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
       https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
fi

# Uninstall all plugins not in vimrc
vim +'PlugClean' +qa

# Install all vim plugins
vim +'PlugPlugUpgrade --sync' +qa
vim +'PlugUpdate --sync' +qa

echo "Done!"
