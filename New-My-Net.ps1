New-VMSwitch -SwitchName "internal-172.26.48.0-22" -SwitchType Internal -Verbose
$new_adapter = Get-NetAdapter -Name "vEthernet (internal-172.26.48.0-22)"
$if_index = $new_adapter.ifIndex
New-NetIPAddress -IPAddress 172.26.48.1 -PrefixLength 22 -InterfaceIndex $if_index -Verbose
New-NetNat -Name net-internal-172.26.48.0-22 -InternalIPInterfaceAddressPrefix 172.26.48.0/22 -Verbose
