# brew
eval "$(/opt/homebrew/bin/brew shellenv)"

# jenv
export JENV_ROOT="$HOME/.jenv"
[[ -d $JENV_ROOT/bin ]] && export PATH="$JENV_ROOT/bin:$PATH"
eval "$(jenv init -)"

# pyenv
export PYENV_ROOT="$HOME/.pyenv"
[[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"
eval "$(pyenv virtualenv-init -)"

# Added by Toolbox App
export PATH="$PATH:/Users/flaviomartins/Library/Application Support/JetBrains/Toolbox/scripts"
