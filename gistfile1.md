https://www.elevenforum.com/t/very-slow-up-slow-download-speeds-if-hyper-v-external-switch-enabled.902/

    Enable-WindowsOptionalFeature -Online -FeatureName Microsoft-Hyper-V -All

    Copy-VMFile "New Virtual Machine" -SourcePath .\mun5grb.tar -DestinationPath /home/ -CreateFullPath -FileSource Host