# Arch setup

## Initial installation

### Connecting to wifi

```
# Get an interactive prompt
iwctl

# List all wifi devices
[iwd]# device list

# Scan for networks
[iwd]# station <device> scan

# List all available networks
[iwd]# station <device> get-networks

# Connect to a network
[iwd]# station <device> connect <ssid>
```

### Install `dialog`

```
# Sync packages and force refresh package database
pacman -Syy
pacman -S dialog
```

### Download and execute script

```
curl https://raw.githubusercontent.com/miltoneiji/arch-setup/main/install.sh -o install.sh
chmod +x install.sh
./install.sh
```

## Post-installation

### Connecting to wifi

```
# List nearby Wi-Fi networks
nmcli device wifi list

# Connect
nmcli device wifi connect <SSID> password <password>
```

### Extras

```
curl https://raw.githubusercontent.com/miltoneiji/arch-setup/main/vimrc -o .vimrc
pacman -S zsh gvim
```

### Create user with sudo

```
# Install sudo
pacman -S sudo

# Create user
useradd -m -G wheel -s /bin/zsh takamura

# Configure as sudo user
EDITOR=vim visudo
# Uncomment the `%wheel ALL=(ALL) ALL`

# Set password
passwd takamura
```

