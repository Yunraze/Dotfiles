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

# ANSI escape codes for Gentoo-like colors
WHITE="\[\e[97m\]"		# White
LIGHT_GREEN="\[\e[92m\]"	# Light Green (Username)
LIGHT_YELLOW="\[\e[93m\]"	# Light Yellow (Prompt character)
BLUE="\[\e[94m\]"		# Blue (Current directory)
BOLD="\[\e[1m\]"		# Bold
RESET="\[\e[0m\]"		# Reset color
RED="\[\e[38;5;196m\]"		# Red (Git branch)

# "TOOLBOX" in white
TOOLBOX="${WHITE}T460s${RESET}"

# Function to get the current git branch
parse_git_branch() {
	local branch=$(git branch --show-current 2>/dev/null)

	if [ -n "$branch" ]; then
		echo " (${branch})" 
	fi
}

# Set the PS1 prompt
PS1="💻 ${BOLD}${TOOLBOX} ${BOLD}${BLUE}\w${RESET} ${BOLD}${LIGHT_GREEN}\u${RESET}${BOLD}${RED}\$(parse_git_branch)${RESET}${BOLD}${WHITE} \$${RESET} "


# User specific aliases and functions
alias ls='ls --color=auto'

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

# Bare git repo alias for dotfiles
alias dotfiles="git --git-dir=$HOME/Dotfiles --work-tree=$HOME"

# Move up by n spots in the directory hierarchy.
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

# Show n processes and list their memory usage, PID, user and command line.
psmem() {
	local count=${1:-10}

	# List processes with their memory usage, PID, user and command line,
	# sort them by memory usage in descending order and display top N
	# processes as specified.
	ps -eo rss,pid,user,command | sort -rn | head -n "$count" | awk '
	BEGIN {
		# Define human-readable memory size units.
		hr[1024**2]="GB"; hr[1024]="MB";
	}
	{
		# Convert the memory usage to a human-readable format.
		for (x = 1024 ** 3; x >= 1024; x /= 1024) {
			if ($1 >= x) {
				printf ("%-6.2f %s ", $1 / x, hr[x]);
				break;
			}
		}
	}
	{
		# Print the process ID and user.
		printf ("%-6s %-10s ", $2, $3);
	}
	{
		# Print the command line, handling commands with spaces.
		for (x = 4; x <= NF; x++) {
			printf ("%s ", $x);
		}
		print ("\n"); # Ensure each process info is on a new line.
	}
	'
}
