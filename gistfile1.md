https://www.elevenforum.com/t/very-slow-up-slow-download-speeds-if-hyper-v-external-switch-enabled.902/

    Enable-WindowsOptionalFeature -Online -FeatureName Microsoft-Hyper-V -All

    Copy-VMFile "New Virtual Machine" -SourcePath .\mun5grb.tar -DestinationPath /home/ -CreateFullPath -FileSource Host
    
https://learn.microsoft.com/en-us/virtualization/hyper-v-on-windows/quick-start/connect-to-network

  100  nmcli connection add type ethernet con-name static ifname eth0 ipv4.method manual ipv4.addresses 172.17.64.0/20 gw4 172.17.64.1
  130  nmcli connection modify static ipv4.dns "1.1.1.1 139.15.183.106"
