#!/bin/bash

set -e  # Exit immediately if a command exits with a non-zero status

log() {
    echo "[$(date +'%Y-%m-%dT%H:%M:%S%z')] $*"
}

# Remove Debian games bloatware and clean up
log "Removing bloatware and cleaning up..."
sudo apt purge -y gnome-games libreoffice*
sudo apt autoremove -y
sudo apt autoclean -y

# Update and upgrade the system
log "Updating and upgrading the system..."
sudo apt update -y && sudo apt upgrade -y && sudo apt autoremove -y && sudo apt autoclean -y

# Define APT packages
APT_PACKAGES="python3-websocket wmctrl python3-levenshtein stow figlet lynis gawk curl wget git alacritty fd-find powerline* nala net-tools forensics-all cpufetch btop gnome-shell-extension-manager flatpak gnome-software-plugin-flatpak gh lolcat fd-find sd npm vlc build-essential procps file net-tools httpie mitmproxy gpaste-2 font-manager gdebi ufw gawk cmake plocate bat most libssl-dev libvips-dev libsixel-dev libchafa-dev libtbb-dev ufw"

# Install APT packages
log "Installing APT packages..."
sudo apt install -y $APT_PACKAGES

#clone repo
mkdir $HOME/gitprojects; cd $HOME/gitprojects; git clone https://github.com/d4rkb4sh8/main.git 

# Add custom paths to .bashrc
echo 'export PATH=$PATH:/opt:/usr/local/bin' >> ~/.bashrc

# Install Starship
log "Installing Starship..."
curl -sS https://starship.rs/install.sh | sh
echo 'eval "$(starship init bash)"' >> ~/.bashrc
starship preset nerd-font-symbols -o ~/.config/starship.toml

# Install Homebrew
log "Installing Homebrew..."
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
echo 'eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"' >> ~/.bashrc
eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"

# Define Homebrew packages
HOMEBREW_PACKAGES="lazygit gcc dust dog eza zellij neovim xh yazi ripgrep zoxide tlrc"
# Install Homebrew packages
log "Installing Homebrew packages..."
brew install $HOMEBREW_PACKAGES

# Install ble.sh
log "Installing ble.sh..."
git clone --recursive https://github.com/akinomyoga/ble.sh.git
cd ble.sh
make
echo 'source ~/.local/share/blesh/ble.sh' >> ~/.bashrc

# Install VirtualBox
log "Installing VirtualBox..."
wget -q https://www.virtualbox.org/download/oracle_vbox_2016.asc -O- | sudo apt-key add -
wget -q https://www.virtualbox.org/download/oracle_vbox.asc -O- | sudo apt-key add -
sudo add-apt-repository "deb http://download.virtualbox.org/virtualbox/debian $(lsb_release -cs) contrib"
sudo apt-get update
sudo apt-get install -y virtualbox-7.0

# Install VBox Guest Extension
log "Installing VBox Guest Extension..."
vbox_version=$(vboxmanage -v | cut -dr -f1)
wget https://download.virtualbox.org/virtualbox/$vbox_version/Oracle_VM_VirtualBox_Extension_Pack-$vbox_version.vbox-extpack
sudo vboxmanage extpack install Oracle_VM_VirtualBox_Extension_Pack-$vbox_version.vbox-extpack
vboxmanage list extpacks
sudo usermod -aG vboxusers $USER

# Download fonts and themes
log "Installing themes and fonts..."
cd $HOME/Downloads
wget https://github.com/ryanoasis/nerd-fonts/releases/download/v2.1.0/Hack.zip
unzip Hack.zip -d ~/.local/share/fonts
fc-cache -fv

# Install GNOME themes
log "Installing GNOME themes..."
cd $HOME/Downloads
git clone https://github.com/vinceliuice/Tela-icon-theme.git && cd Tela-icon-theme && ./install.sh
cd $HOME/Downloads
git clone https://github.com/vinceliuice/Orchis-theme.git && cd Orchis-theme && ./install.sh --tweaks macos

# Install fastfetch
log "Installing fastfetch..."
wget https://github.com/fastfetch-cli/fastfetch/releases/download/2.13.2/fastfetch-linux-amd64.deb
sudo dpkg -i fastfetch-linux-amd64.deb

# Install ulauncher
log "Installing ulauncher..."
wget https://github.com/Ulauncher/Ulauncher/releases/download/5.15.7/ulauncher_5.15.7_all.deb
cp -r $HOME/gitprojects/main/ulauncher $HOME/.config/

# Install tgpt
log "Installing tgpt..."
wget https://github.com/nomic-ai/tgpt/releases/download/v0.3.1/tgpt_0.3.1_linux_amd64.deb
sudo dpkg -i tgpt_0.3.1_linux_amd64.deb

# Install Rust
log "Installing Rust..."
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
source "$HOME/.cargo/env"
echo 'source "$HOME/.cargo/env"' >> ~/.bashrc

#install lazyvim
git clone https://github.com/LazyVim/starter ~/.config/nvim
rm -rf ~/.config/nvim/.git

# Copy bash aliases
log "Copying bash aliases..."
cp $HOME/gitprojects/main/.bash_aliases $HOME/

# Setup UFW
log "Setting up UFW..."
sudo ufw limit 22/tcp
sudo ufw allow 80/tcp
sudo ufw allow 443/tcp
sudo ufw default deny incoming
sudo ufw default allow outgoing
sudo ufw enable

# Upgrade system with nala
log "Upgrading system with nala..."
sudo nala upgrade -y

# Final update and clean up
log "Final update and clean up..."
sudo apt update -y && sudo apt upgrade -y && sudo apt autoremove -y && sudo apt autoclean -y

# Display message
figlet "The Machine is Ready."
