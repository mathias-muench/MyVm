# Proposal

## Why

The kickstart installs the desktop environment and xrdp via `dnf` in `%post`
sections. That depends on working network in the chrooted post-install
environment and bypasses Anaconda's dependency resolution and error handling.
Two cleanups fall out of this: packages should be declared in `%packages`
(installer-managed), and two obsolete `chcon` commands can be dropped.

## What Changes

- Move package selection into the kickstart `%packages` section:
  `@^i3-desktop-environment` (replaces the `%post` dnf group install) and
  `xrdp` + `xrdp-selinux` (replaces the `%post` dnf install).
- Add `repo` lines for the Fedora `fedora` and `updates` mirrorlists so
  Anaconda can fetch packages not present on the Server DVD (i3, xrdp live
  in the Everything repo). The static `network` directive already provides
  connectivity during installation.
- Remove the `chcon --type=bin_t` commands for `/usr/sbin/xrdp` and
  `/usr/sbin/xrdp-sesman`: rpm already labels them `bin_t` via base policy,
  and `xrdp-selinux` ships the module whose allows (incl. vsock access) make
  the service work.
- Keep in `%post` only what is configuration, not installation: graphical
  default target, `startwm.sh`, xrdp ini edits, firewall ports, hv_sock
  module loading, and the tar helper scripts.

## Capabilities

### New Capabilities

<!-- none -->

### Modified Capabilities

- `fedora-vm`: the *Unattended kickstart install* requirement changes -
  package selection is installer-managed via `%packages` plus network repos,
  and `%post` no longer performs package installation or SELinux relabeling
  of packaged files.

## Impact

- `ks.envsubst`: `%packages` section gains entries, two `repo` lines added,
  `%post` sections lose the `dnf install`/`dnf group install`/`chcon` lines.
- Installation now requires network access to Fedora mirrors during install
  (already implied by the static network config; the DVD-only path is kept
  via `cdrom` as base repo).
- `New-My-Vm.ps1`, `README.md`: unaffected.
