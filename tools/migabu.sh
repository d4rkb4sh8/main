#!/usr/bin/env bash

# Tool name
migabu="System Backup & Restore"

# Version number
VERSION="1.0"

# Help message
HELP_MESSAGE="
  Usage: $migabu [OPTIONS]

  Options:
    -h, --help            Show this help message and exit
    -b, --backup          Backup all customizations (default)
    -r, --restore         Restore from backup
    -a, --apt              Backup apt packages
    -c, --custom-config   Backup custom configurations
    -g, --gnome-settings  Backup Gnome settings
    -k, --keybopard       Backup keyboard shortcuts
    -e, --extensions      Backup installed extensions
    -u, --user-config     Backup user config files
    -f, --flatpak         Backup flatpak packages
    -s, --snap            Backup snap packages
    -o, --output          Specify output directory for backup (default: /home/$USER/Backup)
"

# Functions

function backup_apt_packages() {
  echo "Backing up apt packages..."
  tar -czvf "$OUTPUT_DIR/apt-packages.tar.gz" /var/lib/dpkg/status /var/lib/dpkg/info
}

function backup_custom_configurations() {
  echo "Backing up custom configurations..."
  mkdir -p "$OUTPUT_DIR/config"
  cp -r ~/.bashrc ~/.bash_profile ~/.bash_logout ~/.profile ~/.gnupg ~/.ssh ~/.vim ~/.vimrc ~/$migabu/backups/* /home/$USER/Backup/config/
}

function backup_gnome_settings() {
  echo "Backing up Gnome settings..."
  mkdir -p "$OUTPUT_DIR/gnome"
  cp -r ~/.config/gnome-3-2/settings.db ~/.gconf ~/.gnome2/dconf ~/.gsettingsd ~/$migabu/backups/* /home/$USER/Backup/gnome/
}

function backup_keybopard_shortcuts() {
  echo "Backing up keyboard shortcuts..."
  mkdir -p "$OUTPUT_DIR/keybopard"
  cp -r ~/.config/keyboard-layouts ~/.keybopard /home/$USER/Backup/keybopard/
}

function backup_extensions() {
  echo "Backing up installed extensions..."
  mkdir -p "$OUTPUT_DIR/extensions"
  for ext in $(flatpak list --columns=app id); do
    flatpak install --user $ext --no-runtime
  done
}

function backup_user_config_files() {
  echo "Backing up user config files..."
  mkdir -p "$OUTPUT_DIR/user-config"
  cp -r ~/* /home/$USER/Backup/user-config/
}

function restore_apt_packages() {
  echo "Restoring apt packages..."
  tar xzvf "$INPUT_DIR/apt-packages.tar.gz" -C /
}

function restore_custom_configurations() {
  echo "Restoring custom configurations..."
  mkdir -p "/home/$USER"
  cp -r $INPUT_DIR/config/* /home/$USER/
}

function restore_gnome_settings() {
  echo "Restoring Gnome settings..."
  mkdir -p "/home/$USER"
  cp -r $INPUT_DIR/gnome/* /home/$USER/
}

function restore_keybopard_shortcuts() {
  echo "Restoring keyboard shortcuts..."
  mkdir -p "/home/$USER"
  cp -r $INPUT_DIR/keybopard/* /home/$USER/
}

function restore_extensions() {
  echo "Restoring installed extensions..."
  for ext in $(flatpak list --columns=app id); do
    flatpak remove $ext --no-runtime
  done
}

function restore_user_config_files() {
  echo "Restoring user config files..."
  mkdir -p "/home/$USER"
  cp -r $INPUT_DIR/user-config/* /home/$USER/
}

# Main script

OUTPUT_DIR="/home/$USER/Backup"
INPUT_DIR="/home/$USER/Input"

while getopts ":hbacrfgkeuofs" opt; do
  case $opt in
  h)
    echo "$HELP_MESSAGE"
    exit
    ;;
  b) backup_custom_configurations && backup_gnome_settings && backup_keybopard_shortcuts && backup_extensions && backup_user_config_files && backup_apt_packages &&
    backup_flatpak_packages && backup_snap_packages ;;
  r) restore_custom_configurations && restore_gnome_settings && restore_keybopard_shortcuts && restore_extensions && restore_user_config_files && restore_apt_packages ;;
  a) backup_apt_packages ;;
  c) backup_custom_configurations ;;
  g) backup_gnome_settings ;;
  k) backup_keybopard_shortcuts ;;
  e) backup_extensions ;;
  u) backup_user_config_files ;;
  f) backup_flatpak_packages ;;
  s) backup_snap_packages ;;
  o) OUTPUT_DIR=$OPTARG ;;
  esac
done

echo "Tool $migabu version $VERSION"
