Write-Output "# " +
"dnf group install -y 'i3 desktop' && " +
"echo '/usr/bin/xfce4-terminal' >startwm.sh && " +
"chmod a+x startwm.sh && " +
"(curl -s  https://raw.githubusercontent.com/secana/EnhancedSessionMode/master/install_esm_fedora36.sh | sh) && " +
"systemctl set-default graphical.target  && " +
"reboot #" |  ssh root@172.26.48.4 "bash -upex"
