#
# ~/.bashrc
#
# If not running interactively, don't do anything
[[ $- != *i* ]] && return

if [ -f /etc/bashrc ]; then
    . /etc/bashrc
fi

# Local scripts
if [[ -d ~/.local/bashrc.d/ ]]; then
    for f in $(ls ~/.local/bashrc.d); do
        . ~/.local/bashrc.d/$f
    done
fi

# -------------
# - Functions -
# -------------

# Empty

# ---------
# - SHELL -
# ---------
set -o emacs

# Setup Default Editor
export EDITOR=vim
export VISAUL="$EDITOR"

# less override
if which lesspipe.sh >/dev/null 2>&1; then
    export LESSOPEN="|lesspipe.sh %s"
fi

# Setup Terminal
export TERM=screen-256color

# Allow for search forward
stty -ixon

# ------
# - Go -
# ------
export GOPATH=~/Documents/projects/gowork

# --------------
# - Setup Path -
# --------------
# Nodejs
#PATH=".node_modules/bin:$PATH"
#export npm_config_prefix=~/.node_modules
export PATH=$PATH:$GOPATH/bin

if [[ -e /usr/local/opt/sphinx-doc/bin ]]; then
    export PATH="/usr/local/opt/sphinx-doc/bin:$PATH"
fi

# Path: Custom binaries
PATH=$PATH:$HOME/.local/bin

# ----------
# - Python -
# ----------
# Virtualenv setup
export WORKON_HOME=~/.virtualenvs
if which virtualenvwrapper.sh >/dev/null 2>&1; then
    . virtualenvwrapper.sh
fi

# OpenCV
#export LD_LIBRARY_PATH=/usr/local/lib:/usr/lib

# ----------------
# - Setup Prompt -
# ----------------
unset PROMPT_COMMAND
export PS1="\[\033[38;5;20m\]\u\[$(tput sgr0)\]\[\033[38;5;15m\]@\[$(tput sgr0)\]\[\033[38;5;2m\]\h\[$(tput sgr0)\]\[\033[38;5;15m\]:\[$(tput sgr0)\]\[\033[38;5;160m\]\w\[$(tput sgr0)\]\[\033[38;5;15m\][$SHLVL]\\$ \[$(tput sgr0)\]"

# --------
# - DIRS -
# --------
#if [[ -e "$HOME/documents/projects" ]]; then
#    pushd "$HOME/documents/projects"
#    cd ~
#fi

# ---------
# - MUSIC -
# ---------
# Music Player settings
export ncmpcpp_directory="~/.config/ncmpcpp"

# -----------
# - Aliases -
# -----------
alias vi="vim"
alias rm="rm -i"
alias l="ls -hF --color=auto"
alias ll="ls -lhF --color=auto"
alias la="ls -lahF --color=auto"
alias dirs="dirs -v"
if (! which open >/dev/null 2>&1) && which xdg-open >/dev/null 2>&1; then
    alias open="xdg-open"
fi
alias "tmuxk"="tmux kill-session -t"
alias "tmuxa"="tmux a -t"
alias "c"="clear"
alias "dfh"="df -hT"
alias "ncm"="ncmpcpp"
alias "nowplay"="ncmpcpp --current-song && echo ''"
alias sudo="sudo "

if [[ $(uname) == "Linux" ]]; then
    alias "recent"="find . -type f -exec stat --format '%Y :%y %n' \"{}\" \; | sort -nr | cut -d: -f2- | head"
#MACOS overrides
elif [[ $(uname) == "Darwin" ]]; then
    # macos uses different flags for color
    alias l="ls -hFG"
    alias ll="ls -lhFG"
    alias la="ls -lahFG"

    # ls colors (MACOS) -- dark bg
    export LSCOLORS=gxBxhxDxfxhxhxhxhxcxcx
    if [[ -e ~/.local/bin/macos_free.py ]]; then
       alias "free"="~/.local/bin/macos_free.py"
    fi

    # override bsd tar
    if [[ -e /usr/local/opt/gnu-tar/libexec/gnubin/tar ]]; then
        export PATH="/usr/local/opt/gnu-tar/libexec/gnubin/:$PATH"
    fi
fi

if which evince >/dev/null 2>&1; then
    alias "pdf"=evince
elif which open >/dev/null 2>&1; then
    alias pdf=open
fi

alias "..."="cd ../.."
alias ".."="cd .."
#alias "audio-tv"="pulseaudio-dlna --encoder flac"; for id=$(pactl list short sink-inputs|awk '{ print $1 }'); do patcl move-sink-input $id 8; done"

# ---------
# - sshrc -
# ---------
if [[ -n $SSHHOME ]]; then
    # Point to sshrc vimrc
    if [[ -e "$SSHHOME/.sshrc.d/.vimrc" ]]; then
        export VIMINIT="let \$MYVIMRC='$SSHHOME/.sshrc.d/.vimrc' | source \$MYVIMRC"
    fi
fi
