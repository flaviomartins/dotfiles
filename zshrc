# zmodload zsh/zprof

# Performance optimizations
DISABLE_AUTO_UPDATE="true"
DISABLE_MAGIC_FUNCTIONS="true"
DISABLE_COMPFIX="true"

# Autosuggestions performance optimizations
ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE="20"
ZSH_AUTOSUGGEST_MANUAL_REBIND=1
ZSH_AUTOSUGGEST_USE_ASYNC=1

# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Clone zcomet if necessary
if [[ ! -f ${ZDOTDIR:-${HOME}}/.zcomet/bin/zcomet.zsh ]]; then
  command git clone https://github.com/agkozak/zcomet.git ${ZDOTDIR:-${HOME}}/.zcomet/bin
fi

# Initialize zcomet
source ${ZDOTDIR:-${HOME}}/.zcomet/bin/zcomet.zsh

# Load some plugins
zcomet load agkozak/zsh-z
zcomet load atuinsh/atuin
zcomet load ohmyzsh

# ssh-agent plugin settings
zstyle :omz:plugins:ssh-agent quiet yes
zstyle :omz:plugins:ssh-agent lazy yes
zstyle :omz:plugins:ssh-agent agent-forwarding yes
zcomet load ohmyzsh/ohmyzsh plugins/ssh-agent

# Better host completion for ssh
zcomet load sunlei/zsh-ssh

# Powerlevel10k
zcomet load romkatv/powerlevel10k

# The following lines have been added by Docker Desktop to enable Docker CLI completions.
fpath=(/Users/flaviomartins/.docker/completions $fpath)
# End of Docker CLI completions

# Run compinit and compile its cache (cache completions aggressively)
autoload -Uz compinit
if [ "$(date +'%j')" != "$(stat -f '%Sm' -t '%j' ~/.zcompdump 2>/dev/null)" ]; then
    compinit
else
    compinit -C
fi

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

# mysql
PATH="/opt/homebrew/opt/mysql@8.0/bin:$PATH"

# nano
PATH="/opt/homebrew/opt/nano/bin:$PATH"

# openssh
PATH="/opt/homebrew/opt/openssh/bin:$PATH"

# postgresql
PATH="/opt/homebrew/opt/postgresql@17/bin:$PATH"

# sqlite
PATH="/opt/homebrew/opt/sqlite/bin:$PATH"

# ssh-copy-id
PATH="/opt/homebrew/opt/ssh-copy-id/bin:$PATH"

# local bin
export PATH="$HOME/.local/bin:$PATH"

# Node Version Manager (nvm)
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" --no-use  # This loads nvm

# place this after nvm initialization!
autoload -U add-zsh-hook

load-nvmrc() {
  local nvmrc_path
  nvmrc_path="$(nvm_find_nvmrc)"

  if [ -n "$nvmrc_path" ]; then
    local nvmrc_node_version
    nvmrc_node_version=$(nvm version "$(cat "${nvmrc_path}")")

    if [ "$nvmrc_node_version" = "N/A" ]; then
      nvm install
    elif [ "$nvmrc_node_version" != "$(nvm version)" ]; then
      nvm use
    fi
  elif [ -n "$(PWD=$OLDPWD nvm_find_nvmrc)" ] && [ "$(nvm version)" != "$(nvm version default)" ]; then
    echo "Reverting to nvm default version"
    nvm use default
  fi
}

add-zsh-hook chpwd load-nvmrc
load-nvmrc

# >>> mamba initialize >>>
# !! Contents within this block are managed by 'mamba shell init' !!
export MAMBA_EXE='/Users/flaviomartins/miniforge3/bin/mamba';
export MAMBA_ROOT_PREFIX='/Users/flaviomartins/miniforge3';
__mamba_setup="$("$MAMBA_EXE" shell hook --shell zsh --root-prefix "$MAMBA_ROOT_PREFIX" 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__mamba_setup"
else
    alias mamba="$MAMBA_EXE"  # Fallback on help from mamba activate
fi
unset __mamba_setup
# <<< mamba initialize <<<

# Added by Toolbox App
export PATH="$PATH:$HOME/Library/Application Support/JetBrains/Toolbox/scripts"

### ─── Terraform Plugin Cache Setup ──────────────────────────────────────

# Define the Terraform plugin cache directory
export TF_PLUGIN_CACHE_DIR="$HOME/.terraform.d/plugin-cache"

# Create the directory if it doesn't exist
if [[ ! -d "$TF_PLUGIN_CACHE_DIR" ]]; then
  mkdir -p "$TF_PLUGIN_CACHE_DIR"
fi

# ── Terraform Cache Utilities ──

# Show size of each cached provider (sorted)
alias tf-cache='du -sh "$TF_PLUGIN_CACHE_DIR"/* 2>/dev/null | sort -h'

# Show total size of the plugin cache
alias tf-cache-total='du -sh "$TF_PLUGIN_CACHE_DIR" 2>/dev/null'

# Dry-run: Show files older than 60 days (change +60 as needed)
alias tf-cache-dry='find "$TF_PLUGIN_CACHE_DIR" -type f -atime +60 -print'

# Clean cache files not accessed in 60+ days (use with care!)
alias tf-cache-clean='find "$TF_PLUGIN_CACHE_DIR" -type f -atime +60 -print -delete'

# Shortcut to open the plugin cache in your file browser (macOS)
alias tf-cache-open='open "$TF_PLUGIN_CACHE_DIR"'

# It is good to load these popular plugins last, and in this order:
zcomet load zsh-users/zsh-syntax-highlighting
zcomet load zsh-users/zsh-autosuggestions
zcomet load zsh-users/zsh-completions

# zprof

# Added by Antigravity
export PATH="/Users/flaviomartins/.antigravity/antigravity/bin:$PATH"
