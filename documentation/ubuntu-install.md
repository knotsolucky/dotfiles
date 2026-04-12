# Ubuntu Install Notes

## Optional package guards

`ubuntu/install.sh` installs core packages directly, then probes some extras with `apt-cache show` before adding them.

Guarded extras include:

- `lazygit`
- `yazi`
- `starship`
- `fastfetch`
- `ninja-build`
- `meson`
- `dotnet-sdk-8.0`
- `dotnet-runtime-8.0`
- `putty`

Reason: package availability differs across Ubuntu repos/PPAs and mirrors. Guard avoids hard fail like `E: Unable to locate package`.

## Docker package selection

`ubuntu/install.sh` chooses one Docker stack:

- If Docker upstream repo packages exist (`docker-ce` + `containerd.io`), install CE stack:
  - `docker-ce`
  - `docker-ce-cli`
  - `containerd.io`
  - `docker-buildx-plugin`
  - `docker-compose-plugin`
- Else fallback to Ubuntu packages:
  - `docker.io`
  - first available compose package (`docker-compose-v2` / `docker-compose-plugin` / `docker-compose`)

Reason: avoid `containerd.io : Conflicts: containerd` resolver failures when both repos are present.

## Ubuntu Server / minimal images

### NetworkManager vs netplan

Many **Ubuntu Server** images use **netplan** + **systemd-networkd** without NetworkManager. Installing NM can be unwanted or confusing.

- **`DOTFILES_UBUNTU_SKIP_NETWORKMANAGER=1`** — skip **`network-manager`** and **`network-manager-openvpn`**, and do not enable NetworkManager systemd units.
- **`openvpn`** and **`wireguard-tools`** still install for standalone VPN tooling.

### MariaDB

- **`DOTFILES_UBUNTU_SKIP_MARIADB=1`** — skip MariaDB packages and do not enable **`mariadb.service`**.

### Smaller apt footprint

- **`DOTFILES_UBUNTU_APT_MINIMAL=1`** — pass **`--no-install-recommends`** to **`apt-get install`** (fewer pulled-in recommends; good for tight server images).

### Syncthing on headless SSH (no user systemd)

User **`syncthing.service`** under **`systemctl --user`** needs a logind session. On a bare SSH box that often fails silently (script already ignores errors).

- **`DOTFILES_UBUNTU_SYNCTHING_SYSTEM=1`** — enable **`syncthing@${USER}.service`** (system unit) instead of the user unit.

### Unattended upgrades / needrestart

The script sets **`NEEDRESTART_MODE=a`** so **`needrestart`** does not block non-interactive **`apt-get`** on servers.
