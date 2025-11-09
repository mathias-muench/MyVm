# Fedora on Hyper-V

Enable Hyper-V on Windows

    Enable-WindowsOptionalFeature -Online -FeatureName Microsoft-Hyper-V -All

Setup networking with [New-My-Net.ps1](./New-My-Net.ps1) (based on
[how-to-create-stable-private-network-on-hyper-v.md](https://gist.github.com/johnathanmay/161a8b8ebd36e3f19aefab77418e345e)).

Get `Fedora-Server-dvd-x86_64-36-1.5.iso` from [Download Fedora
Server](https://getfedora.org/en/server/download/) and put into "right"
place.

Create Vm with [New-My-Vm.ps1 MyVm](./New-My-Vm.ps1) (based on [Hyper-V
example setup for Fedora
34](https://gist.github.com/PatrickLang/03dcda94a93b8b2960aa41c29ded057f)).

Kickstart automation

    scoop install cdrtools
    scoop install envsubst

Extend boot command: `inst.ks=hd:LABEL=ks`

Post install script for Enhanced Session Mode for shared clipboard and
drives based on [secana/EnhancedSessionMode: Contains scripts to enable
"Hyper-V Enhanced Session Mode" for
Linux](https://github.com/secana/EnhancedSessionMode).
