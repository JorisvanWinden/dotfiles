# Created by newuser for 5.0.7

# set editor and add bin to path

plugins=(colorize)

ZSH=~/.oh-my-zsh
source $ZSH/oh-my-zsh.sh

export PROMPT="%B%F{red}%(?..[%?] )%f%b%F{yellow}λ%f %F{green}%c%f %F{yellow}::%f "
export EDITOR=vim

# source bash aliases
if [ -f ~/.aliases ]; then
	source ~/.aliases
fi

# set umask
umask 022
