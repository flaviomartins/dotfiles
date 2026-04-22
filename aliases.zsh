(( ${+functions[command_exists]} )) || command_exists() {
	(( $+commands[$1] ))
}

alias rm='rm -i'
alias reload='exec zsh'

if command_exists nvim; then
	alias vi='nvim'
	alias vim='nvim'
fi

if command_exists bat; then
	alias cat='bat --paging=never --style=plain'
fi

if command_exists lazygit; then
	alias lg='lazygit'
fi

if command_exists uu-ls; then
	alias ls='uu-ls --color=auto'
	alias ll='uu-ls -lh --color=auto'
	alias lsa='uu-ls -lah --color=auto'
fi

if command_exists fd; then
	lsd() {
		fd --max-depth 1 --type d --hidden --exclude .git . "${1:-.}"
	}
fi

if command_exists git; then
	alias g='git'
	alias ga='git add'
	alias gap='git add -p'
	alias gb='git branch'
	alias gc='git commit'
	alias gco='git checkout'
	alias gd='git diff'
	alias gl='git log --oneline --decorate --graph --all'
	alias gs='git status --short --branch'
fi

if command_exists nq && command_exists aria2c; then
	alias qget='NQDIR="$HOME/Downloads" nq aria2c -d "$HOME/Downloads"'
fi

if command_exists fq; then
	alias qwait='NQDIR="$HOME/Downloads" fq -q'
fi

# Honeyman's "idiom" command.
alias honey='sort | uniq -c | sort -rn'

if command_exists shuf; then
	pincode() {
		shuf --random-source=/dev/urandom -i 0-9 -r -n "${1:-6}" | paste -sd ''
	}
fi
