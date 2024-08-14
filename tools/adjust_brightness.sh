#!/usr/bin/env bash
# add this to your bashrc or zshrc
#I have chosen the following shortcuts as they don't conflict with any other 
#keyboard shortcuts in debian but you can modify them to whatever you need. First try before you change.

#Brightness control from keybaord

gsettings set org.gnome.settings-daemon.plugins.media-keys screen-brightness-up "['<Ctrl><Super>Up']"
gsettings set org.gnome.settings-daemon.plugins.media-keys screen-brightness-down "['<Ctrl><Super>Down']"
