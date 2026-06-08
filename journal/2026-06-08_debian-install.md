
# 2026-06-08 Debian Installation

## Overview

Installation and basic config descrpition. Using Debian 13.5 and btrfs as filesystem. Tries to follow the minimalistic approach of the philosophy used for the homelab.

- Debian 13.5 Trixie, no desktop environment.
- Apart from boot and swap partitions, single btrfs filesystem.
- Installed just the basic tooling and Docker.

```bash
# Añadir el repositorio oficial (evita la versión antigua docker.io de Debian)
sudo apt update
sudo apt install ca-certificates curl -y
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/debian/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc

echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/debian $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

sudo apt update
sudo apt install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin -y
```

use the `compose/` directory to keep docker compose files. versions are kept in this repo.

system config files are in the `config/` directory: `config/etc/`, `config/home/admin/.bashrc`, etc. Use etckeeper to automatically track changes in `/etc` (unsafe to store in cloud, keeps secrets). However, this should be backed up too, same as snapshots.

Other things to study

- firewall (ufw)
- unattended updagrades

## Debian installation

Using the graphic installer, because I don't have the need to fight against the machine. Using the 13.5.0 netinst ISO. Every non-mentioned parameter is either default or empty.

- Language, locales and keyboard: choose whatever, they can/will be changed after installation with `dpkg-reconfigure locales` and `dpkg-reconfigure keyboard-configuration`. Also useful to check time with `timedatectl status` and configure timezone if not done, `sudo timedatectl set-timezone Europe/Madrid`.
- Network configuration: can also be changed later; using `mica` (machine name) as hostname.
- Admin account: an empty root password disables the root user; set up `mica-admin`.
- System disk partitioning: #1 512MB EFI System Partition, #2 1GB ext4 mounted on `/boot`, #3 8GB Swap, and the #4 30GB btrfs `/` root filesystem. The btrfs partition will have further configuration after install.
- Closest and default mirrors. No proxy, no telemetry (package usage survey). No desktop environment, no web server, no debian blend (collections like education or science). SSH server and standard system utilities installed.
- GRUB installation.

With these, SSH should be already configured and up. Check with `systemctl status ssh`, and the ip with `ip -br addr show` or `hostname -I`.

Update the full system with `sudo apt update && sudo apt full-upgrade`.

## Filesystem configuration

The current idea is to have two separate subvolumes in the btrfs filesystem: one for the root filesystem and another for `/var`, where most Docker files live.

1. Make sure `btrfs-progs` is installed (should be). Check partitions with `lsblk -f`.
2. Mount the btrfs to a temporal location with `sudo mount -o subvolid=5 /dev/nvme0n1p4 /mnt`. Listing the contents we can see that the installer has already created `@rootfs` for the root filesystem.
3. Create the `@var` subvolume: `sudo btrfs subvolume create /mnt/@var`.
4. Move data to the subvolumes: `sudo cp -a --reflink=auto /var/. /mnt/@var/`.
5. Edit `/etc/fstab` text file to mount root and `/var` via subvolume. Modify the lines for this disk to
```text
UUID=<partition-uuid>   /      btrfs   defaults,subvol=@rootfs   0  0
UUID=<partition-uuid>   /var   btrfs   defaults,subvol=@var      0  0
```
6. Configure GRUB defaults: open the file `/etc/default/grub` and change the line `GRUB_CMDLINE_LINUX_DEFAULT="quiet"` to `GRUB_CMDLINE_LINUX_DEFAULT="quiet rootflags=subvol=@rootfs"`. Regenerate GRUB configuration with `sudo update-grub`.
7. Reboot.

## Docker installation

Docker installation in Debian requires further configuration of the official repos to use the updated versions. Here is a shell script that summarizes the process.

```bash
# Remove any pre-existing outdated docker packages (shouldn't be necessary)
for pkg in docker.io docker-doc docker-compose podman-docker containerd runc; do
    sudo apt-get remove -y $pkg 2>/dev/null || true
done

# Install requisites for the official, dedicated apt repo.
sudo apt update && sudo apt install -y ca-certificates curl

# Add docker's official gpg key
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/debian/gpg -o /etc/apt/keyrings/docker.asc 
sudo chmod a+r /etc/apt/keyrings/docker.asc

# Add docker repo with pinned architecture
echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/debian $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

# Install essential docker packages
sudo apt install docker-ce docker-ce-cli containerd.io docker-compose-plugin

# Configure docker for long-term hygiene, limit log sizes
sudo mkdir -p /etc/docker
sudo tee /etc/docker/daemon.json <<EOF
{
  "log-driver": "json-file",
  "log-opts": {
    "max-size": "10m",
    "max-file": "3"
  }
}
EOF

# Add docker non-root user
sudo usermod -aG docker $USER

# Enable service and verify
sudo systemctl enable --now docker.service
sudo systemctl status docker.service
docker version

# Cleanup
sudo apt-get autoremove -y && sudo apt-get clean
```

??? question "Why not plain `apt install docker`?
    The Docker package in official Debian repos is old and actually a different product (`docker.io`, which is a community-maintained version) and with no direct update path. Adding Docker's apt repo we reach the official Docker Inc. packages.

    The certificates and key configuration is the mechanism for Debian to trust a third-party repo.

??? question "Why multiple packages, instead just a `install docker`?
    Functionality is split into composable elements.
    - `docker-ce` is the daemon itself, the engine for the containers.
    - `docker-ce-cli` is the `docker` command, the client.
    - `containerd.io` is the low-lever container runtime that actually runs containers.
    - `docker-compose-plugin` is the `docker compose` (v2) as a CLI plugin.

    This split allows to run a remote docker daemon, without client, or allow kubernetes use `containerd.io` without docker, for example.
