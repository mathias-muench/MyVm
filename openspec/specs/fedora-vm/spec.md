# fedora-vm Specification

## Purpose

Provisions a Fedora Server virtual machine on Hyper-V from a kickstart file: it selects the install media, configures the VM hardware, and performs an unattended install.

## Requirements

### Requirement: Fedora 44 install media
The VM creation script SHALL attach the Fedora Server 44 DVD ISO (`Fedora-Server-dvd-x86_64-44-*.iso`) from the user's home directory as the primary boot device. The documentation SHALL name Fedora Server 44 as the release to download.

#### Scenario: ISO is attached and booted first
- **WHEN** `New-My-Vm.ps1` is run with a VM name and user
- **THEN** the VM's DVD drive points to the Fedora Server 44 ISO in `$HOME` and the firmware boot order starts with the DVD drive

#### Scenario: Documentation matches
- **WHEN** a user follows `README.md` to obtain the install media
- **THEN** the documented ISO is a Fedora Server 44 image with no references to older releases

### Requirement: Unattended kickstart install
The setup SHALL install Fedora Server 44 unattended using the kickstart configuration generated from `ks.envsubst` (static network, partitioning, user creation, installer-managed package selection, post-install configuration for desktop and Enhanced Session Mode) without installer errors.

#### Scenario: Kickstart accepted by Fedora 44 Anaconda
- **WHEN** the VM boots the Fedora 44 ISO with `inst.ks=hd:LABEL=ks`
- **THEN** Anaconda processes every kickstart directive and all `%post` sections complete without failure, ending in a shutdown of the installed system

### Requirement: Installer-managed package selection
All RPM packages SHALL be selected in the kickstart `%packages` section, with network repositories declared via `repo` directives so Anaconda can fetch packages not present on the DVD. Network repositories SHALL carry a higher repo cost than the DVD so the install media is preferred for packages it contains. `%post` sections SHALL NOT run package installation (`dnf install`, `dnf group install`).

#### Scenario: Desktop and xrdp installed by Anaconda
- **WHEN** the unattended install completes
- **THEN** `i3-desktop-environment`, `xrdp`, and `xrdp-selinux` are installed, having been resolved by Anaconda from the DVD plus the declared network repositories, and no `%post` section contains a package installation command

#### Scenario: DVD preferred over network
- **WHEN** a selected package is available both on the DVD and in a declared network repository
- **THEN** Anaconda installs it from the DVD, because the network repositories are declared with a cost above the DVD's default

### Requirement: No manual SELinux relabeling of packaged files
The kickstart SHALL NOT relabel files owned by RPM packages (no `chcon` on packaged files); contexts come from the installed SELinux policy, with `xrdp-selinux` providing the module that allows the vsock transport.

#### Scenario: Default contexts are correct
- **WHEN** the installed system is inspected after the unattended install
- **THEN** `restorecon -nv` on `/usr/sbin/xrdp` and `/usr/sbin/xrdp-sesman` reports no change needed, and the xrdp processes run as `unconfined_service_t` with vsock access working
