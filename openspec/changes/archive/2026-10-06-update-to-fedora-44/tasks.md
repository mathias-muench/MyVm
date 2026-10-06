# Tasks

## 1. Update install media references

- [x] 1.1 Download `Fedora-Server-dvd-x86_64-44-*.iso` from getfedora.org into `$HOME` and verify the file exists at the path `New-My-Vm.ps1` will reference
- [x] 1.2 Change the `-Path` of `Add-VMDvdDrive` in `New-My-Vm.ps1` to the Fedora Server 44 ISO file name and verify `openspec validate update-to-fedora-44` still passes and the script parses (`powershell -NoProfile -Command "[System.Management.Automation.PSParser]::Tokenize((Get-Content -Raw .\New-My-Vm.ps1), [ref]$null)"`)
- [x] 1.3 Update `README.md` to reference Fedora Server 44 (download instructions and ISO name) and remove the stale Fedora 36 mention; verify no Fedora version other than 44 remains (`Select-String -Path README.md -Pattern "Fedora"`)

## 2. Validate the kickstart against Fedora 44

- [x] 2.1 Create a test VM with `New-My-Vm.ps1` and boot it with `inst.ks=hd:LABEL=ks`; verify Anaconda accepts all directives in the generated `ks.cfg` and the install runs unattended to shutdown
- [x] 2.2 If Anaconda rejects a directive or a `%post` section fails, adjust `ks.envsubst` minimally and re-run 2.1 until the install completes; verify the installed system boots, the user is created, and xrdp/Enhanced Session Mode works
