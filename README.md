# Fedora on Hyper-V

> Only used two or three times, especially never on a completely new system. So parts may be missing or not working.

Enable Hyper-V on Windows

    Enable-WindowsOptionalFeature -Online -FeatureName Microsoft-Hyper-V -All

Setup networking with [New-My-Net.ps1](./New-My-Net.ps1) (based on [how-to-create-stable-private-network-on-hyper-v.md](https://gist.github.com/johnathanmay/161a8b8ebd36e3f19aefab77418e345e)).

Get `Fedora-Server-dvd-x86_64-36-1.5.iso` from [Download Fedora Server](https://getfedora.org/en/server/download/) and put into "right" place.

Create Vm with [New-My-Vm.ps1 MyVm](./New-My-Vm.ps1) (based on [Hyper-V example setup for Fedora 34](https://gist.github.com/PatrickLang/03dcda94a93b8b2960aa41c29ded057f)).

Kickstart automation

    scoop install cdrtools
    mkisofs.exe -r -J -V ks -o MyVm.iso ks.cfg

Extend boot command: `inst.ks=hd:LABEL=ks`

If you want to use Enhanced Session Mode for shared clipboard and drives, follow instructions and script in [secana/EnhancedSessionMode: Contains scripts to enable "Hyper-V Enhanced Session Mode" for Linux](https://github.com/secana/EnhancedSessionMode).

    tar --checkpoint=10000 -C ~mun5grb/ -c -f ~/thinclient_drives/C\:/Users/mun5grb/mun5grb.tar -X ~mun5grb/.tar-exclude --exclude-caches .

    ssh-keygen -R 172.26.48.4

    scp .\install_esm_fedora36.sh root@172.26.48.4:.

    ssh root@172.26.48.4 "bash -upex install_esm_fedora36.sh"

    Write-Output "dnf -y upgrade #" |  ssh root@172.26.48.4 "bash -upex"

    Write-Output "reboot #" |  ssh root@172.26.48.4 "bash -upex"

    Write-Output "dnf group install -y 'i3 desktop' #" |  ssh root@172.26.48.4 "bash -upex"

    Write-Output "systemctl set-default graphical.target #" |  ssh root@172.26.48.4 "bash -upex"

    ssh root@172.26.48.4 "bash -upex install_esm_fedora36.sh"

    ssh root@172.26.48.4

    Write-Output "echo '/usr/bin/xfce4-terminal' >startwm.sh #" |  ssh root@172.26.48.4 "bash -upex"

    Write-Output "chmod a+x startwm.sh #" |  ssh root@172.26.48.4 "bash -upex"

    tar --checkpoint=10000 -C ~mun5grb/ -x -f thinclient_drives/C\:/Users/mun5grb/mun5grb.tar

