#!/bin/sh

if [ "$(uname)" = Linux ] || [ -n "$MSYSCON" ]; then
    ln -ns "$PWD/gitconfig" "$HOME/.gitconfig"
    ln -ns "$PWD/hgrc" "$HOME/.hgrc"
    ln -ns "$PWD/i3" "$HOME/.config/i3"
    ln -ns "$PWD/vim" "$HOME/.vim"
    ln -ns "$PWD/xinitrc" "$HOME/.xinitrc"
elif [ "$OS" = Windows_NT ]; then
    ln -ns "$PWD/gitconfig" "$HOME/.gitconfig"
    ln -ns "$PWD/hgrc" "$HOME/mercurial.ini"
    ln -ns "$PWD/vim" "$HOME/vimfiles"
fi
