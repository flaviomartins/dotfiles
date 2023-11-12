# brew
eval "$(/opt/homebrew/bin/brew shellenv)"

# jenv
export PATH="$HOME/.jenv/bin:$PATH"
eval "$(jenv init -)"

# pyenv
export PYENV_ROOT="$HOME/.pyenv"
[[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"
eval "$(pyenv virtualenv-init -)"

# Added by Toolbox App
export PATH="$PATH:/Users/flaviomartins/Library/Application Support/JetBrains/Toolbox/scripts"
