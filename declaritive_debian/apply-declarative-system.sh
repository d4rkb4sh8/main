#!/bin/bash

# Set the backup directory path
BACKUP_DIR="$HOME/backup"
LOG_FILE="$BACKUP_DIR/system-changes.log"

# Set the config file path
CONFIG_FILE="system-declaration.cfg"

# Create backup directory if it doesn't exist
create_backup_dir() {
    if [ ! -d "$BACKUP_DIR" ]; then
        echo "Creating backup directory at $BACKUP_DIR..."
        mkdir -p "$BACKUP_DIR"
    fi
}

# Log system changes (installations, removals)
log_system_change() {
    local change_type=$1
    local package_name=$2
    TIMESTAMP=$(date "+%Y-%m-%d %H:%M:%S")
    echo "[$TIMESTAMP] $change_type: $package_name" >> "$LOG_FILE"
}

# Backup current config
backup_system_state() {
    echo "Backing up current system state..."
    TIMESTAMP=$(date +%Y%m%d_%H%M%S)
    cp "$CONFIG_FILE" "$BACKUP_DIR/system-declaration_$TIMESTAMP.cfg"
    echo "Backup saved at $BACKUP_DIR/system-declaration_$TIMESTAMP.cfg"
}

# Initialize config file if it doesn't exist
initialize_config_file() {
    if [ ! -f "$CONFIG_FILE" ]; then
        echo "Creating new configuration file at $CONFIG_FILE..."
        cat <<EOF > "$CONFIG_FILE"
# System Declaration Config

# Installed apt/dpkg packages
packages_install=()

# Installed flatpaks
flatpak_install=()

# Installed snaps
snap_install=()

# Installed Homebrew formulas
homebrew_formulas=()

# Services, custom commands, etc.
EOF
        echo "Configuration file created."
    else
        echo "Configuration file $CONFIG_FILE already exists."
    fi
}

# Load the config file
load_config_file() {
    source "$CONFIG_FILE"
}

# Helper function to check if a package is installed (for apt and dpkg)
is_package_installed() {
    dpkg -l | grep -q "^ii  $1\s"
}

# Detect apt-installed and dpkg packages (including version numbers)
detect_apt_packages() {
    echo "Detecting apt and dpkg installed packages..."
    installed_apt_packages=$(dpkg-query -W -f='${binary:Package}=${Version}\n')
    echo "Found the following apt/dpkg packages:"
    echo "$installed_apt_packages"
}

# Detect installed flatpaks
detect_flatpak_packages() {
    if command -v flatpak &> /dev/null; then
        echo "Detecting flatpak packages..."
        installed_flatpaks=$(flatpak list --app --columns=application)
        echo "Found the following flatpak packages:"
        echo "$installed_flatpaks"
    else
        echo "Flatpak is not installed."
        installed_flatpaks=""
    fi
}

# Detect installed snaps
detect_snap_packages() {
    if command -v snap &> /dev/null; then
        echo "Detecting snap packages..."
        installed_snaps=$(snap list | awk 'NR>1 {print $1"="$2}')
        echo "Found the following snap packages:"
        echo "$installed_snaps"
    else
        echo "Snap is not installed."
        installed_snaps=""
    fi
}

# Detect installed Homebrew formulas
detect_homebrew_packages() {
    if command -v brew &> /dev/null; then
        echo "Detecting Homebrew formulas..."
        installed_brew_formulas=$(brew list --formula --versions)
        echo "Found the following Homebrew formulas:"
        echo "$installed_brew_formulas"
    else
        echo "Homebrew is not installed."
        installed_brew_formulas=""
    fi
}

# Remove missing packages from the config file
remove_missing_packages_from_config() {
    echo "Removing missing packages from the configuration file..."

    # Remove missing apt/dpkg packages
    new_packages_install=()
    for package in "${packages_install[@]}"; do
        if echo "$installed_apt_packages" | grep -q "$(echo "$package" | cut -d '=' -f 1)"; then
            new_packages_install+=("$package")
        else
            log_system_change "Removed apt/dpkg package" "$package"
            echo "Package $package has been removed from the system, removing from config..."
        fi
    done

    # Remove missing flatpaks
    new_flatpak_install=()
    for package in "${flatpak_install[@]}"; do
        if echo "$installed_flatpaks" | grep -q "$package"; then
            new_flatpak_install+=("$package")
        else
            log_system_change "Removed flatpak package" "$package"
            echo "Flatpak $package has been removed from the system, removing from config..."
        fi
    done

    # Remove missing snaps
    new_snap_install=()
    for package in "${snap_install[@]}"; do
        if echo "$installed_snaps" | grep -q "$(echo "$package" | cut -d '=' -f 1)"; then
            new_snap_install+=("$package")
        else
            log_system_change "Removed snap package" "$package"
            echo "Snap $package has been removed from the system, removing from config..."
        fi
    done

    # Remove missing Homebrew formulas
    new_homebrew_formulas=()
    for formula in "${homebrew_formulas[@]}"; do
        if echo "$installed_brew_formulas" | grep -q "$(echo "$formula" | cut -d '=' -f 1)"; then
            new_homebrew_formulas+=("$formula")
        else
            log_system_change "Removed Homebrew formula" "$formula"
            echo "Homebrew formula $formula has been removed from the system, removing from config..."
        fi
    done

    # Update the config file with the new arrays
    echo "Updating the config file with the remaining packages..."

    sed -i '/^packages_install=(/,$d' "$CONFIG_FILE"
    echo "packages_install=(" >> "$CONFIG_FILE"
    for package in "${new_packages_install[@]}"; do
        echo "    \"$package\"" >> "$CONFIG_FILE"
    done
    echo ")" >> "$CONFIG_FILE"

    echo "flatpak_install=(" >> "$CONFIG_FILE"
    for package in "${new_flatpak_install[@]}"; do
        echo "    \"$package\"" >> "$CONFIG_FILE"
    done
    echo ")" >> "$CONFIG_FILE"

    echo "snap_install=(" >> "$CONFIG_FILE"
    for package in "${new_snap_install[@]}"; do
        echo "    \"$package\"" >> "$CONFIG_FILE"
    done
    echo ")" >> "$CONFIG_FILE"

    echo "homebrew_formulas=(" >> "$CONFIG_FILE"
    for formula in "${new_homebrew_formulas[@]}"; do
        echo "    \"$formula\"" >> "$CONFIG_FILE"
    done
    echo ")" >> "$CONFIG_FILE"

    echo "Configuration file updated with remaining packages."
}

# Add new packages to config file (if not already present)
add_new_packages_to_config() {
    echo "Adding newly detected packages to the configuration file..."

    # Add new apt/dpkg packages
    for package in $(echo "$installed_apt_packages" | cut -d "=" -f 1); do
        if ! [[ " ${packages_install[@]} " =~ " ${package} " ]]; then
            packages_install+=("$package")
            echo "Adding new apt/dpkg package $package to config..."
            log_system_change "Added apt/dpkg package" "$package"
        fi
    done

    # Add new flatpak packages
    for package in $installed_flatpaks; do
        if ! [[ " ${flatpak_install[@]} " =~ " ${package} " ]]; then
            flatpak_install+=("$package")
            echo "Adding new flatpak package $package to config..."
            log_system_change "Added flatpak package" "$package"
        fi
    done

    # Add new snap packages
    for package in $(echo "$installed_snaps" | cut -d "=" -f 1); do
        if ! [[ " ${snap_install[@]} " =~ " ${package} " ]]; then
            snap_install+=("$package")
            echo "Adding new snap package $package to config..."
            log_system_change "Added snap package" "$package"
        fi
    done

    # Add new Homebrew formulas
    for formula in $(echo "$installed_brew_formulas" | cut -d "=" -f 1); do
        if ! [[ " ${homebrew_formulas[@]} " =~ " ${formula} " ]]; then
            homebrew_formulas+=("$formula")
            echo "Adding new Homebrew formula $formula to config..."
            log_system_change "Added Homebrew formula" "$formula"
        fi
    done
}

# Main function
main() {
    # Ensure backup directory exists
    create_backup_dir

    # Initialize config file if it doesn't exist
    initialize_config_file

    # Load the existing configuration
    load_config_file

    # Detect all types of packages and update the configuration file
    detect_apt_packages
    detect_flatpak_packages
    detect_snap_packages
    detect_homebrew_packages

    # Remove any packages that were uninstalled from the system
    remove_missing_packages_from_config

    # Add any new packages detected to the configuration
    add_new_packages_to_config

    # Backup the current state of the configuration
    backup_system_state

    # Update package lists
    echo "Updating package lists..."
    sudo apt-get update

    # Install packages from apt
    echo "Installing apt/dpkg packages..."
    for package in "${packages_install[@]}"; do
        if is_package_installed "$(echo $package | cut -d '=' -f 1)"; then
            echo "$package is already installed."
        else
            echo "Installing $package..."
            log_system_change "Installed apt/dpkg package" "$package"
            sudo apt-get install -y "$package"
        fi
    done

    # Install flatpak packages
    echo "Installing flatpak packages..."
    for package in "${flatpak_install[@]}"; do
        flatpak install -y "$package"
        log_system_change "Installed flatpak package" "$package"
    done

    # Install snap packages
    echo "Installing snap packages..."
    for package in "${snap_install[@]}"; do
        snap install "$package"
        log_system_change "Installed snap package" "$package"
    done

    # Install Homebrew formulas
    echo "Installing Homebrew formulas..."
    for formula in "${homebrew_formulas[@]}"; do
        brew install "$formula"
        log_system_change "Installed Homebrew formula" "$formula"
    done

    echo "System configuration applied successfully!"
}

# Entry point
main "$@"

