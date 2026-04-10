# Ubuntu LTS — headless (apt)

Installs a **server-oriented** package set with **apt**, then **copies** [`../config/`](../config/) → **`~/.config/`** and [`../home/`](../home/) → **`$HOME`**, bootstraps **tpm**, and **enables** Syncthing (user, best-effort) plus NetworkManager, Docker, and MariaDB (system, best-effort).

There is **no** Hyprland, desktop stack, audio (PipeWire), or GUI apps in this script.

## Quick start

```sh
cd ~/dotfiles/ubuntu
chmod +x ./install.sh
./install.sh
```

## Notes

- **`network-manager-openvpn-gnome`** is omitted; **`network-manager-openvpn`** stays for VPN profiles via NetworkManager.
- **`systemctl --user`** for Syncthing needs a **user session** (e.g. log in over SSH with lingering/pam_systemd, or log in once). On a minimal image it may no-op until then.
- **Arch desktop install** (Hyprland, browsers, etc.) remains **[`../arch-linux/install.sh`](../arch-linux/install.sh)**.

| Arch / concept | This script |
|----------------|-------------|
| `base-devel` | `build-essential`, `pkg-config`, `cmake` |
| `fd` | `fd-find` (+ optional `fd` alternative) |
| `bat` | `bat` (`batcat` → optional `bat` alternative) |
| `nodejs` guard | `nodejs` + `npm` only if `node` is missing |
| `bun`, `uv` | Not from apt; install from upstream if needed |

More detail: **[`../documentation/ubuntu-install.md`](../documentation/ubuntu-install.md)**.
