#!/usr/bin/env bash


# Detect the Linux distribution
if [ -f /etc/os-release ]; then
    # Source the os-release file to get distro information
    source /etc/os-release
    DISTRO_NAME=$NAME
    DISTRO_VERSION=$VERSION_ID
else
    DISTRO_NAME="Unknown"
    DISTRO_VERSION="Unknown"
fi

# Detect the kernel version
KERNEL_VERSION=$(uname -r)

# Detect the desktop environment (if any)
if [ -n "$XDG_CURRENT_DESKTOP" ]; then
    DESKTOP_ENVIRONMENT=$XDG_CURRENT_DESKTOP
else
    DESKTOP_ENVIRONMENT="Unknown"
fi

# Detect the package manager
if command -v apt &> /dev/null; then
    PACKAGE_MANAGER="apt" 
elif command -v rpm &> /dev/null; then
    PACKAGE_MANAGER="rpm" 
elif command -v pacman &> /dev/null; then
    PACKAGE_MANAGER="pacman" 
elif command -v apk &> /dev/null; then
    PACKAGE_MANAGER="apk" 
else
    PACKAGE_MANAGER="Unknown"
fi

# Print the results
echo "Detected Distribution: $DISTRO_NAME ($DISTRO_VERSION)"
echo "Detected Kernel Version: $KERNEL_VERSION"
echo "Detected Desktop Environment: $DESKTOP_ENVIRONMENT"
echo "Detected Package Manager: $PACKAGE_MANAGER"


