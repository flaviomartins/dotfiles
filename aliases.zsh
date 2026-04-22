(( ${+functions[command_exists]} )) || command_exists() {
	(( $+commands[$1] ))
}

alias rm='rm -i'
alias reload='exec zsh'
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'

take() {
	(( $# == 1 )) || {
		print -u2 'usage: take <directory>'
		return 2
	}

	command mkdir -p -- "$1" && cd -- "$1"
}

showpath() {
	print -l -- $path
}

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
	ff() {
		command fd --type f --hidden --exclude .git . "${1:-.}"
	}

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

	groot() {
		local root
		root=$(command git rev-parse --show-toplevel 2> /dev/null) || return
		cd "$root" || return
	}
fi

if command_exists gh; then
	alias pr='gh pr view --web'
	alias repo='gh repo view --web'
fi

if command_exists docker; then
	alias dc='docker compose'
	alias dps='docker ps'
	alias dcu='docker compose up'
	alias dcud='docker compose up -d'
	alias dcd='docker compose down'
	alias dcl='docker compose logs -f'
fi

if command_exists lazydocker; then
	alias ld='lazydocker'
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

if command_exists dua; then
	alias dui='dua interactive'
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
