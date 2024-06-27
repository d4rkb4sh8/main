#!/bin/bash


# Remove Debian games bloatware
sudo apt purge gnome-games libreoffice* -y && sudo apt autoremove -y && sudo apt autoclean -y

# Update system and install necessary tools
sudo apt update -y && sudo apt upgrade -y && sudo apt autoremove -y && sudo apt autoclean -y

# Define APT packages
APT_PACKAGES="fastfetch stow figlet lynis gawk curl wget git alacritty powerline* nala net-tools forensics-all cpufetch btop gnome-shell-extension-manager flatpak gnome-software-plugin-flatpak gh lolcat fd-find sd npm vlc build-essential procps file net-tools httpie mitmproxy gpaste-2 font-manager gdebi ufw gawk cmake plocate bat most libssl-dev libvips-dev libsixel-dev libchafa-dev libtbb-dev"

# Function to install APT packages
install_apt_packages() {
    sudo apt install -y $APT_PACKAGES
}
# Call function to install APT packages
install_apt_packages


#install starship
curl -sS https://starship.rs/install.sh | sh

# add to bashrc
eval "$(starship init bash)" >> $HOME/.bashrc

# add  Preset
starship preset nerd-font-symbols -o ~/.config/starship.toml


# Install Homebrew
install_homebrew() {
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
}
# Call function to install Homebrew
install_homebrew

# Define Homebrew packages
HOMEBREW_PACKAGES="gcc dust dog eza zellij neovim xh yazi ffmpegthumbnailer unar jq poppler fd ripgrep zoxide tlrc"

# Function to install Homebrew packages
install_homebrew_packages() {
    eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)" && /home/linuxbrew/.linuxbrew/bin/brew install $HOMEBREW_PACKAGES
}
# Call function to install Homebrew packages
install_homebrew_packages


eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)" >> .bashrc


# Install ble.sh
install_ble_sh() {
    # NOTE: It's recommended to download and inspect scripts before execution
    git clone --recursive --depth 1 --shallow-submodules https://github.com/akinomyoga/ble.sh.git &&
    make -C ble.sh install PREFIX=~/.local &&
    echo 'source ~/.local/share/blesh/ble.sh' >> ~/.bashrc
}
# Call function to install ble.sh
install_ble_sh

# install flatpak
sudo apt install flatpak
sudo apt install gnome-software-plugin-flatpak
flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo

# Install GDM Settings
install_gdm_settings() {
    # Install Flatpak applications
    sudo flatpak install -y io.github.realmazharhussain.GdmSettings org.onlyoffice.desktopeditors org.gnome.World.PikaBackup io.gitlab.zehkira.Monophony io.github.mimbrero.WhatsAppDesktop org.chromium.Chromium org.gnome.Solanum org.qbittorrent.qBittorrent io.github.hvdwofl.jExifToolGUI com.belmoussaoui.Obfuscate net.sourceforge.Pdfedit
}
# Call function to install GDM Settings
install_gdm_settings

# Install Snap Store
install_snap_store() {
    sudo apt install snapd -y &&
    sudo snap install core &&
    sudo snap install snap-store &&
    sudo snap install csbooks
}
# Call function to install Snap Store
install_snap_store

# Install VirtualBox
install_virtualbox() {
    wget -O- https://www.virtualbox.org/download/oracle_vbox_2016.asc | sudo gpg --dearmour -o /usr/share/keyrings/oracle_vbox_2016.gpg &&
    echo "deb [arch=amd64 signed-by=/usr/share/keyrings/oracle_vbox_2016.gpg] http://download.virtualbox.org/virtualbox/debian bookworm contrib" | sudo tee /etc/apt/sources.list.d/virtualbox.list &&
    sudo apt update &&
    sudo apt install virtualbox-7.0 -y
}
# Call function to install VirtualBox
install_virtualbox

# Install VBox Guest Extension
install_vbox_guest_extension() {
    vbox_version=$(vboxmanage -v | cut -dr -f1) &&
    wget https://download.virtualbox.org/virtualbox/$vbox_version/Oracle_VM_VirtualBox_Extension_Pack-$vbox_version.vbox-extpack &&
    sudo vboxmanage extpack install Oracle_VM_VirtualBox_Extension_Pack-$vbox_version.vbox-extpack &&
    vboxmanage list extpacks &&
    sudo usermod -aG vboxusers $USER
}
# Call function to install VBox Guest Extension
install_vbox_guest_extension

# Download fonts, fastfetch & install themes
install_themes() {
    cd $HOME/Downloads &&
    wget https://github.com/ryanoasis/nerd-fonts/releases/download/v2.1.0/Hack.zip &&
    wget https://github.com/ryanoasis/nerd-fonts/releases/download/v2.1.0/NerdFontsSymbols.zip &&
    git clone https://github.com/vinceliuice/Tela-icon-theme.git &&
    cd Tela-icon-theme &&
    ./install.sh &&
    cd $HOME/Downloads &&
    git clone https://github.com/vinceliuice/Orchis-theme.git &&
    cd Orchis-theme &&
    ./install.sh --tweaks macos
    wget https://github.com/fastfetch-cli/fastfetch/releases/download/2.13.2/fastfetch-linux-amd64.deb 
}
# Call function to download fonts & install themes
install_themes

# Update PATH
echo 'export PATH=$PATH:/opt' >> $HOME/.bashrc

# Install Rust
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh


#rust installed
. "$HOME/.cargo/env" >> .bahrc

# Upgrade system with nala
sudo nala upgrade

# Update system and install necessary tools
sudo apt update -y && sudo apt upgrade -y && sudo apt autoremove -y && sudo apt autoclean -y


# Display message
figlet "The Machine is Ready."
