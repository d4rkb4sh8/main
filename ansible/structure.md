ansible_debian_setup/
├── ansible.cfg
├── inventory
├── main.yml
├── roles/
│   ├── apt_packages/
│   │   └── tasks/main.yml
│   ├── homebrew_packages/
│   │   └── tasks/main.yml
│   ├── flatpak_packages/
│   │   └── tasks/main.yml
│   ├── snap_packages/
│   │   └── tasks/main.yml
│   ├── source_builds/
│   │   └── tasks/main.yml
│   ├── gnome_customizations/
│       └── tasks/main.yml
└── vars/
    └── packages.yml
