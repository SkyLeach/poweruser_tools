# last verified 5/1/2025 6:39:16 PM
# First command must be fixing the broken path (thanks for that windows)
Import-Module -Force C:\Users\mattg\src\powershell_maint\recursive_envvar_resolver.ps1
Import-Module -Force C:\Users\mattg\src\powershell_maint\pathdupecleaner.ps1
# powershell export equiv:
# Copy-Item -Path Env:\Foo -Destination Env:\Foo2 -PassThru
# Set-Item -Path Env:\Foo2 -Value 'BAR'
# Get-Item -Path Env:\Foo*
# Remove-Item -Path Env:\Foo* -Verbose
Set-Item -Path Env:\Path -Value $(Remove-DuplicatePaths $(Resolve-EnvVariable $(Resolve-EnvVariable $env:PATH)))
# set ollama environment vars
# $env:OLLAMA_MAX_LOADED_MODELS = 1
# $env:OLLAMA_NUM_PARALLEL      = 1
# $env:OLLAMA_MAX_QUEUE         = 512
# $env:OLLAMA_FLASH_ATTENTION   = 1
# set the PNPM environment variable
$env:PNPM_HOME                = "$env:LOCALAPPDATA\pnpm"
$MyDocuments = [Environment]::GetFolderPath("mydocuments")
Import-Module $MyDocuments\WindowsPowerShell\Modules\VirtualEnvWrapper.psm1
# Import-Module $env:ChocolateyInstall\helpers\chocolateyProfile.psm1
# Previous verification wasn't enough, pulled this from stackoverflow and
# tested it finding it actually works where the previous one didn't.
# Verified: 10/15/2024 9:30:42 PM

# Commented out because it doesn't work.  Replaced with above
# $PowerShellProfile = $PROFILE.CurrentUserAllHosts
# $PowerShellPath = Split-Path $PowerShellProfile
# Import-Module $PowerShellPath\Modules\VirtualEnvWrapper.psm1

$host.PrivateData.ErrorForegroundColor = 'DarkYellow'
# PS Core >= 7
$PSStyle.Formatting.Error = $PSStyle.Foreground.Yellow

# Imports for later - 4/15/2025 12:22:34 PM
# Import-Module posh-git* - maybe later?
Import-Module posh-git

# enable TLS 1.2 and higher 2/21/2025 1:49:28 AM - Matt
[Net.ServicePointManager]::SecurityProtocol =
    [Net.ServicePointManager]::SecurityProtocol -bor
    [Net.SecurityProtocolType]::Tls12

# Import the Chocolatey Profile that contains the necessary code to enable
# tab-completions to function for `choco`.
# Be aware that if you are missing these lines from your profile, tab completion
# for `choco` will not function.
# See https://ch0.co/tab-completion for details.
# Make `refreshenv` available right away, by defining the $env:ChocolateyInstall
# # variable and importing the Chocolatey profile module.
# # Note: Using `. $PROFILE` instead *may* work, but isn't guaranteed to.
$env:ChocolateyInstall = Convert-Path "$((Get-Command choco).Path)\..\.."
$ChocolateyProfile = "$env:ChocolateyInstall\helpers\chocolateyProfile.psm1"
if (Test-Path($ChocolateyProfile)) {
  Import-Module "$ChocolateyProfile"
}

$usershellscripts = "\Users\mattg\src\powershell_maint"
#
$activatevsdev = "${usershellscripts}\activatevsdev.psm1"
if (Test-Path($activatevsdev)) {
  Import-Module "$activatevsdev"
}

# Install and import if not already done
if (!(Get-Module -ListAvailable -Name Get-ChildItemColor)) {
    Install-Module Get-ChildItemColor
}
Import-Module Get-ChildItemColor

# oh-my-posh init pwsh --config "$env:POSH_THEMES_PATH\jandedobbeleer.omp.json" | Invoke-Expression
# oh-my-posh init pwsh --config "https://github.com/JanDeDobbeleer/oh-my-posh/blob/main/themes/sonicboom_dark.omp.json" | Invoke-Expression
oh-my-posh init pwsh --config "$env:POSH_THEMES_PATH\sonicboom_dark.omp.json" | Invoke-Expression
#f45873b3-b655-43a6-b217-97c00aa0db58 PowerToys CommandNotFound module

# vcpkg posh tool
Import-Module 'C:\Users\mattg\src\vcpkg\scripts\posh-vcpkg'
# Disabled now that I have to use two shells - Matt 12/30/2025 8:08:52 PM
# . 'C:\Program Files\Microsoft Visual Studio\18\Insiders\Common7\Tools\Launch-VsDevShell.ps1'
# configure powershell preference for handling exceptions...
$PSNativeCommandUseErrorActionPreference = $true
#a move this to a reusable alias script later.
Set-Alias -name ll -value "\Users\mattg\src\powershell_maint\colorized_dir_or_getchilditem.ps1"

# Import-Module -Name Microsoft.WinGet.CommandNotFound
Import-Module -Name Microsoft.PowerToys.Configure
