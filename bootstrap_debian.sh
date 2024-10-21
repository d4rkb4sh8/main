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
	arp-scan asciiart autoconf bat bison btop build-essential cmake cpufetch curl dconf-cli debian-goodies dict 
	dkms fd-find figlet file flatpak font-manager forensics-all forensics-full fzf gawk gdebi gh git gnome-software-plugin-flatpak 
	gnome-shell-extension-manager gpaste-2 gpg gpgv2 httpie imagemagick info libchafa-dev libgmp3-dev libpcap-dev libpq-dev libreadline6-dev libsixel-dev
	libsqlite3-dev libssl-dev libsvn1 libtbb-dev libtool libvips-dev libxml2-dev libxslt-dev libyaml-dev linux-headers-$(uname -r)
	lolcat lynis mitmproxy most nala ncal ncurses-dev netdiscover net-tools nikto npm openssl pass patchelf pipx plocate postgresql
	postgresql-contrib powerline procps python3-levenshtein python3-websocket python-is-python3 snapd sqlmap stow tilix tldr ufw uuid-runtime
	v4l-utils vlc w3m wget wikipedia2text wmctrl ytfzf zathura
)

# Update, upgrade and install APT packages in a single step
log "Updating, upgrading, and installing packages..."
sudo apt update -y && sudo apt full-upgrade -y && sudo apt install -y "${APT_PACKAGES[@]}" && sudo apt autoremove -y && sudo apt autoclean -y

# Install latest flathub & flatpak
flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo


# Install Snap
log "Installing Snap..."
sudo snap install snapd
sudo snap install snap-store

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
brew install eza gcc neovim dust zoxide xh yazi fastfetch

# Install rust
log "Installing Rust..."
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh

#install atuin
log "Installing Atuin..."
curl --proto '=https' --tlsv1.2 -LsSf https://setup.atuin.sh | sh

# Install Tela-circle-icons
log "Installing Tela-circle-icons..."
cd $HOME/Downloads
git clone https://github.com/vinceliuice/Tela-circle-icon-theme.git
cd Tela-circle-icon-theme
./install.sh

# setup gitprojects
log "setting up gitprojects..."
mkdir $HOME/gitprojects
cd $HOME/gitprojects
git clone https://github.com/d4rkb4sh8/main.git
git clone https://github.com/d4rkb4sh8/learn.git

# Update .bashrc and .bash_aliases, fastfetch, nvim and ulauncher
log "Updating bash configurations..."
rm $HOME/.bashrc
cp $HOME/gitprojects/main/.bashrc $HOME/
cp $HOME/gitprojects/main/.bash_aliases $HOME/
cp -r $HOME/gitprojects/main/wallpapers $HOME/Pictures
cp -r $HOME/gitprojects/main/fastfetch $HOME/.config
cp -r $HOME/gitprojects/main/nvim $HOME/.config
cp -r $HOME/gitprojects/main/ulauncher $HOME/.config

# setup GRC colors
log "setting up GRC colors..."
cd $HOME/gitprojects
git clone https://github.com/garabik/grc.git
cd $HOME/gitprojects/grc
sudo ./install.sh
sudo cp /etc/profile.d/grc.sh /etc

# setup Starship prompt
log "setting up Starship..."
curl -sS https://starship.rs/install.sh | sh
starship preset nerd-font-symbols -o ~/.config/starship.toml

# Install Grub2 custom theme 
log "Installing Grub theme..."
cd $HOME/gitprojects
git clone https://github.com/vinceliuice/grub2-themes.git
cd $HOME/gitprojects/grub2-themes
cp $HOME/Pictures/wallpapers/wallpaper_001.jpg $HOME/gitprojects/grub2-themes/background.jpg
sudo ./install.sh -s 1080p -b -t whitesur

# Install GTFOB lookup
log "Installing GTFOB..."
pipx install git+https://github.com/nccgroup/GTFOBLookup.git

# install ollama
#log "Installing ollama..."
#curl -fsSL https://ollama.com/install.sh | sh
#ollama run deepseek-coder-v2

#Install Mullvad
log "Installing Mullvad..."
# Download the Mullvad signing key
sudo curl -fsSLo /usr/share/keyrings/mullvad-keyring.asc https://repository.mullvad.net/deb/mullvad-keyring.asc

# Add the Mullvad repository server to apt
echo "deb [signed-by=/usr/share/keyrings/mullvad-keyring.asc arch=$( dpkg --print-architecture )] https://repository.mullvad.net/deb/stable $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/mullvad.list

# Install the package
sudo apt update
sudo apt install mullvad-vpn


# Virtualbox
log "Installing Virtualbox..."
cd $HOME/Downloads
wget https://download.virtualbox.org/virtualbox/7.1.4/Oracle_VirtualBox_Extension_Pack-7.1.4.vbox-extpack
wget https://download.virtualbox.org/virtualbox/7.1.4/virtualbox-7.1_7.1.4-165100~Debian~bookworm_amd64.deb
sudo gdebi virtualbox-*.deb
sudo usermod -aG vboxusers h4ck3r

#ulauncher
log "Installing ulauncher..."
cd $HOME/Downloads
wget https://github.com/Ulauncher/Ulauncher/releases/download/5.15.7/ulauncher_5.15.7_all.deb
sudo gdebi ulauncher*.deb

# Final update and clean up
log "Final update and clean up..."
sudo apt update -y && sudo apt upgrade -y && sudo apt autoremove -y && sudo apt autoclean -y && notify-send -e "success" || notify-send -e "failed"

# Source .bashrc
log "Sourcing .bashrc..."
source $HOME/.bashrc 

# Display message
figlet "The Machine is Ready." | lolcat

sudo reboot

