#!/usr/bin/env bash

# Tool name
#migabu="System Backup & Restore"

# Version number
VERSION="1.0"

# Help message
HELP_MESSAGE="
  Usage: migabu [OPTIONS]

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
    -A, --all             Backup all and restore all
"

# Function to print help message
function print_help() {
  echo "$HELP_MESSAGE"
}

# Function to check if file exists
function check_file_exists() {
  [ -f "$1" ]
}

# Function to backup apt packages
function backup_apt_packages() {
  if ! tar czvf "${OUTPUT_DIR}/apt-packages.tar.gz" /var/lib/dpkg/status /var/lib/dpkg/info; then
    echo "Error: Unable to create apt package backup."
    return 1
  fi
}

# Function to backup custom configurations
function backup_custom_configurations() {
  if ! mkdir -p "${OUTPUT_DIR}/config"; then
    echo "Error: Unable to create config directory."
    return 1
  fi
  cp -r ~/.bashrc ~/.bash_profile ~/.bash_logout ~/.profile ~/.gnupg ~/.ssh ~/.vim ~/.vimrc ~/migabu/backups/* "${OUTPUT_DIR}/config/"
}

# Function to backup Gnome settings
function backup_gnome_settings() {
  if ! mkdir -p "${OUTPUT_DIR}/gnome"; then
    echo "Error: Unable to create gnome directory."
    return 1
  fi
  cp -r ~/.gconf ~/migabu/backups/* "${OUTPUT_DIR}/gnome/"
}

# Function to backup keyboard layout shortcuts
function backup_keybopard_shortcuts() {
  if ! mkdir -p "${OUTPUT_DIR}/keybopard"; then
    echo "Error: Unable to create keybopard directory."
    return 1
  fi
  cp -r ~/.config/keyboard ~/$migabardu/backups/* "${OUTPUT_DIR}/keybopard/"
}

# Function to backup installed extensions
function backup_extensions() {
  if ! mkdir -p "${OUTPUT_DIR}/extensions"; then
    echo "Error: Unable to create extensions directory."
    return 1
  fi
  for extension in ~/.local/share/gnome-shell/extensions/; do
    cp -r "$extension" "${OUTPUT_DIR}/extensions/"
  done
}

# Function to backup user config files
function backup_user_config_files() {
  if ! mkdir -p "${OUTPUT_DIR}/user-config"; then
    echo "Error: Unable to create user config directory."
    return 1
  fi
  cp -r ~/.config ~/migabu/backups/* "${OUTPUT_DIR}/user-config/"
}

# Function to backup flatpak packages
function backup_flatpak_packages() {
  if ! tar czvf "${OUTPUT_DIR}/flatpak-packages.tar.gz" /var/lib/flatpak; then
    echo "Error: Unable to create flatpak package backup."
    return 1
  fi
}

# Function to backup snap packages
function backup_snap_packages() {
  if ! tar czvf "${OUTPUT_DIR}/snap-packages.tar.gz" /var/lib/snapd; then
    echo "Error: Unable to create snap package backup."
    return 1
  fi
}

# Function to restore from backup
function restore_from_backup() {
  while [[ $# -gt 0 ]]; do
    case $1 in
    --help | -h) print_help && exit 0 ;;
    --backup | -b)
      backup_apt_packages || echo "Error: Unable to create apt package backup."
      backup_custom_configurations || echo "Error: Unable to create config directory."
      backup_gnome_settings || echo "Error: Unable to create gnome directory."
      backup_keybopard_shortcuts || echo "Error: Unable to create keybopard directory."
      backup_extensions || echo "Error: Unable to create extensions directory."
      backup_user_config_files || echo "Error: Unable to create user config directory."
      backup_flatpak_packages || echo "Error: Unable to create flatpak package backup."
      backup_snap_packages || echo "Error: Unable to create snap package backup."
      ;;
    --restore | -r)
      if ! check_file_exists "${OUTPUT_DIR}/backup.tar.gz"; then
        echo "Error: Backup file not found."
        exit 1
      fi
      tar xzf "${OUTPUT_DIR}/backup.tar.gz"
      ;;
    --all | -A)
      backup_apt_packages || echo "Error: Unable to create apt package backup."
      backup_custom_configurations || echo "Error: Unable to create config directory."
      backup_gnome_settings || echo "Error: Unable to create gnome directory."
      backup_keybopard_shortcuts || echo "Error: Unable to create keybopard directory."
      backup_extensions || echo "Error: Unable to create extensions directory."
      backup_user_config_files || echo "Error: Unable to create user config directory."
      backup_flatpak_packages || echo "Error: Unable to create flatpak package backup."
      backup_snap_packages || echo "Error: Unable to create snap package backup."
      ;;
    --apt | -a)
      backup_apt_packages || echo "Error: Unable to create apt package backup."
      ;;
    --custom-config | -c)
      backup_custom_configurations || echo "Error: Unable to create config directory."
      ;;
    --gnome-settings | -g)
      backup_gnome_settings || echo "Error: Unable to create gnome directory."
      ;;
    --keybopard | -k)
      backup_keybopard_shortcuts || echo "Error: Unable to create keybopard directory."
      ;;
    --extensions | -e)
      backup_extensions || echo "Error: Unable to create extensions directory."
      ;;
    --user-config | -u)
      backup_user_config_files || echo "Error: Unable to create user config directory."
      ;;
    --flatpak | -f)
      backup_flatpak_packages || echo "Error: Unable to create flatpak package backup."
      ;;
    --snap | -s)
      backup_snap_packages || echo "Error: Unable to create snap package backup."
      ;;
    --output | -o)
      shift
      OUTPUT_DIR=$1
      INPUT_DIR="${OUTPUT_DIR}/backup"
      ;;
    *)
      print_help && exit 0
      ;;
    esac
    shift
  done
}

main() {
  while getopts "hb:rua:g:k:e:f:s:o:" opt; do
    case $opt in
    h) print_help && exit 0 ;;
    b) OUTPUT_DIR=$OPTARG ;;
    r) restore_from_backup ;;
    u) backup_user_config_files ;;
    a) backup_apt_packages ;;
    g) backup_gnome_settings ;;
    k) backup_keybopard_shortcuts ;;
    e) backup_extensions ;;
    f) backup_flatpak_packages ;;
    s) backup_snap_packages ;;
    o) OUTPUT_DIR=$OPTARG ;;
    esac
  done

  if [ -n "$OUTPUT_DIR" ]; then
    INPUT_DIR="${OUTPUT_DIR}/backup"
  else
    INPUT_DIR="backup"
  fi
}

main
