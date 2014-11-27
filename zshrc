# Created by newuser for 5.0.7

autoload -U compinit
autoload -U promptinit

compinit
promptinit

prompt walters

setopt HIST_IGNORE_DUPS

export EDITOR=vim
export PATH=$PATH:~/bin

if [ -f ~/.bash_aliases ]; then
	. ~/.bash_aliases
fi

umask 033
