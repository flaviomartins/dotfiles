# Clone zcomet if necessary
if [[ ! -f ${ZDOTDIR:-${HOME}}/.zcomet/bin/zcomet.zsh ]]; then
  command git clone https://github.com/agkozak/zcomet.git ${ZDOTDIR:-${HOME}}/.zcomet/bin
fi

# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Initialize zcomet
source ${ZDOTDIR:-${HOME}}/.zcomet/bin/zcomet.zsh

# Load some plugins
zcomet load agkozak/zsh-z
zcomet load atuinsh/atuin
zcomet load ohmyzsh

ZSH_AUTOSUGGEST_MANUAL_REBIND=1

# It is good to load these popular plugins last, and in this order:
zcomet load zsh-users/zsh-syntax-highlighting
zcomet load zsh-users/zsh-autosuggestions
zcomet load zsh-users/zsh-completions

# Powerlevel10k
zcomet load romkatv/powerlevel10k

# Run compinit and compile its cache
zcomet compinit

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# fzf
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# You may need to manually set your language environment
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8

# Preferred editor for local and remote sessions
if [[ -n $SSH_CONNECTION ]]; then
  export EDITOR='nvim'
else
  export EDITOR='nvim'
fi

# Aliases
source ~/.aliases.zsh

# History settings
setopt extended_history
setopt inc_append_history
setopt share_history
setopt hist_ignore_dups
setopt hist_ignore_all_dups
setopt hist_expire_dups_first
setopt hist_save_no_dups
setopt hist_ignore_space
setopt hist_verify
setopt interactivecomments
export HISTFILE=$HOME/.zsh_history
export HISTFILESIZE=50000
export HISTSIZE=50000
export HISTTIMEFORMAT="[%F %T] "
export HISTORY_IGNORE="ls:ll:cd:pwd:exit:clear"

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
PATH="/opt/homebrew/opt/less/bin:$PATH"

# nano
PATH="/opt/homebrew/opt/nano/bin:$PATH"

# openssh
PATH="/opt/homebrew/opt/openssh/bin:$PATH"

# postgresql
PATH="/opt/homebrew/opt/postgresql@16/bin:$PATH"

# sqlite
PATH="/opt/homebrew/opt/sqlite/bin:$PATH"

# ssh-copy-id
PATH="/opt/homebrew/opt/ssh-copy-id/bin:$PATH"

# local bin
export PATH="$HOME/.local/bin:$PATH"

# Do not activate base environment by default
export CONDA_AUTO_ACTIVATE_BASE=false

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/opt/homebrew/Caskroom/miniforge/base/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/opt/homebrew/Caskroom/miniforge/base/etc/profile.d/conda.sh" ]; then
        . "/opt/homebrew/Caskroom/miniforge/base/etc/profile.d/conda.sh"
    else
        export PATH="/opt/homebrew/Caskroom/miniforge/base/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<

# The following lines have been added by Docker Desktop to enable Docker CLI completions.
fpath=(/Users/flaviomartins/.docker/completions $fpath)
autoload -Uz compinit
compinit
# End of Docker CLI completions

# Added by LM Studio CLI (lms)
export PATH="$PATH:/Users/flaviomartins/.cache/lm-studio/bin"

# Added by Toolbox App
export PATH="$PATH:$HOME/Library/Application Support/JetBrains/Toolbox/scripts"
