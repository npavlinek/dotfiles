# ~/.profile

if [ -n "$BASH_VERSION" ]; then
    # include .bashrc if it exists
    if [ -f "$HOME/.bashrc" ]; then
	. "$HOME/.bashrc"
    fi
fi

export EDITOR=vim
export SSH_AUTH_SOCK="$XDG_RUNTIME_DIR/openssh_agent"

if [ -d "$HOME/opt" ]; then
    PATH="$HOME/opt/scripts:$PATH"
fi
