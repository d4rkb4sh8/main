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

# Remove Debian games bloatware and clean up
log "Removing bloatware and cleaning up..."
sudo apt purge -y gnome-games libreoffice* && sudo apt autoremove -y && sudo apt autoclean -y

# Update and upgrade the system
log "Updating and upgrading the system..."
sudo apt update -y && sudo apt full-upgrade -y && sudo apt autoremove -y && sudo apt autoclean -y

# Define APT packages
APT_PACKAGES=(
    ripgrep nikto sqlmap debian-goodies dict wikipedia2text w3m neovim netdiscover gpg pass zathura pipx python3-websocket wmctrl python3-levenshtein stow figlet lynis gawk curl wget git  tilix fd-find powerline nala net-tools forensics-all forensics-full cpufetch btop gnome-shell-extension-manager flatpak gnome-software-plugin-flatpak
    gh lolcat fd-find sd npm vlc build-essential procps tldr file fzf ytfzf net-tools httpie mitmproxy gpaste-2 dkms
    font-manager gdebi ufw gawk cmake plocate bat most libssl-dev libvips-dev libsixel-dev libchafa-dev libtbb-dev ufw gdebi
    dconf-cli uuid-runtime linux-headers-$(uname -r) gpgv2 autoconf bison build-essential postgresql libaprutil1
    libgmp3-dev libpcap-dev openssl libpq-dev libreadline6-dev libsqlite3-dev libssl-dev locate libsvn1 libtool libxml2 libxml2-dev
    libxslt-dev wget libyaml-dev ncurses-dev postgresql-contrib xsel zlib1g zlib1g-dev curl wireshark aircrack-ng macchanger sqlmap
)

# Install APT packages
log "Installing APT packages..."
sudo apt update -y && sudo apt install -y "${APT_PACKAGES[@]}"

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


# Setup Flatpak and add Flathub
log "Setting up Flatpak and adding Flathub..."
sudo flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo

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
sudo apt purge gnome-terminal xterm -y
gsettings set org.gnome.desktop.default-applications.terminal exec /usr/bin/tilix.wrapper
gsettings set org.gnome.desktop.default-applications.terminal exec-arg "-x"
sudo update-alternatives --set x-terminal-emulator /usr/bin/tilix.wrapper

# Install Eza
sudo mkdir -p /etc/apt/keyrings
wget -qO- https://raw.githubusercontent.com/eza-community/eza/main/deb.asc | sudo gpg --dearmor -o /etc/apt/keyrings/gierens.gpg
echo "deb [signed-by=/etc/apt/keyrings/gierens.gpg] http://deb.gierens.de stable main" | sudo tee /etc/apt/sources.list.d/gierens.list
sudo chmod 644 /etc/apt/keyrings/gierens.gpg /etc/apt/sources.list.d/gierens.list
sudo apt update
sudo apt install -y eza


# Remove Firefox ESR
sudo apt-get remove --purge firefox-esr -y

# Install necessary packages
sudo apt-get install wget gnupg2 -y

# Add Mozilla's official signing key
wget -O- https://mozilla.debian.net/archive.asc | sudo tee /etc/apt/trusted.gpg.d/mozilla-archive.gpg

# Add Mozilla repository to the sources list
echo "deb http://deb.debian.org/debian stable main" | sudo tee /etc/apt/sources.list.d/mozilla.list

# Update package lists
sudo apt-get update

# Install the latest Firefox
sudo apt-get install firefox -y

# Verify installation
firefox --version

# Install Hack Nerd Font
mkdir -p ~/.local/share/fonts
wget https://github.com/ryanoasis/nerd-fonts/releases/download/v3.0.2/Hack.zip -O /tmp/Hack.zip
unzip /tmp/Hack.zip -d ~/.local/share/fonts
fc-cache -fv

# Set up UFW (Uncomplicated Firewall)
sudo ufw limit 22/tcp
sudo ufw allow 80/tcp
sudo ufw allow 443/tcp
sudo ufw default deny incoming
sudo ufw default allow outgoing
sudo ufw enable

#install grc from github


# Final update and clean up
log "Final update and clean up..."
sudo apt update -y && sudo apt upgrade -y && sudo apt autoremove -y && sudo apt autoclean -y

# Add keyboard shortcuts for brightness control to .bashrc
log "Adding keyboard shortcuts for brightness control..."
echo "
# Brightness control from keyboard
gsettings set org.gnome.settings-daemon.plugins.media-keys screen-brightness-up \"['<Ctrl><Super>Up']\"
gsettings set org.gnome.settings-daemon.plugins.media-keys screen-brightness-down \"['<Ctrl><Super>Down']\"
" >> ~/.bashrc

# Source .bashrc
source $HOME/.bashrc

# Display message
figlet "The Machine is Ready." | lolcat
