# brew
eval "$(/opt/homebrew/bin/brew shellenv)"

# mactex
eval "$(/usr/libexec/path_helper)"

# sdkman
export SDKMAN_DIR='/opt/homebrew/opt/sdkman-cli/libexec'
[[ -s "${SDKMAN_DIR}/bin/sdkman-init.sh" ]] && source "${SDKMAN_DIR}/bin/sdkman-init.sh"

# jenv
export JENV_ROOT="$HOME/.jenv"
[[ -d $JENV_ROOT/bin ]] && export PATH="$JENV_ROOT/bin:$PATH"
eval "$(jenv init -)"

# pyenv
export PYENV_ROOT="$HOME/.pyenv"
[[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"
eval "$(pyenv virtualenv-init -)"

# local bin
export PATH="$PATH:$HOME/.local/bin"

# Added by Toolbox App
export PATH="$PATH:$HOME/Library/Application Support/JetBrains/Toolbox/scripts"
