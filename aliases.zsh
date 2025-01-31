alias vi='nvim'
alias vim='nvim'

alias cat='bat'

alias lg='lazygit'
alias ls="eza"
alias ls='eza -G'
alias ll='eza -lG'
alias lsa='eza -lahG'

alias qget='NQDIR=~/Downloads nq aria2c -d ~/Downloads'
alias qwait='NQDIR=~/Downloads fq -q'

# Honeyman’s “idiom” command:
alias honey='sort | uniq -c | sort -rn'

alias pincode='shuf --random-source=/dev/urandom -i 0-9 -r -n 6 | paste -sd ""'
