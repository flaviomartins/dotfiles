alias vi='nvim'
alias vim='nvim'

alias cat='bat'

alias lg='lazygit'

alias ls='uu-ls --color=auto'
alias ll='uu-ls -lh --color=auto'
alias lsa='uu-ls -lah --color=auto'

alias qget='NQDIR=~/Downloads nq aria2c -d ~/Downloads'
alias qwait='NQDIR=~/Downloads fq -q'

# Honeyman’s “idiom” command:
alias honey='sort | uniq -c | sort -rn'

alias pincode='shuf --random-source=/dev/urandom -i 0-9 -r -n 6 | paste -sd ""'
