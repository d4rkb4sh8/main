#!/bin/bash

# Configuration directory
CONFIG_DIR="$HOME/.config/system.config"

# Ensure CONFIG_DIR exists
mkdir -p $CONFIG_DIR

# Function to save .bashrc and .bash_aliases
save_dotfiles() {
    echo "Saving .bashrc and .bash_aliases..."
    cp ~/.bashrc $CONFIG_DIR/ 2>/dev/null
    cp ~/.bash_aliases $CONFIG_DIR/ 2>/dev/null
}

# Function to save Git repos
save_git_repos() {
    echo "Saving Git repositories..."
    mkdir -p $CONFIG_DIR/git_repos
    for repo in $(ls ~/); do
        if [ -d ~/$repo/.git ]; then
            git --git-dir=~/$repo/.git --work-tree=~/$(basename $repo) config 
--get remote.origin.url > $CONFIG_DIR/git_repos/$repo.url 2>/dev/null
        fi
    done
}

# Function to^[[B install APT packages
install_apt_packages() {
    echo "Installing APT packages..."^[[A
    sudo apt update
    sudo apt upgrade -y
    sudo apt install -y $(cat $CONFIG_DIR/apt_packages.txt 2>/dev/null)
}

# Function to save APT packages
save_apt_packages() {
    echo "Saving list of APT packages..."
    dpkg-query -l > $CONFIG_DIR/apt_packages.txt
}

# Function to install Homebrew packages
install_brew_packages() {
    if ! command -v brew &> /dev/null; then
        echo "Homebrew not found, please install it."
        return
    fi
    echo "Installing Homebrew packages..."
    cat $CONFIG_DIR/brew_packages.txt | xargs brew install
}

# Function to save Homebrew packages
save_brew_packages() {
    echo "Saving list of Homebrew packages..."
    brew list > $CONFIG_DIR/brew_packages.txt
}

# Function to install Flatpak packages
install_flatpak_packages() {
    echo "Installing Flatpak packages..."
    flatpak remote-add --if-not-exists flathub 
https://flathub.org/repo/flathub.flatpakrepo
    cat $CONFIG_DIR/flatpak_packages.txt | xargs flatpak install -y
}

# Function to save Flatpak packages
save_flatpak_packages() {
    echo "Saving list of Flatpak packages..."
    flatpak list --runtime > $CONFIG_DIR/flatpak_packages.txt
}

# Function to install Snap packages
install_snap_packages() {
    echo "Installing Snap packages..."
    sudo snap refresh
    cat $CONFIG_DIR/snap_packages.txt | xargs sudo snap install
}

# Function to save Snap packages
save_snap_packages() {
    echo "Saving list of Snap packages..."
    snap list > $CONFIG_DIR/snap_packages.txt
}

# Function to handle GTK settings
handle_gtk_settings() {
    echo "Setting up GTK settings..."
    mkdir -p $CONFIG_DIR/gtk-3.0
    cp ~/.config/gtk-3.0/* $CONFIG_DIR/gtk-3.0 2>/dev/null
}

# Main function to save all configurations
save_all() {
    save_dotfiles
    save_git_repos
    save_apt_packages
    save_brew_packages
    save_flatpak_packages
    save_snap_packages
    handle_gtk_settings
}

# Main function to restore all configurations
restore_all() {
    if [ -f $CONFIG_DIR/apt_packages.txt ]; then
        install_apt_packages
    fi
    if [ -f $CONFIG_DIR/brew_packages.txt ]; then
        install_brew_packages
    fi
    if [ -f $CONFIG_DIR/flatpak_packages.txt ]; then
        install_flatpak_packages
    fi
    if [ -f $CONFIG_DIR/snap_packages.txt ]; then
        install_snap_packages
    fi
    cp $CONFIG_DIR/.bashrc ~/. 2>/dev/null
    cp $CONFIG_DIR/.bash_aliases ~/. 2>/dev/null
    mkdir -p ~/$(basename $(cat $CONFIG_DIR/git_repos/*.url | head -n 1)) 
2>/dev/null
}

case "$1" in
    save)
        save_all
        ;;
    restore)
        restore_all
        ;;
    *)
        echo "Usage: $0 {save|restore}"
        exit 1
        ;;
esac
