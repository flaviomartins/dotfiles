# brew
eval "$(/opt/homebrew/bin/brew shellenv)"

# go
export GOPATH="$HOME/go"
[[ -d $GOPATH/bin ]] && export PATH="$GOPATH/bin:$PATH"

# pipx
PIPX_HOME="$HOME/.local/pipx"
[[ -d $PIPX_HOME ]] && export PIPX_HOME

# pyenv
export PYTHON_CFLAGS="-march=native -mtune=native"
export PYTHON_CONFIGURE_OPTS="--enable-optimizations --with-lto"
export PYENV_ROOT="$HOME/.pyenv"
[[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"
eval "$(pyenv virtualenv-init -)"

# pipenv
export PIPENV_VENV_IN_PROJECT=1

# rbenv
eval "$(rbenv init - zsh)"

# sdkman
export SDKMAN_DIR="$HOME/.sdkman"
[[ -s "$SDKMAN_DIR/bin/sdkman-init.sh" ]] && source "$SDKMAN_DIR/bin/sdkman-init.sh"

# Added by Toolbox App
export PATH="$PATH:$HOME/Library/Application Support/JetBrains/Toolbox/scripts"
