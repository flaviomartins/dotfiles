# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# You may need to manually set your language environment
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8

# Preferred editor for local and remote sessions
if [[ -n $SSH_CONNECTION ]]; then
  export EDITOR='nvim'
else
  export EDITOR='nvim'
fi

# Clone zcomet if necessary
if [[ ! -f ${ZDOTDIR:-${HOME}}/.zcomet/bin/zcomet.zsh ]]; then
  command git clone https://github.com/agkozak/zcomet.git ${ZDOTDIR:-${HOME}}/.zcomet/bin
fi

source ${ZDOTDIR:-${HOME}}/.zcomet/bin/zcomet.zsh

zcomet load ohmyzsh
zcomet snippet OMZ::plugins/git/git.plugin.zsh
zcomet snippet OMZ::plugins/docker-compose/docker-compose.plugin.zsh
zcomet load zdharma-continuum/history-search-multi-word

# It is good to load these popular plugins last, and in this order:
zcomet load zsh-users/zsh-syntax-highlighting
zcomet load zsh-users/zsh-completions
zcomet load zsh-users/zsh-autosuggestions

# Powerlevel10k
source /opt/homebrew/share/powerlevel10k/powerlevel10k.zsh-theme

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# FZF
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# Aliases
source ~/.aliases.zsh

# History settings
export HISTFILE=$HOME/.zsh_history
export HISTFILESIZE=50000
export HISTSIZE=50000
export HISTTIMEFORMAT="[%F %T] "
setopt extended_history
setopt share_history
setopt hist_find_no_dups
setopt hist_reduce_blanks

# PATH

# gnubin
PATH="/opt/homebrew/opt/coreutils/libexec/gnubin:$PATH"
PATH="/opt/homebrew/opt/findutils/libexec/gnubin:$PATH"
PATH="/opt/homebrew/opt/gawk/libexec/gnubin:$PATH"
PATH="/opt/homebrew/opt/gnu-indent/libexec/gnubin:$PATH"
PATH="/opt/homebrew/opt/gnu-sed/libexec/gnubin:$PATH"
PATH="/opt/homebrew/opt/gnu-tar/libexec/gnubin:$PATH"
PATH="/opt/homebrew/opt/gnu-time/libexec/gnubin:$PATH"
PATH="/opt/homebrew/opt/gnu-which/libexec/gnubin:$PATH"

# bash
PATH="/opt/homebrew/opt/bash/bin:$PATH"

# colordiff
PATH="/opt/homebrew/opt/colordiff/bin:$PATH"

# curl
PATH="/opt/homebrew/opt/curl/bin:$PATH"

# diffutils
PATH="/opt/homebrew/opt/diffutils/bin:$PATH"

# file-formula
PATH="/opt/homebrew/opt/file-formula/bin:$PATH"

# less
PATH="/opt/homebrew/Cellar/less/643/bin:$PATH"

# nano
PATH="/opt/homebrew/Cellar/nano/7.2/bin:$PATH"

# openssh
PATH="/opt/homebrew/Cellar/openssh/9.5p1/bin/:$PATH"

# ssh-copy-id
PATH="/opt/homebrew/opt/ssh-copy-id/bin:$PATH"

export PATH
