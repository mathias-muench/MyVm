# Proposal

## Why

The VM provisioning setup currently targets Fedora Server 43
(`Fedora-Server-dvd-x86_64-43-1.6.iso` in `New-My-Vm.ps1`, README still
mentions Fedora 36). Fedora 44 is the current release; new VMs should be
built from it so the install media matches a supported release.

## What Changes

- Point `New-My-Vm.ps1` at the Fedora Server 44 DVD ISO.
- Update `README.md` to reference Fedora Server 44 and drop the stale
  Fedora 36 mention.
- Verify the kickstart file (`ks.envsubst`) still works with the Fedora 44
  installer (package groups, `%post` steps, partitioning) and adjust only
  if the installer rejects it.

## Capabilities

### New Capabilities

- `fedora-vm`: Provisioning a Fedora Server VM on Hyper-V from a kickstart
  file, including install media selection, VM hardware configuration, and
  unattended install behavior.

### Modified Capabilities

<!-- none -->

## Impact

- `New-My-Vm.ps1`: ISO file name for the DVD drive.
- `README.md`: documented Fedora version and download instructions.
- `ks.envsubst`: only if Fedora 44's Anaconda rejects an existing directive
  (no change expected).
- Requires downloading the Fedora Server 44 ISO to `$HOME` before running
  `New-My-Vm.ps1`.
