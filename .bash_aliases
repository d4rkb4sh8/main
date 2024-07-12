# update
alias update='sudo nala upgrade -y && flatpak upgrade && sudo snap refresh && rustup update && sudo updatedb -v'

#clean
alias clean='sudo nala autopurge && sudo nala autoremove && sudo nala clean'

# a better ls
alias ls='eza --icons --git'
alias ll='eza -l --icons --git --header'
alias llog='eza -l --icons --git --header -og'
alias lt='eza --tree --level=2 --icons'
alias lsa='eza -a --icons --git'
alias lla='eza -la --icons --git --header'
alias llaog='eza -la --icons --git --header -og'
alias lta='eza -a --tree --level=2 --icons'

alias mproxy='curl --proxy http://127.0.0.1:8080 '


# cheat sheet
alias cheat='tldr'

alias pdf='zathura'

# renaming - replace current extension
alias rnx='for i in *; do mv $i ${i%.*}.txt; done'

# cryptography
# rot13
alias rot13="tr 'A-Za-z' 'N-ZA-Mn-za-m'"
# rot13.5 (rot18)
alias rot18="tr 'A-Za-z0-9' 'N-ZA-Mn-za-m5-90-4'"
# rot47
alias rot47="tr '\!-~' 'P-~\!-O'"

# color ip command
alias ip='ip -c'

# ai  assistant
alias ai='tgpt'

# gtfo lookup
alias wads='gtfoblookup wadcoms search'
alias wadl='gtfoblookup wadcoms list'
alias hijacks='gtfoblookup hijacklibs search'
alias hijackl='gtfoblookup hijacklibs list'
