(( ${+functions[command_exists]} )) || command_exists() {
	(( $+commands[$1] ))
}

alias rm='rm -i'
alias reload='exec zsh'
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'

dotfiles() {
	cd "$HOME/.dotfiles" || return
}

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
	alias v='nvim'
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
	alias la='uu-ls -A --color=auto'
	alias ls='uu-ls --color=auto'
	alias ll='uu-ls -lh --color=auto'
	alias lsa='uu-ls -lah --color=auto'
fi

if command_exists eza; then
	tree() {
		command eza --tree --level="${1:-2}" --group-directories-first --icons=never "${2:-.}"
	}
elif command_exists tree; then
	tree() {
		command tree -L "${1:-2}" "${2:-.}"
	}
fi

if command_exists fd; then
	ff() {
		local query root
		query=${1:-.}
		root=${2:-.}
		command fd --type f --hidden --exclude .git "$query" "$root"
	}

	lsd() {
		local query root
		query=${1:-.}
		root=${2:-.}
		command fd --max-depth 1 --type d --hidden --exclude .git "$query" "$root"
	}

	if command_exists fzf; then
		cdf() {
			local query root dir
			query=${1:-.}
			root=${2:-.}
			dir=$(command fd --type d --hidden --exclude .git "$query" "$root" | command fzf --select-1 --exit-0) || return
			cd "$dir" || return
		}

		fe() {
			local query root file preview_cmd editor
			query=${1:-.}
			root=${2:-.}
			preview_cmd='command cat {}'
			editor=${VISUAL:-${EDITOR:-vi}}

			if command_exists bat; then
				preview_cmd='bat --paging=never --style=plain --color=always --line-range :200 {}'
			fi

			file=$(command fd --type f --hidden --exclude .git "$query" "$root" | command fzf --select-1 --exit-0 --preview "$preview_cmd") || return
			${=editor} "$file"
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
	alias grs='git restore'
	alias gs='git status --short --branch'
	alias gsw='git switch'

	groot() {
		local root
		root=$(command git rev-parse --show-toplevel 2> /dev/null) || return
		cd "$root" || return
	}
fi

if command_exists gh; then
	alias issues='gh issue list'
	alias pr='gh pr view --web'
	alias prs='gh pr status'
	alias repo='gh repo view --web'
fi

if command_exists docker; then
	alias dc='docker compose'
	alias dce='docker compose exec'
	alias dcl='docker compose logs -f'
	alias dcd='docker compose down'
	alias dcr='docker compose run --rm'
	alias dps='docker ps'
	alias dcu='docker compose up'
	alias dcud='docker compose up -d'
fi

if command_exists lazydocker; then
	alias ld='lazydocker'
fi

if command_exists rg; then
	alias rg='rg --smart-case --hidden --glob !.git/'

	fif() {
		(( $# >= 1 )) || {
			print -u2 'usage: fif <pattern> [path ...]'
			return 2
		}

		local pattern
		pattern=$1
		shift

		if (( $# > 0 )); then
			command rg --smart-case --hidden --glob '!.git/' "$pattern" "$@"
		else
			command rg --smart-case --hidden --glob '!.git/' "$pattern"
		fi
	}
fi

if command_exists gron; then
	alias ungron='gron --ungron'
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

if command_exists hurl; then
	alias hu='hurl'
fi

if command_exists just; then
	alias j='just'
fi

if command_exists duckdb; then
	alias ddb='duckdb'
fi

if command_exists dua; then
	alias dui='dua interactive'
	alias dus='dua aggregate'
fi

if command_exists nq && command_exists aria2c; then
	qget() {
		local downloads_dir
		downloads_dir="$HOME/Downloads"
		NQDIR="$downloads_dir" command nq aria2c -d "$downloads_dir" "$@"
	}
fi

if command_exists fq; then
	qwait() {
		NQDIR="$HOME/Downloads" command fq -q "$@"
	}
fi

if command_exists rclone; then
	alias rc='rclone'
fi

if command_exists sqlfluff; then
	alias sqlfix='sqlfluff fix'
fi

if command_exists cloudflared; then
	alias cfd='cloudflared'
fi

if command_exists flyctl; then
	alias fly='flyctl'
fi

if command_exists yt-dlp; then
	alias yt='yt-dlp'
fi

# Honeyman's "idiom" command.
honey() {
	local limit
	limit=${1:-0}

	if (( $# > 0 )) && [[ $1 == <-> ]]; then
		shift
	elif (( $# > 0 )); then
		limit=0
	fi

	if [[ $limit != <-> ]]; then
		print -u2 'usage: honey [top_n] [file ...]'
		return 2
	fi

	local -a files
	files=("$@")

	if (( limit > 0 )); then
		command awk '
			{ count[$0]++ }
			END {
				for (line in count) {
					printf "%7d %s\n", count[line], line
				}
			}
		' "${files[@]}" | command sort -rn | command head -n "$limit"
	else
		command awk '
			{ count[$0]++ }
			END {
				for (line in count) {
					printf "%7d %s\n", count[line], line
				}
			}
		' "${files[@]}" | command sort -rn
	fi
}

if command_exists pwgen; then
	passgen() {
		command pwgen -s "${1:-24}" 1
	}
fi

if command_exists shuf; then
	pincode() {
		command shuf --random-source=/dev/urandom -i 0-9 -r -n "${1:-6}" | paste -sd ''
	}
fi
