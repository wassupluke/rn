#curl -o tweak.ps1 https://raw.githubusercontent.com/wassupluke/rn/main/tweak.ps1 && .\tweak.ps1 && rm tweak.ps1

set-ExecutionPolicy -Scope CurrentUser Unrestricted

###       Disable Mouse Acceleration       ###
$RegConnect = [Microsoft.Win32.RegistryKey]::OpenRemoteBaseKey([Microsoft.Win32.RegistryHive]"CurrentUser","$env:COMPUTERNAME")
$RegMouse = $RegConnect.OpenSubKey("Control Panel\Mouse",$true)
$acc_enabled = $RegMouse.GetValue("MouseSpeed")
if ( $acc_enabled -eq 1 ) {
    # mouse acc is enabled -> disable mouse acc
    $RegMouse.SetValue("MouseSpeed","0")
    $RegMouse.SetValue("MouseThreshold1","0")
    $RegMouse.SetValue("MouseThreshold2","0") }
$RegMouse.Close()
$RegConnect.Close()
$code='[DllImport("user32.dll", EntryPoint = "SystemParametersInfo")]public static extern bool SystemParametersInfo(uint uiAction, uint uiParam, int[] pvParam, uint fWinIni);'
Add-Type $code -name Win32 -NameSpace System
[System.Win32]::SystemParametersInfo(4,0,0,2) | Out-Null


###          Show Taskbar Icons             ###
$registryPath = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer"
If ( !(Test-Path $registryPath) ) {New-Item -Path $registryPath -Force; }
New-ItemProperty -Path $registryPath -Name "EnableAutoTray" -PropertyType DWORD -Value 0 -Force


###             Set Dark Theme             ###
# set "app" system mode to "dark"
Set-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize -Name AppsUseLightTheme -Value 0 -Type Dword -Force; 
# set "OS" system mode to "dark"
Set-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize -Name SystemUsesLightTheme -Value 0 -Type Dword -Force;
# set accent color per wallpaper
Set-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize -Name ColorPrevalence -Value 1 -Type Dword -Force;


###    Hide Search, Cortana, Task View     ###
Set-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Search -Name TraySearchBoxVisible -Value 0 -Type Dword -Force;
Set-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Search -Name SearchboxTaskbarMode -Value 0 -Type Dword -Force;
Set-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Search -Name TraySearchBoxVisibleOnAnyMonitor -Value 0 -Type Dword -Force;
Set-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced -Name ShowCortanaButton -Value 0 -Type Dword -Force;
Set-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced -Name ShowTaskViewButton -Value 0 -Type Dword -Force;

###                FINALLY                 ###
Stop-Process -processName: Explorer -force

###      Perhaps stronger than WinGet      ###
# https://learn.microsoft.com/en-us/powershell/gallery/powershellget/install-powershellget
#Install-Module PowerShellGet -Force -AllowClobber
#Set-PSRepository -Name PSGallery -InstallationPolicy Trusted
#. $profile # not sure if this step is necessary
#Install-Module winget-install -Force
