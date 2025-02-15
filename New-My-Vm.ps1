# Create a virtual hard disk
$vhd = New-VHD -SizeBytes 50Gb -Dynamic MyVm.vhdx

# Create a UEFI VM, secure boot disabled
$vm = New-VM -Generation 2 -Name "MyVm" -Path .
$vm | Set-VMFirmware -EnableSecureBoot Off

# Processor, memory settings
$vm | Set-VMProcessor -Count 4
$vm | Set-VMMemory -DynamicMemoryEnabled $false -StartupBytes 8Gb

# Add DVD drive, attach ISO, HDD, and set boot order
$dvd = $vm | Add-VMDvdDrive -Path $HOME\Fedora-Server-dvd-x86_64-40-1.14.iso -Passthru
$hdd = $vm | Add-VMHardDiskDrive -Path $vhd.Path -Passthru
$vm | Set-VMFirmware -BootOrder $dvd, $hdd
$vm | Add-VMDvdDrive -Path $HOME\kickstart.iso -Passthru

# Connect the network adapter - run Get-VMSwitch if you're not sure which name to use.
#    There is a "Default switch" if you want a local NAT, but I prefer using a direct connection
$vm | Get-VMNetworkAdapter | Connect-VMNetworkAdapter -SwitchName "internal-172.26.48.0-22"

# Disable the automatic checkpoints, configure transport for enhanced session via xrdp
$vm | Set-VM -AutomaticCheckpointsEnabled $false
$vm | Set-VM -EnhancedSessionTransportType HvSocket
$vm | Set-VM -AutomaticStopAction ShutDown
