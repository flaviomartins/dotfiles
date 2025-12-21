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

# rbenv
export RUBY_CFLAGS="-O3 -march=native -mtune=native"
eval "$(rbenv init - zsh)"

# sdkman
export SDKMAN_DIR="$HOME/.sdkman"
[[ -s "$SDKMAN_DIR/bin/sdkman-init.sh" ]] && source "$SDKMAN_DIR/bin/sdkman-init.sh"
