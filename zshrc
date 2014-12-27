# Created by newuser for 5.0.7

# load completion and prompts
autoload -U compinit
autoload -U promptinit

# init completion and prompts
compinit
promptinit

# use walters prompt, its awesome
prompt walters

# ignore duplicate history lines
setopt HIST_IGNORE_DUPS

# set editor and add bin to path
export EDITOR=vim
export PATH=$PATH:~/bin

# source bash aliases
if [ -f ~/.bash_aliases ]; then
	. ~/.bash_aliases
fi

# set umask
umask 022
