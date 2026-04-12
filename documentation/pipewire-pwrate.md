# PipeWire: `pwrate` + repo drop-in

## AUR `pwrate`

**[`pwrate`](https://aur.archlinux.org/packages/pwrate)** is a small PipeWire **sample-rate helper** (TUI / workflow). It is listed in **`arch-linux/install.sh`** as **`AUR_PKGS`** so **`yay`** installs it with the rest.

## `config/pipewire/pipewire.conf.d/pwrate.conf`

This repo ships **`config/pipewire/pipewire.conf.d/pwrate.conf`**, which sets **default clock rate** and **allowed rates** for PipeWire (JSON drop-in). It is unrelated to the AUR binary but keeps a consistent name for “rate” tuning.

After changing drop-ins, restart user audio (**`pipewire`**, **`wireplumber`**) or re-login.
