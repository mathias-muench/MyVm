# Tasks

## 1. Rework package selection in ks.envsubst

- [x] 1.1 Add `repo --name=net-fedora --cost 2000 --mirrorlist=https://mirrors.fedoraproject.org/mirrorlist?repo=fedora-$releasever&arch=$basearch` and `repo --name=net-updates --cost 2000 --mirrorlist=https://mirrors.fedoraproject.org/mirrorlist?repo=updates-released-f$releasever&arch=$basearch` after the `cdrom` line (i.e. cost above the 1000 default so the DVD is preferred; ids renamed because `fedora`/`updates` collide with the image's system repos, which anaconda reconfigures without re-enabling them); verify `openspec validate consolidated-package-install` still passes
- [x] 1.2 Extend `%packages` with `@^i3-desktop-environment`, `xrdp`, `xrdp-selinux`, and `policycoreutils-python-utils` (keeping the existing groups; the latter moves out of `%post`, see 1.3); verify `ksvalidator -v ks.cfg` (pykickstart) reports no errors on the generated file
- [x] 1.3 Remove the package-installation lines from `%post` (`dnf group install -y i3-desktop-environment`, `sudo dnf install -y xrdp xrdp-selinux`, `dnf install -y policycoreutils-python-utils`, moved to `%packages`) and both `chcon --type=bin_t` lines; verify no `dnf install`/`dnf group install`/`chcon` remains in the file

## 2. Validate with a test install

- [ ] 2.1 Create a throwaway VM with `New-My-Vm.ps1` and boot with `inst.ks=hd:LABEL=ks`; verify Anaconda resolves the package set (DVD + network repos) and the install completes unattended to shutdown
- [ ] 2.2 On the installed system verify: `restorecon -nv /usr/sbin/xrdp /usr/sbin/xrdp-sesman` reports nothing to relabel, `ps -eZ | grep xrdp` shows `unconfined_service_t`, i3 graphical session and Enhanced Session Mode work; delete the throwaway VM afterwards
