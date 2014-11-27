# enable ls and grep colors
alias ls='ls --color=auto'
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'

# some more ls aliases
alias ll='ls -lF'
alias la='ls -A'
alias l='ls -CF'

# common lisp alias
alias cl=clisp

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# set output sink while playback is happening
function output() {
	echo "Setting $1 as default sink"
	pactl set-default-sink $1
	pacmd list-sink-inputs | grep index | grep -o "[0-9]\+" | while 
read -r index ; do
		echo "Moving sink input $index to sink $1"
		pactl move-sink-input $index $1
	done
}

function vol-max() {
	vol 100%
}

function vol() {
	pactl set-sink-volume @DEFAULT_SINK@ $1
}

function list-inputs() {
	pacmd list-sink-inputs | grep -e index: -e driver: -e sink:
}

function list-outputs() {
	pacmd list-source-outputs | grep -e index: -e driver: -e source:
}

function rtp-on() {
	echo "Loading rtp module"
	pactl load-module module-rtp-send source=rtp.monitor port=47002 > /dev/null
}

function rtp-off() {
	echo "Unloading rtp module"
	pactl unload-module module-rtp-send
}

function pa-restart() {
	pulseaudio --kill
	pulseaudio --start
}

function brightness() {
	sudo -k tee /sys/class/backlight/acpi_video0/brightness <<< $1
}
