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
    	nikto sqlmap debian-goodies dict wikipedia2text w3m netdiscover gpg pass zathura pipx python3-websocket 
	wmctrl python3-levenshtein stow figlet lynis gawk curl wget git  tilix fd-find 
	powerline nala net-tools forensics-all forensics-full cpufetch btop 
	gnome-shell-extension-manager imagemagick gh lolcat fd-find sd npm 
	vlc build-essential procps tldr file fzf ytfzf net-tools httpie mitmproxy gpaste-2 dkms
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
sudo apt install flatpak
sudo apt install gnome-software-plugin-flatpak
flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo


# Install Homebrew
log "Installing Homebrew..."
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
echo 'eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"' >> ~/.bashrc
eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"

# Define Homebrew packages
HOMEBREW_PACKAGES=(
    lazygit gcc dust xh yazi ripgrep neovim zoxide tlrc
)

# Install Homebrew packages
log "Installing Homebrew packages..."
brew install "${HOMEBREW_PACKAGES[@]}"

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

# install Tela-circle-icons
cd $HOME/Downloads; git clone https://github.com/vinceliuice/Tela-circle-icon-theme.git;cd Tela*; ./install.sh

# mv .bashrc  and .bash_aliases
rm $HOME/.bashrc 
cp $HOME/gitprojects/main/.bashrc $HOME/
cp $HOME/gitprojects/main/.bash_aliases $HOME/

# install grc
cd $HOME/Downloads
git clone https://github.com/garabik/grc.git; cd grc; sudo ./install.sh
sudo cp /etc/profile.d/grc.sh /etc

# Final update and clean up
log "Final update and clean up..."
sudo apt update -y && sudo apt upgrade -y && sudo apt autoremove -y && sudo apt autoclean -y


# Source .bashrc
source $HOME/.bashrc

# Display message
figlet "The Machine is Ready." | lolcat
