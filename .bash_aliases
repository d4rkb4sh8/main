#   -------------------------------
#   1.  FILE AND FOLDER MANAGEMENT
#   -------------------------------

alias numFiles='echo $(ls -1 | wc -l)'       # numFiles:     Count of non-hidden files in current dir
alias make1mb='truncate -s 1m ./1MB.dat'     # make1mb:      Creates a file of 1mb size (all zeros)
alias make5mb='truncate -s 5m ./5MB.dat'     # make5mb:      Creates a file of 5mb size (all zeros)
alias make10mb='truncate -s 10m ./10MB.dat'  # make10mb:     Creates a file of 10mb size (all zeros)
alias z='zoxide'
alias bat='batcat --theme=Coldark-Dark  --style=full'
alias ff='fastfetch -c all'

#   ---------------------------
#   2.  SEARCHING
#   ---------------------------

alias qfind="find . -name "                 # qfind:    Quickly search for file
alias grep='grep --color=always'

#   ---------------------------
#   3.  PROCESS MANAGEMENT
#   ---------------------------

#   memHogsTop, memHogsPs:  Find memory hogs
#   -----------------------------------------------------
    alias memHogsTop='top -l 1 -o rsize | head -20'
    alias memHogsPs='ps wwaxm -o pid,stat,vsize,rss,time,command | head -10'

#   cpuHogs:  Find CPU hogs
#   -----------------------------------------------------
    alias cpu_hogs='ps wwaxr -o pid,stat,%cpu,time,command | head -10'

#   topForever:  Continual 'top' listing (every 10 seconds)
#   -----------------------------------------------------
    alias topForever='top -l 9999999 -s 10 -o cpu'

#   ttop:  Recommended 'top' invocation to minimize resources
#   ------------------------------------------------------------
#       Taken from this macosxhints article
#       http://www.macosxhints.com/article.php?story=20060816123853639
#   ------------------------------------------------------------
    alias ttop="top -R -F -s 10 -o rsize"


#   ---------------------------
#   4.  NETWORKING
#   ---------------------------

alias netCons='lsof -i'                         # netCons:      Show all open TCP/IP sockets
alias lsock='sudo lsof -i -P'                   # lsock:        Display open sockets
alias lsockU='sudo lsof -nP | grep UDP'         # lsockU:       Display only open UDP sockets
alias lsockT='sudo lsof -nP | grep TCP'         # lsockT:       Display only open TCP sockets
alias openPorts='sudo lsof -i | grep LISTEN'    # openPorts:    All listening connections
alias showBlocked='sudo ipfw list'              # showBlocked:  All ipfw rules inc/ blocked IPs
  alias ipInfo0='ifconfig getpacket en0'          # ipInfo0:      Get info on connections for en0
  alias ipInfo1='ifconfig getpacket wlan0'          # ipInfo1:      Get info on connections for wlan0
alias myip='curl ip-api.com'


#   ---------------------------------------
#   5.  SYSTEMS OPERATIONS & INFORMATION
#   ---------------------------------------

alias mountReadWrite='mount -uw /'    # mountReadWrite:   For use when booted into single-user


#   ---------------------------------------
#   6.  DATE & TIME MANAGEMENT
#   ---------------------------------------

alias bdate="date '+%a, %b %d %Y %T %Z'"
alias cal3='cal -3'
alias da='date "+%Y-%m-%d %A    %T %Z"'
alias daysleft='echo "There are $(($(date +%j -d"Dec 31, $(date +%Y)")-$(date +%j))) left in year $(date +%Y)."'
alias epochtime='date +%s'
alias mytime='date +%H:%M:%S'
alias secconvert='date -d@1234567890'
alias stamp='date "+%Y%m%d%a%H%M"'
alias timestamp='date "+%Y%m%dT%H%M%S"'
alias today='date +"%A, %B %-d, %Y"'
alias weeknum='date +%V'


#   ---------------------------------------
#   8.  WEB DEVELOPMENT
#   ---------------------------------------

alias editHosts='sudo edit /etc/hosts'                  # editHosts:        Edit /etc/hosts file

  alias apacheEdit='sudo edit /etc/httpd/httpd.conf'      # apacheEdit:       Edit httpd.conf
  alias apacheRestart='sudo apachectl graceful'           # apacheRestart:    Restart Apache
  alias herr='tail /var/log/httpd/error_log'              # herr:             Tails HTTP error logs
  alias apacheLogs="less +F /var/log/apache2/error_log"   # Apachelogs:       Shows apache error logs


#   ---------------------------------------
#   9.  OTHER ALIASES
#   ---------------------------------------

# Aliases by Jacob Hrbek
# Outputs List of Loadable Modules (llm) for current kernel
alias llm="find /lib/modules/$(uname -r) -type f -name '*.ko*'"

#  ---------------------------------------------------------------------------

alias perm='stat --printf "%a %n \n "'      # perm: Show permission of target in number
alias 000='chmod 000'                       # ---------- (nobody)
alias 640='chmod 640'                       # -rw-r----- (user: rw, group: r)
alias 644='chmod 644'                       # -rw-r--r-- (user: rw, group: r, other: r)
alias 755='chmod 755'                       # -rwxr-xr-x (user: rwx, group: rx, other: rx)
alias 775='chmod 775'                       # -rwxrwxr-x (user: rwx, group: rwx, other: rx)
alias mx='chmod a+x'                        # ---x--x--x (user: --x, group: --x, other: --x)
alias ux='chmod u+x'                        # ---x------ (user: --x, group: -, other: -)

#-----------------------------------------------------------------------
#GENERAL_TOOLS
#-----------------------------------------------------------------------
# update
alias update='sudo nala upgrade -y && sudo apt full-upgrade -y && flatpak upgrade && sudo snap refresh && rustup update && brew update && brew upgrade && sudo updatedb;figlet "machine is updated !"|lolcat'

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

# color ip command
alias ip='ip -c'

# ai  assistant
alias ai='tgpt'

# cheat sheet
alias cheat='tldr'

#zathura for pdf's
alias pdf='zathura'

# renaming - replace current extension
alias rnx='for i in *; do mv $i ${i%.*}.txt; done'

alias less='less -FSRXc'                    # Preferred 'less' implementation
alias wget='wget -c'                        # Preferred 'wget' implementation (resume download)
alias c='clear'                             # c:            Clear terminal display
alias path='echo -e ${PATH//:/\\n}'         # path:         Echo all executable Paths
alias show_options='shopt'                  # Show_options: display bash options settings
alias fix_stty='stty sane'                  # fix_stty:     Restore terminal settings when screwed up
alias fix_term='echo -e "\033c"'            # fix_term:     Reset the conosle.  Similar to the reset command
alias cic='bind "set completion-ignore-case on"' # cic:          Make tab-completion case-insensitive
alias src='source ~/.bashrc'                # src:          Reload .bashrc file

#-------------------------------------------------------------------------
#DEBIAN_ALIASES
#-------------------------------------------------------------------------
alias apup='sudo apt update'
alias apug='sudo apt upgrade'
alias apuu='sudo apt update && sudo apt upgrade'
alias apfu='sudo apt full-upgrade'

alias apin='sudo apt install'
alias apri='sudo apt install --reinstall'

alias aprm='sudo apt remove'
alias apur='sudo apt purge'
alias apar='sudo apt autoremove'
alias apcl='sudo apt-get autoclean'

alias apse='apt search'
alias apsh='apt show'
alias apsc='apt-get source'
alias apesr='sudo apt edit-sources'
alias apdl='apt-get download'

alias apbd='sudo apt build-deb'
alias aphst='cat /var/log/apt/history.log | less'

alias drcf='sudo dpkg-reconfigure'

alias upgrb='sudo update-grub'
alias uirfs='sudo update-initramfs -u'


#-------------------------------------------------------------------------
#DOCKER_ALIASES
#-------------------------------------------------------------------------
alias dbl='docker build'
alias dcin='docker container inspect'
alias dcls='docker container ls'
alias dclsa='docker container ls -a'
alias dib='docker image build'
alias dii='docker image inspect'
alias dils='docker image ls'
alias dipu='docker image push'
alias dirm='docker image rm'
alias dit='docker image tag'
alias dlo='docker container logs'
alias dnc='docker network create'
alias dncn='docker network connect'
alias dndcn='docker network disconnect'
alias dni='docker network inspect'
alias dnls='docker network ls'
alias dnrm='docker network rm'
alias dpo='docker container port'
alias dpu='docker pull'
alias dr='docker container run'
alias drit='docker container run -it'
alias drm='docker container rm'
alias 'drm!'='docker container rm -f'
alias dst='docker container start'
alias drs='docker container restart'
alias dsta='docker stop $(docker ps -q)'
alias dstp='docker container stop'
alias dtop='docker top'
alias dvi='docker volume inspect'
alias dvls='docker volume ls'
alias dvprune='docker volume prune'
alias dxc='docker container exec'
alias dxcit='docker container exec -it'

#-------------------------------------------------------------------------
# CTF's
#-------------------------------------------------------------------------
#pwn.college
alias sshpwn='ssh -i $HOME/.keys/pwn.college hacker@dojo.pwn.college'



#-------------------------------------------------------------------------
#H4CK3R_TOOLS
#-----------------------------------------------------------------------
#mproxy
alias mproxy='curl --proxy http://127.0.0.1:8080 '

#dnscan
alias dnscan='/home/h4ck3r/h4ck3r_setup/tools/dnscan/dnscan.py'

#subbrute
alias subbrute='/home/h4ck3r/h4ck3r_setup/tools/subbrute/subbrute.py'

#dirsearch
alias dirsearch='/home/h4ck3r/h4ck3r_setup/tools/dirsearch/dirsearch.py'

#RouterHunterBR
alias rhunter='php /home/h4ck3r/h4ck3r_setup/tools/RouterHunterBR/RouterHunterBR.php'


# cryptography

# rot13
alias rot13="tr 'A-Za-z' 'N-ZA-Mn-za-m'"
# rot13.5 (rot18)
alias rot18="tr 'A-Za-z0-9' 'N-ZA-Mn-za-m5-90-4'"
# rot47
alias rot47="tr '\!-~' 'P-~\!-O'"


# gtfo lookup
alias wads='gtfoblookup wadcoms search'
alias wadl='gtfoblookup wadcoms list'
alias hijacks='gtfoblookup hijacklibs search'
alias hijackl='gtfoblookup hijacklibs list'
alias gtfobs='gtfoblookup gtfobins search'
