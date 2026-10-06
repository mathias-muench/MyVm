# Spec Delta

## MODIFIED Requirements

### Requirement: Unattended kickstart install
The setup SHALL install Fedora Server 44 unattended using the kickstart configuration generated from `ks.envsubst` (static network, partitioning, user creation, installer-managed package selection, post-install configuration for desktop and Enhanced Session Mode) without installer errors.

#### Scenario: Kickstart accepted by Fedora 44 Anaconda
- **WHEN** the VM boots the Fedora 44 ISO with `inst.ks=hd:LABEL=ks`
- **THEN** Anaconda processes every kickstart directive and all `%post` sections complete without failure, ending in a shutdown of the installed system

## ADDED Requirements

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
