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
The setup SHALL install Fedora Server 44 unattended using the kickstart configuration generated from `ks.envsubst` (static network, partitioning, user creation, post-install desktop and Enhanced Session Mode setup) without installer errors.

#### Scenario: Kickstart accepted by Fedora 44 Anaconda
- **WHEN** the VM boots the Fedora 44 ISO with `inst.ks=hd:LABEL=ks`
- **THEN** Anaconda processes every kickstart directive and all `%post` sections complete without failure, ending in a shutdown of the installed system
