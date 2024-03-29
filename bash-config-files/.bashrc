# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color|*-256color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
#force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
	# We have color support; assume it's compliant with Ecma-48
	# (ISO/IEC-6429). (Lack of such support is extremely rare, and such
	# a case would tend to support setf rather than setaf.)
	color_prompt=yes
    else
	color_prompt=
    fi
fi


# get current branch in git repo
function parse_git_branch() {
	BRANCH=`git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/\1/'`
	if [ ! "${BRANCH}" == "" ]
	then
		STAT=`parse_git_dirty`
        echo "(${BRANCH}${STAT})"
	else
		echo ""
	fi
}


# get current status of git repo
function parse_git_dirty 
{
	status=`git status 2>&1 | tee`
	dirty=`echo -n "${status}" 2> /dev/null | grep "modified:" &> /dev/null; echo "$?"`
	untracked=`echo -n "${status}" 2> /dev/null | grep "Untracked files" &> /dev/null; echo "$?"`
	ahead=`echo -n "${status}" 2> /dev/null | grep "Your branch is ahead of" &> /dev/null; echo "$?"`
	newfile=`echo -n "${status}" 2> /dev/null | grep "new file:" &> /dev/null; echo "$?"`
	renamed=`echo -n "${status}" 2> /dev/null | grep "renamed:" &> /dev/null; echo "$?"`
	deleted=`echo -n "${status}" 2> /dev/null | grep "deleted:" &> /dev/null; echo "$?"`
	bits=''
	if [ "${renamed}" == "0" ]; then
		bits=">${bits}"
	fi
	if [ "${ahead}" == "0" ]; then
		bits=" ${bits}"
	fi
	if [ "${newfile}" == "0" ]; then
		bits=" ${bits}"
	fi
	if [ "${untracked}" == "0" ]; then
		bits=" ${bits}"
	fi
	if [ "${deleted}" == "0" ]; then
		bits="﫧${bits}"
	fi
	if [ "${dirty}" == "0" ]; then
		bits=" ${bits}"
	fi
	if [ ! "${bits}" == "" ]; then
		echo " ${bits}"
	else
		echo ""
	fi
}

if [ "$color_prompt" = yes ]; then
    # PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\W\[\033[00m\]\$ '
    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\] \[\033[00m\]\[\033[01;34m\]\W\[\033[00m\] $(parse_git_branch)\[\e[31m\]\\$\[\e[m\] '
else
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\W\$ '
fi


unset color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \W\a\]$PS1"
    ;;
*)
    ;;
esac

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dir_colors && eval "$(dircolors -b ~/.dir_colors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# colored GCC warnings and errors
#export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# some more ls aliases
alias ll='ls -lF'
alias la='ls -lA'
alias l='ls -CF'

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi
export EDITOR="vim"

# Set LS_COLORS environment by Deepin
# if [[ ("$TERM" = *256color || "$TERM" = screen* || "$TERM" = xterm* ) && -f /etc/lscolor-256color ]]; then
#     eval $(dircolors -b /etc/lscolor-256color)
# else
#     eval $(dircolors)
# fi

# using z command to jump around
source ~/Config-files/bash-config-files/z.sh

# Some alias for command using
alias bc="vim ~/.bashrc"
alias so="source ~/.bashrc; echo 'Bash config reloaded:)'"
alias vimc="vim ~/.vimrc"
alias emacs="LC_CTYPE='zh_CN.UTF-8' emacs26"
alias es="~/Config-files/scripts/es.sh"
alias ff="LC_CTYPE='zh_CN.UTF-8' ~/Config-files/scripts/ec.sh"
alias fn="LC_CTYPE='zh_CN.UTF-8' ~/Config-files/scripts/et.sh"
alias fs="sudo LC_CTYPE='zh_CN.UTF-8' ~/Config-files/scripts/et.sh"
alias resv="sudo systemctl restart v2ray"
alias v2c="sudo vim /etc/v2ray/config.json"
alias findemacsd="ps -e | grep emacs"
alias vcon="sudo vim /etc/v2ray/config.json"
alias getd="sudo mount /dev/sdb3 ~/external/"
alias getf="sudo mount /dev/sdb6 ~/f-disk/"
alias open="xdg-open"
alias rename="perl-rename"
alias pydir="cd ~/external/workspace/python/"
alias i3c="evim ~/.config/i3/config"
alias i3sc="evim ~/.config/i3status/config"
alias go="~/Config-files/scripts/go.sh"
alias his="~/Config-files/scripts/his.sh"
alias jk="~/Config-files/scripts/jk.sh"
alias rm="rm -i"
alias update-fonts="sudo fc-cache -fv"
alias ii="nautilus ./ & >> /dev/null"
alias sii="sudo nautilus ./ & >> /dev/null"
alias cdns="cd ~/external/notes/"
alias lsn="bash ~/external/notes/do.sh"
alias config-dir="cd ~/Config-files/"
alias :q="exit"
alias share_win="sudo mount -t cifs -o username=Administrator //192.168.2.150/install-packages/ /mnt/share/"
alias :c="guake --hide"
alias openpdf="~/Config-files/scripts/openpdf.sh"
alias ii="nautilus ./ 2> /dev/null &"
alias pwdc=" pwd | xclip -selection clipboard"

