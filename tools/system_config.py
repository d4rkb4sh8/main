import subprocess
import yaml
import os
import logging

# Configuration file path
config_file = "system_config.yaml"

# Set up logging
logging.basicConfig(level=logging.INFO, format='%(asctime)s - %(levelname)s - %(message)s')

def detect_installed_packages():
    """Detect installed packages."""
    result = subprocess.run(["dpkg", "--get-selections"], capture_output=True, text=True)
    packages = [line.split()[0] for line in result.stdout.splitlines() if line.endswith("install")]
    return packages

def detect_system_config():
    """Detect system configuration."""
    config = {}
    # Example: Read /etc/fstab
    with open("/etc/fstab", "r") as f:
        config["fstab"] = f.read()
    # Add more system config files as needed
    return config

def detect_user_customizations(user):
    """Detect user customizations."""
    customizations = {}
    # Example: Read .bashrc
    with open(f"/home/{user}/.bashrc", "r") as f:
        customizations["bashrc"] = f.read()
    # Example: Read .config directory
    customizations["config"] = {}
    for root, dirs, files in os.walk(f"/home/{user}/.config"):
        for file in files:
            with open(os.path.join(root, file), "r") as f:
                customizations["config"][file] = f.read()
    return customizations

def detect_desktop_environment():
    """Detect desktop environment."""
    result = subprocess.run(["echo", "$XDG_CURRENT_DESKTOP"], capture_output=True, text=True, shell=True)
    return result.stdout.strip()

def detect_wallpaper():
    """Detect wallpaper."""
    if detect_desktop_environment() == "GNOME":
        result = subprocess.run(["gsettings", "get", "org.gnome.desktop.background", "picture-uri"], capture_output=True, text=True)
    elif detect_desktop_environment() == "XFCE":
        result = subprocess.run(["xfconf-query", "-c", "xfce4-desktop", "-p", "/backdrop/screen0/monitor0/workspace0/last-image"], capture_output=True, text=True)
    else:
        raise Exception("Unsupported desktop environment")
    
    return result.stdout.strip()

def save_config(config):
    """Save configuration to YAML file."""
    with open(config_file, "w") as f:
        yaml.dump(config, f)

def load_config():
    """Load configuration from YAML file."""
    with open(config_file, "r") as f:
        return yaml.safe_load(f)

def apply_config(config):
    """Apply configuration to a fresh system."""
    # Install packages
    for package in config["packages"]:
        logging.info(f"Installing package: {package}")
        subprocess.run(["sudo", "apt", "install", "-y", package], check=True)
    
    # Apply system configurations
    for key, value in config["system_config"].items():
        logging.info(f"Applying system configuration: {key}")
        with open(f"/etc/{key}", "w") as f:
            f.write(value)
    
    # Apply user customizations
    for user, customizations in config["user_customizations"].items():
        logging.info(f"Applying user customizations for user: {user}")
        for key, value in customizations.items():
            if key == "config":
                for file, content in value.items():
                    os.makedirs(os.path.dirname(f"/home/{user}/.config/{file}"), exist_ok=True)
                    with open(f"/home/{user}/.config/{file}", "w") as f:
                        f.write(content)
            else:
                with open(f"/home/{user}/.{key}", "w") as f:
                    f.write(value)
    
    # Set desktop environment
    logging.info(f"Setting desktop environment: {config['desktop_environment']}")
    subprocess.run(["sudo", "update-alternatives", "--set", "x-session-manager", f"/usr/bin/{config['desktop_environment']}"], check=True)
    
    # Set wallpaper
    if config["desktop_environment"] == "gnome":
        logging.info(f"Setting wallpaper: {config['wallpaper']}")
        subprocess.run(["gsettings", "set", "org.gnome.desktop.background", "picture-uri", config["wallpaper"]], check=True)
    elif config["desktop_environment"] == "xfce":
        logging.info(f"Setting wallpaper: {config['wallpaper']}")
        subprocess.run(["xfconf-query", "-c", "xfce4-desktop", "-p", "/backdrop/screen0/monitor0/workspace0/last-image", "-s", config["wallpaper"]], check=True)

def main():
    # Detect current system configuration
    logging.info("Detecting installed packages...")
    packages = detect_installed_packages()
    logging.info("Detecting system configuration...")
    system_config = detect_system_config()
    logging.info("Detecting user customizations...")
    user_customizations = detect_user_customizations("user")
    logging.info("Detecting desktop environment...")
    desktop_environment = detect_desktop_environment()
    logging.info("Detecting wallpaper...")
    wallpaper = detect_wallpaper()
    
    # Create configuration dictionary
    config = {
        "packages": packages,
        "system_config": system_config,
        "user_customizations": {
            "user": user_customizations
        },
        "desktop_environment": desktop_environment,
        "wallpaper": wallpaper
    }
    
    # Save configuration to YAML file
    logging.info("Saving configuration to YAML file...")
    save_config(config)
    
    # Optionally, apply configuration to a fresh system
    # logging.info("Applying configuration to a fresh system...")
    # apply_config(config)

if __name__ == "__main__":
    main()
