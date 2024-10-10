# .bashrc

# Source global definitions
if [ -f /etc/bashrc ]; then
    . /etc/bashrc
fi

# User specific environment
if ! [[ "$PATH" =~ "$HOME/.local/bin:$HOME/bin:" ]]; then
    PATH="$HOME/.local/bin:$HOME/bin:$PATH"
fi
export PATH

# Uncomment the following line if you don't like systemctl's auto-paging feature:
# export SYSTEMD_PAGER=

# User specific aliases and functions
if [ -d ~/.bashrc.d ]; then
    for rc in ~/.bashrc.d/*; do
        if [ -f "$rc" ]; then
            . "$rc"
        fi
    done
fi
unset rc

# Get proper colors
export TERM="xterm-256color"

# Ignore duplicates in history
export HISTCONTROL=ignoredups:erasedups

# User specific aliases and functions
alias ls='ls --color=auto'

# Emacs aliases
alias emacs="emacsclient -c -a 'emacs'"
alias doomsync="~/.emacs.d/bin/doom sync"
alias doomdoctor="~/.emacs.d/bin/doom doctor"
alias doomupgrade="~/.emacs.d/bin/doom upgrade"
alias doompurge="~/.emacs.d/bin/doom purge"

# Colorize grep output
alias grep="grep --color=auto"
alias egrep="egrep --color=auto"
alias fgrep="fgrep --color=auto"

# Errors from 'journalctl'
alias errors="journalctl -p 3 -xb"

# GPG
# Verify signature for ISOs
alias gpg-check="gpg2 --keyserver-options auto-key-retrieve --verify"

# Receive the key of a developer
alias gpg-retrieve="gpg2 --keyserver-options auto-key-retrieve --receive-keys"

# yt-dlp
alias yt-dlp-aac="yt-dlp --extract-audio --audio-format aac "
alias yt-dlp-best="yt-dlp --extract-audio --audio-format best "
alias yt-dlp-flac="yt-dlp --extract-audio --audio-format flac "
alias yt-dlp-m4a="yt-dlp --extract-audio --audio-format m4a "
alias yt-dlp-mp3="yt-dlp --extract-audio --audio-format mp3 "
alias yt-dlp-opus="yt-dlp --extract-audio --audio-format opus "
alias yt-dlp-vorbis="yt-dlp --extract-audio --audio-format vorbis "
alias yt-dlp-wav="yt-dlp --extract-audio --audio-format wave "
alias yt-dlp-video="yt-dlp -f bestvideo+bestaudio "

# Bare git repo alias for dotfiles
alias dotfiles="git --git-dir=$HOME/Dotfiles --work-tree=$HOME"

# Quick extract
ex()
{
	if [ -f "$1" ] ; then
		case $1 in
			*.tar.bz2)	tar xjf $1	;;
			*.tar.gz)	tar xzf $1	;;
			*.bz2)		bunzip2 $1	;;
			*.rar)		unrar x $1	;;
			*.gz)		gunzip $1	;;
			*.tar)		tar xf $1	;;
			*.tbz2)		tar xjf $1	;;
			*.tgz)		tar xzf $1	;;
			*.zip)		unzip $1	;;
			*.Z)		uncompress $1	;;
			*.7z)		7z x $1		;;
			*.deb)		ar x $1		;;
			*.tar.xz)	tar xf $1	;;
			*.tar.zst)	unzstd $1	;;
			*)		echo "'$1' has no extractor with ex()"	;;
		esac
	else
		echo "'$1' is not a valid archive file"
	fi
}

up() {
	local d=""
	local steps="$1"
	
	if [ -z "$steps" ] || [ "$steps" -le 0 ]; then
		steps=1
	fi
	
	for ((i = 1; i <= steps; i++)); do
		d="../$d"
	done
	
	if ! cd "$d"; then
		echo "Cannot .. $steps dirs.";
	fi
}

# Programming related
# .NET
DOTNET_CLI_TELEMETRY_OPTOUT=1
export DOTNET_CLI_TELEMETRY_OPTOUT

# Go
export GOPATH="$HOME/.go"
