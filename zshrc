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
  if [[ "$OSTYPE" = darwin* ]]; then
    zcompdump_mtime=$(/usr/bin/stat -f '%m' "$ZSH_COMPDUMP" 2>/dev/null)
  else
    zcompdump_mtime=$(/usr/bin/stat -c '%Y' "$ZSH_COMPDUMP" 2>/dev/null)
  fi
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
export HISTFILE=~/.zsh_history
export HISTFILESIZE=50000
export HISTSIZE=50000
export HISTTIMEFORMAT="[%F %T] "
export HISTORY_IGNORE="(ls|ll|cd *|pwd|exit|clear)"

# PATH
typeset -U path PATH

path_contains() {
  local entry
  for entry in "${path[@]}"; do
    [[ "$entry" == "$1" ]] && return 0
  done
  return 1
}

path_prepend() {
  if [[ -d "$1" ]]; then
    if path_contains "$1"; then
      return 0
    fi
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

# Prefer libexec/gnubin (macOS Homebrew) but fall back to bin (Linux Homebrew).
path_prepend_gnu() {
  if [[ -d "$1/libexec/gnubin" ]]; then
    path_prepend "$1/libexec/gnubin"
  else
    path_prepend "$1/bin"
  fi
}

command_exists() {
  (( $+commands[$1] ))
}

# brew
export HOMEBREW_NO_ASK=1
export HOMEBREW_NO_ENV_HINTS=1
typeset -gi __HOMEBREW_FOUND=0
typeset -g __HOMEBREW_BREW_BIN=""
if [[ -x /opt/homebrew/bin/brew ]]; then
  __HOMEBREW_BREW_BIN="/opt/homebrew/bin/brew"
  eval "$(/opt/homebrew/bin/brew shellenv)"
  __HOMEBREW_FOUND=1
elif [[ -x /home/linuxbrew/.linuxbrew/bin/brew ]]; then
  __HOMEBREW_BREW_BIN="/home/linuxbrew/.linuxbrew/bin/brew"
  eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
  __HOMEBREW_FOUND=1
elif command_exists brew; then
  __HOMEBREW_BREW_BIN="${commands[brew]}"
  eval "$(brew shellenv)"
  __HOMEBREW_FOUND=1
fi

if (( __HOMEBREW_FOUND )); then
  # Prefer Homebrew's exported prefix; otherwise derive it from brew's absolute path.
  typeset -g BREW_PREFIX="${HOMEBREW_PREFIX:-${__HOMEBREW_BREW_BIN:h:h}}"

  # GNU coreutils/diffutils/findutils
  path_prepend_gnu "$BREW_PREFIX/opt/coreutils"
  # path_prepend_gnu "$BREW_PREFIX/opt/diffutils"
  # path_prepend_gnu "$BREW_PREFIX/opt/findutils"

  # Text processing
  path_prepend_gnu "$BREW_PREFIX/opt/gawk"
  path_prepend_gnu "$BREW_PREFIX/opt/gnu-indent"
  path_prepend_gnu "$BREW_PREFIX/opt/gnu-sed"
  path_prepend_gnu "$BREW_PREFIX/opt/grep"

  # File/archive/compression
  path_prepend_gnu "$BREW_PREFIX/opt/gnu-tar"
  path_prepend "$BREW_PREFIX/opt/unzip/bin"
  path_prepend "$BREW_PREFIX/opt/zip/bin"

  # System/build utilities
  path_prepend_gnu "$BREW_PREFIX/opt/gnu-time"
  path_prepend_gnu "$BREW_PREFIX/opt/gnu-which"
  path_prepend_gnu "$BREW_PREFIX/opt/make"
  path_prepend "$BREW_PREFIX/opt/util-linux/bin"

  # Networking/transfer
  path_prepend "$BREW_PREFIX/opt/curl/bin"
  path_prepend "$BREW_PREFIX/opt/ssh-copy-id/bin"

  # Crypto/TLS
  # Normalize OpenSSL aliases so only one canonical OpenSSL bin is kept in PATH.
  path=("${(@)path:#${BREW_PREFIX}/opt/openssl/bin}")
  path=("${(@)path:#${BREW_PREFIX}/opt/openssl@3/bin}")

  if [[ -d "$BREW_PREFIX/opt/openssl@3/bin" ]]; then
    path_prepend "$BREW_PREFIX/opt/openssl@3/bin"
  elif [[ -d "$BREW_PREFIX/opt/openssl/bin" ]]; then
    path_prepend "$BREW_PREFIX/opt/openssl/bin"
  fi

  # File/text helper tools
  path_prepend "$BREW_PREFIX/opt/ed/bin"
  path_prepend "$BREW_PREFIX/opt/file-formula/bin"
  path_prepend "$BREW_PREFIX/opt/gnu-getopt/bin"

  # Shell/terminal tools
  # Commands from bash/less/nano/screen remain available via Homebrew's bin directory.

  # Databases
  path_prepend "$BREW_PREFIX/opt/mysql-client@8.0/bin/"
  path_prepend "$BREW_PREFIX/opt/postgresql@18/bin"
  path_prepend "$BREW_PREFIX/opt/sqlite/bin"
fi

# go
export GOPATH="$HOME/go"
[[ -d $GOPATH/bin ]] && path_prepend "$GOPATH/bin"

# cargo
export CARGO_HOME="$HOME/.cargo"
[[ -d "$CARGO_HOME/bin" ]] && path_prepend "$CARGO_HOME/bin"

# sdkman
export SDKMAN_DIR="$HOME/.sdkman"

sdkman_add_current_bins() {
  local candidate_dir version_dir current_bin

  [[ -d "$SDKMAN_DIR/candidates" ]] || return 0

  for candidate_dir in "$SDKMAN_DIR"/candidates/*(/N); do
    [[ -d "$candidate_dir" ]] || continue

    current_bin="$candidate_dir/current/bin"
    if [[ -d "$current_bin" ]]; then
      path_prepend "$current_bin"
      continue
    fi

    for version_dir in "$candidate_dir"/*(/N); do
      [[ -d "$version_dir/bin" ]] || continue
      path_prepend "$version_dir/bin"
      break
    done
  done
}

# Make current SDKMAN candidate binaries (e.g. mvn, java, gradle) available
# even before the full SDKMAN init script is loaded.
sdkman_add_current_bins

load_sdkman() {
  [[ -n ${__SDKMAN_LOADED:-} ]] && return 0
  [[ -s "$SDKMAN_DIR/bin/sdkman-init.sh" ]] || return 1

  unset -f sdk 2>/dev/null
  source "$SDKMAN_DIR/bin/sdkman-init.sh"
  typeset -g __SDKMAN_LOADED=1
}

if [[ -s "$SDKMAN_DIR/bin/sdkman-init.sh" ]]; then
  sdk() { load_sdkman && sdk "$@"; }
fi

# It is good to load these popular plugins last, and in this order:
zcomet load zsh-users/zsh-autosuggestions
zcomet load zsh-users/zsh-syntax-highlighting

if (( $+commands[atuin] )); then
  autoload -Uz add-zsh-hook
  _load_atuin() {
    add-zsh-hook -d precmd _load_atuin
    eval "$(atuin init zsh)"
    unfunction _load_atuin
  }
  add-zsh-hook precmd _load_atuin
fi

# zprof

# local bin
path_prepend_optional "$HOME/.local/bin"

export PATH

# Lazy-load conda/mamba to keep interactive startup fast.
export _CONDA_ROOT="$HOME/miniforge3"
export MAMBA_ROOT_PREFIX="$HOME/miniforge3"

load_conda_stack() {
  [[ -n ${__CONDA_STACK_LOADED:-} ]] && return 0

  unset -f conda mamba 2>/dev/null

  if [[ -f "$_CONDA_ROOT/etc/profile.d/conda.sh" ]]; then
    . "$_CONDA_ROOT/etc/profile.d/conda.sh"
  fi

  if [[ -f "$_CONDA_ROOT/etc/profile.d/mamba.sh" ]]; then
    . "$_CONDA_ROOT/etc/profile.d/mamba.sh"
  fi

  typeset -g __CONDA_STACK_LOADED=1
  return 0
}

if [[ -x "$_CONDA_ROOT/bin/conda" || -x "$_CONDA_ROOT/bin/mamba" ]]; then
  conda() { load_conda_stack && conda "$@"; }
  mamba() { load_conda_stack && mamba "$@"; }
fi

eval "$(/Users/flaviomartins/.local/bin/mise activate zsh)" # added by https://mise.run/zsh
