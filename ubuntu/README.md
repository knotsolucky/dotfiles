# Ubuntu LTS — headless (apt)

Installs a **server-oriented** package set with **apt**, then runs **[`../scripts/sync-all-config.sh`](../scripts/sync-all-config.sh)** so **every** entry under [`../config/`](../config/) is mirrored into **`$XDG_CONFIG_HOME`** (see [`../documentation/ubuntu-install.md`](../documentation/ubuntu-install.md)), copies [`../home/`](../home/) → **`$HOME`**, bootstraps **tpm**, and **enables** Syncthing (user or optional system unit) plus NetworkManager (optional on netplan servers), Docker, and MariaDB (system, best-effort).

There is **no** Hyprland, desktop stack, audio (PipeWire), or GUI apps in this script.

## Quick start

```sh
cd ~/dotfiles/ubuntu
chmod +x ./install.sh
./install.sh
```

## Notes

- **Ubuntu Server / netplan:** set **`DOTFILES_UBUNTU_SKIP_NETWORKMANAGER=1`** if you use **systemd-networkd** only and do not want **NetworkManager**. OpenVPN and WireGuard packages still install.
- **`network-manager-openvpn-gnome`** is omitted; **`network-manager-openvpn`** stays when NetworkManager is enabled.
- **`systemctl --user`** for Syncthing needs a **user session** (e.g. log in over SSH with lingering/pam_systemd, or log in once). On a minimal image it may no-op until then.
- **Arch desktop install** (Hyprland, browsers, etc.) remains **[`../arch-linux/install.sh`](../arch-linux/install.sh)**.
- **macOS + Homebrew** lives in **[`../macos/`](../macos/)** (see **[`../macos/Brewfile`](../macos/Brewfile)**).

| Arch / concept | This script |
|----------------|-------------|
| `base-devel` | `build-essential`, `pkg-config`, `cmake` |
| `fd` | `fd-find` (+ optional `fd` alternative) |
| `bat` | `bat` (`batcat` → optional `bat` alternative) |
| `nodejs` guard | `nodejs` + `npm` only if `node` is missing |
| `bun`, `uv` | Not from apt; install from upstream if needed |

More detail: **[`../documentation/ubuntu-install.md`](../documentation/ubuntu-install.md)**.
