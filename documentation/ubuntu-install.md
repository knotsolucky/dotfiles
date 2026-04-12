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
