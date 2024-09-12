#!/bin/bash

# Define config file
CONFIG_FILE="system_config.txt"

# Function to list installed apt packages
list_apt_packages() {
    echo "Listing apt packages..."
    apt list --installed | awk -F/ '{print $1}' > apt_packages.txt
}

# Function to list installed dpkg packages
list_dpkg_packages() {
    echo "Listing dpkg packages..."
    dpkg --get-selections | grep -v deinstall | awk '{print $1}' > dpkg_packages.txt
}

# Function to list installed python packages
list_python_packages() {
    echo "Listing Python (pip) packages..."
    pip freeze > python_packages.txt
}

# Function to list installed homebrew packages (if homebrew is installed)
list_homebrew_packages() {
    if command -v brew &> /dev/null; then
        echo "Listing Homebrew packages..."
        brew list > brew_packages.txt
    else
        echo "Homebrew is not installed. Skipping..."
    fi
}

# Function to list installed .deb files from apt cache
list_deb_files() {
    echo "Listing .deb files from apt cache..."
    ls /var/cache/apt/archives/*.deb > deb_files.txt
}

# Function to generate config file
generate_config() {
    echo "Generating configuration file: $CONFIG_FILE..."
    echo "[APT]" > $CONFIG_FILE
    cat apt_packages.txt >> $CONFIG_FILE
    echo "[DPKG]" >> $CONFIG_FILE
    cat dpkg_packages.txt >> $CONFIG_FILE
    echo "[PYTHON]" >> $CONFIG_FILE
    cat python_packages.txt >> $CONFIG_FILE
    echo "[HOMEBREW]" >> $CONFIG_FILE
    cat brew_packages.txt >> $CONFIG_FILE
    echo "[DEB FILES]" >> $CONFIG_FILE
    cat deb_files.txt >> $CONFIG_FILE
    echo "Configuration file generated."
}

# Function to update system based on config file
update_system_from_config() {
    echo "Updating system based on configuration file: $CONFIG_FILE..."
    
    section=""
    while read -r line; do
        case "$line" in
            "[APT]")
                section="apt"
                ;;
            "[DPKG]")
                section="dpkg"
                ;;
            "[PYTHON]")
                section="python"
                ;;
            "[HOMEBREW]")
                section="homebrew"
                ;;
            "[DEB FILES]")
                section="deb"
                ;;
            *)
                if [[ ! -z "$line" ]]; then
                    case "$section" in
                        "apt")
                            sudo apt install -y "$line"
                            ;;
                        "dpkg")
                            sudo apt install -y "$line"
                            ;;
                        "python")
                            pip install "$line"
                            ;;
                        "homebrew")
                            if command -v brew &> /dev/null; then
                                brew install "$line"
                            fi
                            ;;
                        "deb")
                            sudo dpkg -i "$line"
                            ;;
                    esac
                fi
                ;;
        esac
    done < $CONFIG_FILE
    echo "System update complete."
}

# Main Script Logic
case "$1" in
    "list")
        list_apt_packages
        list_dpkg_packages
        list_python_packages
        list_homebrew_packages
        list_deb_files
        generate_config
        ;;
    "update")
        if [[ -f "$CONFIG_FILE" ]]; then
            update_system_from_config
        else
            echo "Configuration file not found! Please run './script_name list' first."
        fi
        ;;
    *)
        echo "Usage: $0 {list|update}"
        ;;
esac