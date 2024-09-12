#!/bin/bash

set -e  # Exit immediately if a command exits with a non-zero status

log() {
    echo "[$(date +'%Y-%m-%dT%H:%M:%S%z')] $*"
}

# Append 'contrib non-free' to each active deb repository line in sources.list
log "Adding 'contrib non-free' to active lines in sources.list..."
sudo sed -i '/^deb / s/$/ contrib non-free/' /etc/apt/sources.list

# Edit /etc/default/grub for GRUB settings
log "Configuring GRUB settings..."
sudo sed -i 's/^GRUB_TIMEOUT=.*/GRUB_TIMEOUT=2/' /etc/default/grub
sudo sed -i '/^GRUB_CMDLINE_LINUX_DEFAULT=/a GRUB_CMDLINE_LINUX="rhgb quiet mitigations=off"' /etc/default/grub

# Update GRUB and initramfs
log "Updating GRUB and initramfs..."
sudo update-grub
sudo update-initramfs -u -k all

# Remove bloatware and clean up
log "Removing bloatware and cleaning up..."
sudo apt purge -y audacity gimp gnome-games libreoffice* && sudo apt autoremove -y && sudo apt autoclean -y

# Define APT packages
APT_PACKAGES=(
    ncal info patchelf nikto sqlmap debian-goodies dict wikipedia2text w3m netdiscover gpg pass zathura pipx python3-websocket
    wmctrl python3-levenshtein stow figlet lynis gawk curl wget git tilix fd-find powerline nala net-tools
    forensics-all forensics-full cpufetch btop gnome-shell-extension-manager imagemagick gh lolcat npm vlc 
    build-essential procps tldr file fzf ytfzf httpie mitmproxy gpaste-2 dkms font-manager gdebi ufw gawk 
    cmake plocate bat most libssl-dev libvips-dev libsixel-dev libchafa-dev libtbb-dev dconf-cli uuid-runtime 
    linux-headers-$(uname -r) gpgv2 autoconf bison postgresql libgmp3-dev libpcap-dev openssl libpq-dev libreadline6-dev
    libsqlite3-dev libsvn1 libtool libxml2-dev libxslt-dev wget libyaml-dev ncurses-dev postgresql-contrib 
)

# Update, upgrade and install APT packages in a single step
log "Updating, upgrading, and installing packages..."
sudo apt update -y && sudo apt full-upgrade -y && sudo apt install -y "${APT_PACKAGES[@]}" && sudo apt autoremove -y && sudo apt autoclean -y

# Install Snap
log "Installing Snap..."
sudo apt install -y snapd
sudo systemctl enable --now snapd apparmor
sudo ln -s /var/lib/snapd/snap /snap

# Install Gogh terminal profile theme
log "Installing Gogh terminal profile theme..."
bash -c "$(wget -qO- https://git.io/vQgMr)"

# Install ble.sh
cd $HOME
git clone --recursive --depth 1 --shallow-submodules https://github.com/akinomyoga/ble.sh.git
make -C ble.sh install PREFIX=~/.local
echo 'source ~/.local/share/blesh/ble.sh' >> ~/.bashrc

# Remove other terminal emulators and set Tilix as default
log "Setting Tilix as the default terminal..."
sudo apt purge -y gnome-terminal xterm
gsettings set org.gnome.desktop.default-applications.terminal exec /usr/bin/tilix.wrapper
gsettings set org.gnome.desktop.default-applications.terminal exec-arg "-x"
sudo update-alternatives --set x-terminal-emulator /usr/bin/tilix.wrapper

# Install Hack Nerd Font
log "Installing Hack Nerd Font..."
mkdir -p ~/.local/share/fonts
wget https://github.com/ryanoasis/nerd-fonts/releases/download/v3.0.2/Hack.zip -O /tmp/Hack.zip
unzip /tmp/Hack.zip -d ~/.local/share/fonts
fc-cache -fv

# Set up UFW (Uncomplicated Firewall)
log "Setting up UFW..."
sudo ufw limit 22/tcp
sudo ufw allow 80/tcp
sudo ufw allow 443/tcp
sudo ufw default deny incoming
sudo ufw default allow outgoing
sudo ufw enable

# Install Homebrew
log "Installing Homebrew..."
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# Add Homebrew to PATH
echo 'eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"' >> ~/.bashrc
eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"

# Install packages using Homebrew
log "Installing Homebrew packages: eza, gcc, neovim, dust, zoxide, atuin, xh, yazi..."
brew install eza gcc neovim dust zoxide atuin xh yazi fastfetch


# Install Tela-circle-icons
log "Installing Tela-circle-icons..."
cd $HOME/Downloads
git clone https://github.com/vinceliuice/Tela-circle-icon-theme.git
cd Tela-circle-icon-theme
./install.sh

# Update .bashrc and .bash_aliases
log "Updating bash configurations..."
cp $HOME/gitprojects/main/.bashrc $HOME/
cp $HOME/gitprojects/main/.bash_aliases $HOME/

# Final update and clean up
log "Final update and clean up..."
sudo apt update -y && sudo apt upgrade -y && sudo apt autoremove -y && sudo apt autoclean -y

# Source .bashrc
log "Sourcing .bashrc..."
source $HOME/.bashrc

# Display message
figlet "The Machine is Ready." | lolcat

