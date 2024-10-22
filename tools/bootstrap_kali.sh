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
APT_PACKAGES=(
    tilix virtualbox* fastfetch pipx stow figlet lynis gawk curl wget git fd-find nala kali-linux-everything cpufetch btop gnome-shell-extension-manager
    flatpak gnome-software-plugin-flatpak gh lolcat fd-find sd npm vlc build-essential file httpie mitmproxy gpaste-2 font-manager gdebi ufw cmake plocate bat most realtek-rtl88xxau-dkms firmware-realtek eza neovim
)

# Install APT packages
log "Installing APT packages..."
sudo apt install -y "${APT_PACKAGES[@]}"

# Clone repo
mkdir -p "$HOME/gitprojects"
cd "$HOME/gitprojects"
git clone https://github.com/d4rkb4sh8/main.git

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
HOMEBREW_PACKAGES=(
    lazygit gcc dust zellij xh yazi ripgrep zoxide tlrc
)

# Install Homebrew packages
log "Installing Homebrew packages..."
brew install "${HOMEBREW_PACKAGES[@]}"

# Install ble.sh
log "Installing ble.sh..."
cd $HOME
git clone --recursive --depth 1 --shallow-submodules https://github.com/akinomyoga/ble.sh.git
make -C ble.sh install PREFIX=~/.local
echo 'source ~/.local/share/blesh/ble.sh' >> ~/.bashrc

# Install ulauncher
cd $HOME/Downloads
wget https://github.com/Ulauncher/Ulauncher/releases/download/5.15.7/ulauncher_5.15.7_all.deb
# Copy ulauncher config
cp -r "$HOME/gitprojects/main/ulauncher" "$HOME/.config/"

# Install tgpt
log "Installing tgpt..."
curl -sSL https://raw.githubusercontent.com/aandrew-me/tgpt/main/install | bash -s /usr/local/bin

# Install Rust
log "Installing Rust..."
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
source "$HOME/.cargo/env"
echo 'source "$HOME/.cargo/env"' >> ~/.bashrc

# Install lazyvim
log "Installing LazyVim..."
git clone https://github.com/LazyVim/starter ~/.config/nvim
rm -rf ~/.config/nvim/.git

# Copy bash aliases
log "Copying bash aliases..."
cp "$HOME/gitprojects/main/.bash_aliases" "$HOME/"

# Setup UFW
log "Setting up UFW..."
sudo ufw limit 22/tcp
sudo ufw allow 80/tcp
sudo ufw allow 443/tcp
sudo ufw default deny incoming
sudo ufw default allow outgoing
sudo ufw enable

# Install Flathub
log "Installing Flathub..."
sudo flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo

# Install Snap
log "Installing Snap..."
sudo apt install -y snapd
sudo systemctl enable --now snapd apparmor
sudo ln -s /var/lib/snapd/snap /snap

# removing other terminal emulators
sudo apt purge gnome-terminal xterm -y

#set tilix as default gnome terminal
gsettings set org.gnome.desktop.default-applications.terminal exec /usr/bin/tilix.wrapper
gsettings set org.gnome.desktop.default-applications.terminal exec-arg "-x"

#config tilix as default 2nd step
sudo update-alternatives --config x-terminal-emulator

#Brightness control from keybaord
echo 'gsettings set org.gnome.settings-daemon.plugins.media-keys screen-brightness-up "['<Ctrl><Super>Up']"' >> ~/.bashrc
echo 'gsettings set org.gnome.settings-daemon.plugins.media-keys screen-brightness-down "['<Ctrl><Super>Down']"' >> ~/.bashrc

# Final update and clean up
log "Final update and clean up..."
sudo apt update -y && sudo apt upgrade -y && sudo apt autoremove -y && sudo apt autoclean -y

# Display message
figlet "The Machine is Ready." | lolcat

# Source .bashrc
source "$HOME/.bashrc"
