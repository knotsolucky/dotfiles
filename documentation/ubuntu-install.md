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
