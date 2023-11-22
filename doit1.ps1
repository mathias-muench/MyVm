ssh-keygen -R 172.26.48.4
Write-Output "dnf -y upgrade && reboot #" |  ssh root@172.26.48.4 "bash -upex"
