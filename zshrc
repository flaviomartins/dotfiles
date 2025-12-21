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
[ -f ~/.aliases.zsh ] && source ~/.aliases.zsh

# Terraform
[ -f ~/.terraform.zsh ] && source ~/.terraform.zsh

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

# brew
export HOMEBREW_NO_ENV_HINTS=1
eval "$(/opt/homebrew/bin/brew shellenv)"

# go
export GOPATH="$HOME/go"
[[ -d $GOPATH/bin ]] && export PATH="$GOPATH/bin:$PATH"

# pipenv
export PIPENV_VENV_IN_PROJECT=1

# pipx
PIPX_HOME="$HOME/.local/pipx"
[[ -d $PIPX_HOME ]] && export PIPX_HOME

# pyenv
export PYTHON_CFLAGS="-O3 -march=native -mtune=native"
export PYTHON_CONFIGURE_OPTS="--enable-shared --enable-optimizations --with-lto"
export PYENV_ROOT="$HOME/.pyenv"
[[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init - zsh)"
eval "$(pyenv virtualenv-init -)"

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

# rbenv
export RUBY_CFLAGS="-O3 -march=native -mtune=native"
eval "$(rbenv init - zsh)"

# sdkman
export SDKMAN_DIR="$HOME/.sdkman"
[[ -s "$SDKMAN_DIR/bin/sdkman-init.sh" ]] && source "$SDKMAN_DIR/bin/sdkman-init.sh"

# It is good to load these popular plugins last, and in this order:
zcomet load zsh-users/zsh-syntax-highlighting
zcomet load zsh-users/zsh-autosuggestions
zcomet load zsh-users/zsh-completions

# zprof

# Added by Toolbox App
export PATH="$PATH:$HOME/Library/Application Support/JetBrains/Toolbox/scripts"

# Added by Antigravity
export PATH="/Users/flaviomartins/.antigravity/antigravity/bin:$PATH"

# local bin
export PATH="$HOME/.local/bin:$PATH"
