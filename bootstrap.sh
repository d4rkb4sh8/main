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
APT_PACKAGES="fastfetch stow figlet lynis gawk curl wget git alacritty powerline* nala net-tools forensics-all cpufetch btop gnome-shell-extension-manager flatpak gnome-software-plugin-flatpak gh lolcat fd-find sd npm vlc build-essential procps file net-tools httpie mitmproxy gpaste-2 font-manager gdebi ufw gawk cmake plocate bat most libssl-dev libvips-dev libsixel-dev libchafa-dev libtbb-dev ufw"

# Install APT packages
log "Installing APT packages..."
sudo apt install -y $APT_PACKAGES

#export $PATH
echo 'export PATH=$PATH:/opt:/usr/local/bin' >> .bashrc


# Install Starship
log "Installing Starship..."
curl -sS https://starship.rs/install.sh | sh
echo 'eval "$(starship init bash)"' >> $HOME/.bashrc
starship preset nerd-font-symbols -o ~/.config/starship.toml

# Install Homebrew
log "Installing Homebrew..."
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)" >> $HOME/.bashrc

# Define Homebrew packages
HOMEBREW_PACKAGES="lazygit gcc dust dog eza zellij neovim xh yazi ffmpegthumbnailer unar jq poppler fd ripgrep zoxide tlrc"

# Install Homebrew packages
log "Installing Homebrew packages..."
eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)" && /home/linuxbrew/.linuxbrew/bin/brew install $HOMEBREW_PACKAGES
echo 'eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"' >> $HOME/.bashrc


# Install ble.sh
log "Installing ble.sh..."
git clone --recursive --depth 1 --shallow-submodules https://github.com/akinomyoga/ble.sh.git
make -C ble.sh install
echo 'source ~/.local/share/blesh/ble.sh' >> $HOME/.bashrc

# Install VirtualBox
log "Installing VirtualBox..."
sudo apt-get update && sudo apt-get install -y apt-transport-https
wget -q https://www.virtualbox.org/download/oracle_vbox_2016.asc -O- | sudo tee /usr/share/keyrings/oracle_vbox_2016.gpg
echo "deb [arch=amd64 signed-by=/usr/share/keyrings/oracle_vbox_2016.gpg] http://download.virtualbox.org/virtualbox/debian bookworm contrib" | sudo tee /etc/apt/sources.list.d/virtualbox.list
sudo apt-get update && sudo apt-get install -y virtualbox-7.0

# Install VBox Guest Extension
log "Installing VBox Guest Extension..."
vbox_version=$(vboxmanage -v | cut -dr -f1)
wget https://download.virtualbox.org/virtualbox/$vbox_version/Oracle_VM_VirtualBox_Extension_Pack-$vbox_version.vbox-extpack
sudo vboxmanage extpack install Oracle_VM_VirtualBox_Extension_Pack-$vbox_version.vbox-extpack
vboxmanage list extpacks
sudo usermod -aG vboxusers $USER

# Download fonts, fastfetch & install themes
log "Installing themes and fonts..."
cd $HOME/Downloads
wget https://github.com/ryanoasis/nerd-fonts/releases/download/v2.1.0/Hack.zip
wget https://github.com/ryanoasis/nerd-fonts/releases/download/v2.1.0/NerdFontsSymbols.zip
git clone https://github.com/vinceliuice/Tela-icon-theme.git && cd Tela-icon-theme && ./install.sh
cd $HOME/Downloads && git clone https://github.com/vinceliuice/Orchis-theme.git && cd Orchis-theme && ./install.sh --tweaks macos
wget https://github.com/fastfetch-cli/fastfetch/releases/download/2.13.2/fastfetch-linux-amd64.deb

# Install Rust
log "Installing Rust..."
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
source "$HOME/.cargo/env"
echo 'source "$HOME/.cargo/env"' >> $HOME/.bashrc

#bash_aliases
cp $HOME/gitprojects/main/.bash_aliases $HOME/

# setup UFW
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
