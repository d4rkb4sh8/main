#!/bin/bash

set -e  # Exit immediately if a command exits with a non-zero status

log() {
    echo "[$(date +'%Y-%m-%dT%H:%M:%S%z')] $*"
}

# Remove Debian games bloatware and clean up
log "Removing bloatware and cleaning up..."
sudo apt purge -y gnome-games libreoffice* && sudo apt autoremove -y && sudo apt autoclean -y

# Update and upgrade the system
log "Updating and upgrading the system..."
sudo apt update -y && sudo apt full-upgrade -y && sudo apt autoremove -y && sudo apt autoclean -y

# Define APT packages
APT_PACKAGES=(
    dict wikipedia2text w3m zathura pipx python3-websocket wmctrl python3-levenshtein stow figlet lynis gawk curl wget git
    tilix fd-find powerline* nala net-tools forensics-all cpufetch btop gnome-shell-extension-manager
    flatpak gnome-software-plugin-flatpak gh lolcat fd-find sd npm vlc build-essential procps
    file fzf ytfzf net-tools httpie mitmproxy gpaste-2 font-manager gdebi ufw gawk cmake plocate bat most
    libssl-dev libvips-dev libsixel-dev libchafa-dev libtbb-dev ufw gdebi dconf-cli uuid-runtime linux-headers-$(uname -r)
)

# Install APT packages
log "Installing APT packages..."
sudo apt install -y "${APT_PACKAGES[@]}"

# Clone repo
log "Cloning repository..."
mkdir -p "$HOME/gitprojects"
git clone https://github.com/d4rkb4sh8/main.git "$HOME/gitprojects/main"

# Add custom paths to .bashrc
echo 'export PATH=$PATH:/opt:/usr/local/bin' >> ~/.bashrc

# Install Starship
log "Installing Starship..."
curl -sS https://starship.rs/install.sh | sh -s -- -y
echo 'eval "$(starship init bash)"' >> ~/.bashrc
starship preset nerd-font-symbols -o ~/.config/starship.toml

# Install Homebrew
log "Installing Homebrew..."
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
echo 'eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"' >> ~/.bashrc
eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"

# Define Homebrew packages
HOMEBREW_PACKAGES=(
    lazygit gcc dust dog eza zellij neovim xh yazi ripgrep zoxide tlrc
)

# Install Homebrew packages
log "Installing Homebrew packages..."
brew install "${HOMEBREW_PACKAGES[@]}"

# Install custom scripts and configurations
log "Setting up custom scripts and configurations..."
cp -r "$HOME/gitprojects/main/ulauncher" "$HOME/.config/"

# Install tgpt
log "Installing tgpt..."
curl -sSL https://raw.githubusercontent.com/aandrew-me/tgpt/main/install | bash -s /usr/local/bin

# Install Rust
log "Installing Rust..."
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
echo 'source "$HOME/.cargo/env"' >> ~/.bashrc
source "$HOME/.cargo/env"

# Install LazyVim
log "Installing LazyVim..."
git clone https://github.com/LazyVim/starter ~/.config/nvim
rm -rf ~/.config/nvim/.git

# Copy bash aliases
log "Copying bash aliases..."
cp "$HOME/gitprojects/main/.bash_aliases" "$HOME/"

# Copy nanorc
log "Copying nanorc..."
sudo cp "$HOME/gitprojects/main/nanorc" /etc/

#install atuin
curl --proto '=https' --tlsv1.2 -LsSf https://setup.atuin.sh | sh

# Setup UFW
log "Setting up UFW..."
sudo ufw limit 22/tcp
sudo ufw allow 80/tcp
sudo ufw allow 443/tcp
sudo ufw default deny incoming
sudo ufw default allow outgoing
sudo ufw enable

# Install GTFOBLookup
log "Installing GTFOBLookup..."
pipx install git+https://github.com/nccgroup/GTFOBLookup.git

# Install Flathub
log "Installing Flathub..."
sudo flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo

# Install Snap
log "Installing Snap..."
sudo apt install -y snapd
sudo systemctl enable --now snapd apparmor
sudo ln -s /var/lib/snapd/snap /snap

# Install VirtualBox
log "Installing VirtualBox..."
wget https://download.virtualbox.org/virtualbox/7.0.18/virtualbox-7.0_7.0.18-162988~Debian~bookworm_amd64.deb -O $HOME/Downloads/virtualbox.deb
wget https://download.virtualbox.org/virtualbox/7.0.18/Oracle_VM_VirtualBox_Extension_Pack-7.0.18.vbox-extpack -O $HOME/Downloads/virtualbox-extpack.vbox-extpack

# Install Gogh terminal profile theme
log "Installing Gogh terminal profile theme..."
bash -c "$(wget -qO- https://git.io/vQgMr)"

#Install ble.sh
cd $HOME
git clone --recursive --depth 1 --shallow-submodules https://github.com/akinomyoga/ble.sh.git
make -C ble.sh install PREFIX=~/.local
echo 'source ~/.local/share/blesh/ble.sh' >> ~/.bashrc

#Brightness control from keybaord
echo 'gsettings set org.gnome.settings-daemon.plugins.media-keys screen-brightness-up "['<Ctrl><Super>Up']"' >> ~/.bashrc
echo 'gsettings set org.gnome.settings-daemon.plugins.media-keys screen-brightness-down "['<Ctrl><Super>Down']"' >> ~/.bashrc

# Final update and clean up
log "Final update and clean up..."
sudo apt update -y && sudo apt upgrade -y && sudo apt autoremove -y && sudo apt autoclean -y

# Source .bashrc
source $HOME/.bashrc

# Display message
figlet "The Machine is Ready." | lolcat
