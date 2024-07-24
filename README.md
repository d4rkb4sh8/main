All notes can be read with cat or bat/batcat
This script must be run from tilix/kitty/alacritty terminal emulator

to run my custom Debian bootstrap on a clean build. This build has been tested on Debian stable but should work with other branhces (testing/unstable) and Ubuntu/Kali etc or other debian derivative distros as well.

This installs Homebrew on your debian linux for a few packages that are not on debian repos eg. zellij dust etc.

Once complete you will have a system ready to apt, nala, brew with ai chat using tgpt. 

the script will do the following:
1.)  Remove Debian games bloatware and clean up
2.)  Update and upgrade the system
3.)  Install APT packages
4.)  clone repo to a folder called gitprojects/main
5.)  Add custom paths to .bashrc
6.)  Install Starship command prompt
7.)  Install Homebrew & packages
8.)  Install ble.sh - bash
9.)  Install VirtualBox & guest extensions - ##comment out if installing on a virtual machine
10.)  Download fonts and gnome themes
11.)  Install fastfetch
12.)  Install ulauncher with favorite extensions
13.)  Install tgpt
14.)  Install Rust
15.)  Copy bash aliases
16.)  Setup UFW
17.)  upgrade system & do final cleanup

also check the .bash_aliases file tyo see some of the aliases available

## HOW TO RUN INSTALL SCRIPT
1.)  download bootstrap.sh file

2.)  mv bootstrap.sh to $HOME folder

3.)  chmod +x bootstrap.sh

4.) ./bootstrap.sh
