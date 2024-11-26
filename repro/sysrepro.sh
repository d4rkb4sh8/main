#!/usr/bin/env bash

# Source: https://unix.stackexchange.com/a/60139
declare -A package_managers
package_managers[apt]="apt"
package_managers[brew]="brew"
package_managers[flatpak]="flatpak"
package_managers[snap]="snap"

reproducible_file="system_reproducibility.txt"

echo "Packages installed from various package managers:" > $reproducible_file
for manager in "${!package_managers[@]}"; do
    echo "$manager" >> $reproducible_file
    eval "\$(${package_managers[$manager]} list --format='json')"
done >> $reproducible_file

# GNOME settings: https://stackoverflow.com/a/11311544
echo "\nGNOME Settings:" >> $reproducible_file
gsettings get org.gnome.desktop.background picture-uri >> $reproducible_file
gsettings get org.gnome.desktop.thumbnailers thumbnailer-exe >> $reproducible_file

# User configurations: /home/$USER/.config/
echo "\nUser Configurations:" >> $reproducible_file
for config in $(find ~/.config/ -type f); do
    echo "$config" >> $reproducible_file
done

# Make the file readable by all users and notify when it changes (using `inotifywait`)
chmod 644 $reproducible_file
# For production use, install `inotifywait`: https://unix.stackexchange.com/a/44675
while inotifywait -e modify,move,delete --format '%w%f' $reproducible_file; do
    # When the file changes, append "Changed: $(date)" to it.
    echo "\nChanged: $(date)" >> $reproducible_file
done
```

# Make sure to give execute permissions with `chmod +x script.sh` before running this 
# script.
#
# Please note that you need to install `inotifywait` for the automatic change 
# detection. If not already installed, run `sudo apt-get install inotify-tools`.
#
# You can test this script by making some changes to your system (e.g., installing a 
# new package) and then watching how the reproducible file is updated.
#
# Also, keep in mind that this script is just an example; you may need to adapt it to 
# fit your specific needs. For instance, if you have custom configuration files 
# elsewhere on your system, you might want to include them as well.
#
# To make the process easier, consider running a Docker container with your Debian 
# environment and execute the script there.
