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

# local bin
export PATH="$HOME/.local/bin:$PATH"

# npm global packages
export PATH=~/.npm-global/bin:$PATH

# Do not activate base environment by default
export CONDA_AUTO_ACTIVATE_BASE=false
