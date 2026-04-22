(( ${+functions[command_exists]} )) || command_exists() {
	(( $+commands[$1] ))
}

alias rm='rm -i'
alias reload='exec zsh'
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'

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
	alias l='uu-ls --color=auto'
	alias ls='uu-ls --color=auto'
	alias ll='uu-ls -lh --color=auto'
	alias lsa='uu-ls -lah --color=auto'
fi

if command_exists eza; then
	tree() {
		eza --tree --level="${1:-2}" --group-directories-first --icons=never "${2:-.}"
	}
fi

if command_exists fd; then
	lsd() {
		fd --max-depth 1 --type d --hidden --exclude .git . "${1:-.}"
	}

	if command_exists fzf; then
		cdf() {
			local dir
			dir=$(command fd --type d --hidden --exclude .git . "${1:-.}" | command fzf) || return
			cd "$dir" || return
		}
	fi
fi

if command_exists git; then
	alias g='git'
	alias ga='git add'
	alias gaa='git add --all'
	alias gap='git add -p'
	alias gb='git branch'
	alias gc='git commit'
	alias gca='git commit --amend'
	alias gcan='git commit --amend --no-edit'
	alias gco='git checkout'
	alias gd='git diff'
	alias gdc='git diff --cached'
	alias gl='git log --oneline --decorate --graph --all'
	alias gp='git push'
	alias gpf='git push --force-with-lease'
	alias gpl='git pull --rebase --autostash'
	alias gs='git status --short --branch'
fi

if command_exists gh; then
	alias pr='gh pr view --web'
fi

if command_exists rg; then
	alias rg='rg --smart-case --hidden --glob !.git/'

	fif() {
		command rg --smart-case --hidden --glob '!.git/' "${@:-.}"
	}
fi

if command_exists jq; then
	alias jq='jq -C'

	json() {
		if (( $# )); then
			command jq -C . "$@"
		else
			command jq -C .
		fi
	}
fi

if command_exists http; then
	alias h='http'
fi

if command_exists just; then
	alias j='just'
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
