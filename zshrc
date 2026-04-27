# zmodload zsh/zprof

# Performance optimizations
DISABLE_AUTO_UPDATE="true"
DISABLE_MAGIC_FUNCTIONS="true"
DISABLE_COMPFIX="true"

# Autosuggestions performance optimizations
ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE="20"
ZSH_AUTOSUGGEST_MANUAL_REBIND=1
ZSH_AUTOSUGGEST_USE_ASYNC=1

# Clone zcomet if necessary.
# Keep this above the instant prompt block because first-run bootstrapping may touch the network.
typeset -g ZCOMET_FILE="${ZDOTDIR:-${HOME}}/.zcomet/bin/zcomet.zsh"

if [[ ! -r "$ZCOMET_FILE" ]]; then
  if (( $+commands[git] )); then
    command git clone https://github.com/agkozak/zcomet.git "${ZDOTDIR:-${HOME}}/.zcomet/bin" 2>/dev/null || \
      print -u2 "warning: unable to bootstrap zcomet; continuing without plugin manager"
  else
    print -u2 "warning: git not found; unable to bootstrap zcomet"
  fi
fi

# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Initialize zcomet
if [[ -r "$ZCOMET_FILE" ]]; then
  source "$ZCOMET_FILE"
else
  zcomet() { return 0; }
fi

# Load some plugins
zcomet load agkozak/zsh-z
zcomet load atuinsh/atuin

# direnv plugin settings
zstyle :omz:plugins:direnv mode export
zcomet load ohmyzsh/ohmyzsh plugins/direnv

# The Oh My Zsh ssh-agent plugin expects SHORT_HOST but does not need the full OMZ bootstrap.
if [[ "$OSTYPE" = darwin* ]]; then
  SHORT_HOST=$(scutil --get LocalHostName 2>/dev/null) || SHORT_HOST="${HOST/.*/}"
else
  SHORT_HOST="${HOST/.*/}"
fi

# ssh-agent plugin settings
zstyle :omz:plugins:ssh-agent quiet yes
zstyle :omz:plugins:ssh-agent lazy yes
zstyle :omz:plugins:ssh-agent agent-forwarding yes
zcomet load ohmyzsh/ohmyzsh plugins/ssh-agent

# Better host completion for ssh
zcomet load sunlei/zsh-ssh

# Powerlevel10k
zcomet load romkatv/powerlevel10k

# Load additional completion definitions before compinit.
zcomet load zsh-users/zsh-completions

# The following lines have been added by Docker Desktop to enable Docker CLI completions.
[[ -d "$HOME/.docker/completions" ]] && fpath=("$HOME/.docker/completions" $fpath)
# End of Docker CLI completions

# Run compinit and compile its cache (cache completions aggressively)
autoload -Uz compinit
typeset -g ZSH_COMPDUMP="${ZDOTDIR:-$HOME}/.zcompdump"
typeset -g ZSH_COMPINIT_REFRESH_SECONDS=$((7 * 24 * 60 * 60))
typeset -gi zcompdump_mtime=0

if [[ -f "$ZSH_COMPDUMP" ]]; then
  zcompdump_mtime=$(/usr/bin/stat -f '%m' "$ZSH_COMPDUMP" 2>/dev/null)
fi
if (( EPOCHSECONDS - zcompdump_mtime > ZSH_COMPINIT_REFRESH_SECONDS )); then
  compinit -d "$ZSH_COMPDUMP"
  zcompile "$ZSH_COMPDUMP" &! 2>/dev/null
else
  compinit -C -d "$ZSH_COMPDUMP"
fi

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# fzf
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# You may need to manually set your language environment.
# Avoid LC_ALL globally so category-specific locale settings can still apply.
export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
export EDITOR='nvim'
export VISUAL="$EDITOR"

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
export HISTORY_IGNORE="(ls|ll|cd *|pwd|exit|clear)"

# PATH
typeset -U path PATH

path_prepend() {
  if [[ -d "$1" ]]; then
    path=("$1" $path)
  else
    print -u2 "warning: PATH entry does not exist: $1"
  fi
}

# Optional bin warning mode:
# 1 (default) => suppress missing-directory warnings for optional bins.
# 0 => show warnings to audit optional bins that are currently missing.
typeset -gi ZSH_PATH_OPTIONAL_QUIET=${ZSH_PATH_OPTIONAL_QUIET:-1}

path_prepend_optional() {
  if [[ -d "$1" ]]; then
    path=("$1" $path)
  elif (( ZSH_PATH_OPTIONAL_QUIET == 0 )); then
    print -u2 "warning: optional PATH entry does not exist: $1"
  fi
}

command_exists() {
  (( $+commands[$1] ))
}

# brew
export HOMEBREW_NO_ENV_HINTS=1
if [[ -x /opt/homebrew/bin/brew ]]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
fi

# Core POSIX/GNU userland replacements
# (Keep one family active: GNU *or* uutils)

# GNU coreutils/diffutils/findutils (alternative to uutils)
# path_prepend "/opt/homebrew/opt/coreutils/libexec/gnubin"
# path_prepend "/opt/homebrew/opt/diffutils/libexec/gnubin"
# path_prepend "/opt/homebrew/opt/findutils/libexec/gnubin"

# uutils (Rust replacements)
path_prepend "/opt/homebrew/opt/uutils-coreutils/libexec/uubin"
path_prepend "/opt/homebrew/opt/uutils-diffutils/libexec/uubin"
path_prepend "/opt/homebrew/opt/uutils-findutils/libexec/uubin"

# Text processing
path_prepend "/opt/homebrew/opt/gawk/libexec/gnubin"
path_prepend "/opt/homebrew/opt/gnu-indent/libexec/gnubin"
path_prepend "/opt/homebrew/opt/gnu-sed/libexec/gnubin"
path_prepend "/opt/homebrew/opt/grep/libexec/gnubin"

# File/archive/compression
path_prepend "/opt/homebrew/opt/gnu-tar/libexec/gnubin"
path_prepend "/opt/homebrew/opt/unzip/bin"
path_prepend "/opt/homebrew/opt/zip/bin"

# System/build utilities
path_prepend "/opt/homebrew/opt/gnu-time/libexec/gnubin"
path_prepend "/opt/homebrew/opt/gnu-which/libexec/gnubin"
path_prepend "/opt/homebrew/opt/make/libexec/gnubin"
path_prepend "/opt/homebrew/opt/util-linux/bin"

# Networking/transfer
path_prepend "/opt/homebrew/opt/curl/bin"
path_prepend "/opt/homebrew/opt/inetutils/libexec/gnubin"
path_prepend "/opt/homebrew/opt/ssh-copy-id/bin"

# Crypto/TLS
# Normalize OpenSSL aliases so only one canonical OpenSSL bin is kept in PATH.
path=("${(@)path:#/opt/homebrew/opt/openssl/bin}")
path=("${(@)path:#/opt/homebrew/opt/openssl@3/bin}")

if [[ -d "/opt/homebrew/opt/openssl@3/bin" ]]; then
  path_prepend "/opt/homebrew/opt/openssl@3/bin"
elif [[ -d "/opt/homebrew/opt/openssl/bin" ]]; then
  path_prepend "/opt/homebrew/opt/openssl/bin"
fi

# File/text helper tools
path_prepend "/opt/homebrew/opt/binutils/bin"
path_prepend "/opt/homebrew/opt/ed/bin"
path_prepend "/opt/homebrew/opt/file-formula/bin"
path_prepend "/opt/homebrew/opt/gnu-getopt/bin"

# Shell/terminal tools
# Commands from bash/less/nano/screen remain available via /opt/homebrew/bin.

# Databases
path_prepend "/opt/homebrew/opt/mysql@8.0/bin"
path_prepend "/opt/homebrew/opt/postgresql@18/bin"
path_prepend "/opt/homebrew/opt/sqlite/bin"

# go
export GOPATH="$HOME/go"
[[ -d $GOPATH/bin ]] && path_prepend "$GOPATH/bin"

# pipenv
export PIPENV_VENV_IN_PROJECT=1

# pipx
PIPX_HOME="$HOME/.local/pipx"
[[ -d $PIPX_HOME ]] && export PIPX_HOME

# pyenv
export PYTHON_CFLAGS="-O3 -march=native -mtune=native"
export PYTHON_CONFIGURE_OPTS="--enable-shared --enable-optimizations --with-lto"
export PYENV_ROOT="$HOME/.pyenv"
[[ -d $PYENV_ROOT/bin ]] && path_prepend "$PYENV_ROOT/bin"
[[ -d $PYENV_ROOT/shims ]] && path_prepend "$PYENV_ROOT/shims"

load_pyenv_stack() {
  [[ -n ${__PYENV_STACK_LOADED:-} ]] && return 0

  unset -f pyenv 2>/dev/null

  if command_exists pyenv; then
    eval "$(pyenv init - zsh)"
    [[ -d "$PYENV_ROOT/plugins/pyenv-virtualenv" ]] && eval "$(pyenv virtualenv-init -)"
    typeset -g __PYENV_STACK_LOADED=1
    return 0
  fi

  return 1
}

if [[ -d $PYENV_ROOT ]]; then
  pyenv() { load_pyenv_stack && pyenv "$@"; }
fi

# Node Version Manager (nvm)
export NVM_DIR="$HOME/.nvm"
autoload -U add-zsh-hook

load_nvm() {
  [[ -n ${__NVM_LOADED:-} ]] && return 0
  [[ -s "$NVM_DIR/nvm.sh" ]] || return 1

  unset -f nvm node npm npx corepack pnpm yarn yarnpkg 2>/dev/null
  . "$NVM_DIR/nvm.sh" --no-use
  typeset -g __NVM_LOADED=1
}

find_nvmrc() {
  local dir="$PWD"

  while true; do
    [[ -f "$dir/.nvmrc" ]] && {
      print -r -- "$dir/.nvmrc"
      return 0
    }
    [[ $dir == / ]] && return 1
    dir=${dir:h}
  done
}

load-nvmrc() {
  local nvmrc_path
  nvmrc_path="$(find_nvmrc)"

  if [[ -n $nvmrc_path ]]; then
    load_nvm || return

    local nvmrc_node_version
    nvmrc_node_version="$(nvm version "$(<"$nvmrc_path")")"

    if [[ $nvmrc_node_version == "N/A" ]]; then
      nvm install --no-progress
    elif [[ $nvmrc_node_version != "$(nvm version)" ]]; then
      nvm use --silent
    fi
    typeset -g __NVM_AUTO_USE_ACTIVE=1
  elif [[ -n ${__NVM_AUTO_USE_ACTIVE:-} ]]; then
    load_nvm || return

    if [[ "$(nvm version)" != "$(nvm version default)" ]]; then
      nvm use default --silent
    fi
    unset __NVM_AUTO_USE_ACTIVE
  fi
}

if [[ -s "$NVM_DIR/nvm.sh" ]]; then
  nvm() { load_nvm && nvm "$@"; }
  node() { load_nvm && node "$@"; }
  npm() { load_nvm && npm "$@"; }
  npx() { load_nvm && npx "$@"; }
  corepack() { load_nvm && corepack "$@"; }
  pnpm() { load_nvm && pnpm "$@"; }
  yarn() { load_nvm && yarn "$@"; }
  yarnpkg() { load_nvm && yarnpkg "$@"; }

  add-zsh-hook chpwd load-nvmrc
  load-nvmrc
fi

# rbenv
export RUBY_CFLAGS="-O3 -march=native -mtune=native"
export RBENV_ROOT="$HOME/.rbenv"
[[ -d $RBENV_ROOT/bin ]] && path_prepend "$RBENV_ROOT/bin"
[[ -d $RBENV_ROOT/shims ]] && path_prepend "$RBENV_ROOT/shims"

load_rbenv_stack() {
  [[ -n ${__RBENV_STACK_LOADED:-} ]] && return 0

  unset -f rbenv 2>/dev/null

  if command_exists rbenv; then
    eval "$(rbenv init - zsh)"
    typeset -g __RBENV_STACK_LOADED=1
    return 0
  fi

  return 1
}

if [[ -d $RBENV_ROOT ]]; then
  rbenv() { load_rbenv_stack && rbenv "$@"; }
fi

# sdkman
export SDKMAN_DIR="$HOME/.sdkman"

sdkman_add_current_bins() {
  local candidate_dir current_bin

  [[ -d "$SDKMAN_DIR/candidates" ]] || return 0

  for candidate_dir in "$SDKMAN_DIR"/candidates/*(N); do
    current_bin="$candidate_dir/current/bin"
    [[ -d $current_bin ]] && path_prepend "$current_bin"
  done
}

load_sdkman() {
  [[ -n ${__SDKMAN_LOADED:-} ]] && return 0
  [[ -s "$SDKMAN_DIR/bin/sdkman-init.sh" ]] || return 1

  unset -f sdk 2>/dev/null
  source "$SDKMAN_DIR/bin/sdkman-init.sh"
  typeset -g __SDKMAN_LOADED=1
}

sdkman_add_current_bins

if [[ -s "$SDKMAN_DIR/bin/sdkman-init.sh" ]]; then
  sdk() { load_sdkman && sdk "$@"; }
fi

# It is good to load these popular plugins last, and in this order:
zcomet load zsh-users/zsh-autosuggestions
zcomet load zsh-users/zsh-syntax-highlighting

# zprof

# cargo bin
path_prepend_optional "$HOME/.cargo/bin"

# local bin
path_prepend_optional "$HOME/.local/bin"

# Added by Toolbox App
path_prepend_optional "$HOME/Library/Application Support/JetBrains/Toolbox/scripts"

# Added by Antigravity
path_prepend_optional "$HOME/.antigravity/antigravity/bin"

export PATH

# Lazy-load conda/mamba to keep interactive startup fast.
export MAMBA_EXE="$HOME/miniforge3/bin/mamba"
export MAMBA_ROOT_PREFIX="$HOME/miniforge3"

load_conda_stack() {
  [[ -n ${__CONDA_STACK_LOADED:-} ]] && return 0

  local conda_bin="$HOME/miniforge3/bin/conda"
  local __conda_setup __mamba_setup

  unset -f conda mamba 2>/dev/null

  if [[ -x $conda_bin ]]; then
    if __conda_setup="$("$conda_bin" shell.zsh hook 2> /dev/null)"; then
      eval "$__conda_setup"
    elif [[ -f "$HOME/miniforge3/etc/profile.d/conda.sh" ]]; then
      . "$HOME/miniforge3/etc/profile.d/conda.sh"
    else
      path_prepend "$HOME/miniforge3/bin"
    fi
  fi

  if [[ -x $MAMBA_EXE ]]; then
    if __mamba_setup="$("$MAMBA_EXE" shell hook --shell zsh --root-prefix "$MAMBA_ROOT_PREFIX" 2> /dev/null)"; then
      eval "$__mamba_setup"
    else
      mamba() {
        "$MAMBA_EXE" "$@"
      }
    fi
  fi

  typeset -g __CONDA_STACK_LOADED=1
}

if [[ -x "$HOME/miniforge3/bin/conda" || -x "$MAMBA_EXE" ]]; then
  conda() { load_conda_stack && conda "$@"; }
  mamba() { load_conda_stack && mamba "$@"; }
fi
