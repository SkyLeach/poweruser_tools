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

# Install and import if not already done
if (!(Get-Module -ListAvailable -Name Get-ChildItemColor)) {
    Install-Module Get-ChildItemColor
}
Import-Module Get-ChildItemColor

# oh-my-posh init pwsh --config "$env:POSH_THEMES_PATH\jandedobbeleer.omp.json" | Invoke-Expression
# oh-my-posh init pwsh --config "https://github.com/JanDeDobbeleer/oh-my-posh/blob/main/themes/sonicboom_dark.omp.json" | Invoke-Expression
oh-my-posh init pwsh --config "$env:POSH_THEMES_PATH\sonicboom_dark.omp.json" | Invoke-Expression
#f45873b3-b655-43a6-b217-97c00aa0db58 PowerToys CommandNotFound module

# function workon ($env) {
#           & $env:WORKON_HOME\$env\Scripts\activate.ps1
# }

# configure powershell preference for handling exceptions...
$PSNativeCommandUseErrorActionPreference = $true
#a move this to a reusable alias script later.
Set-Alias -name ll -value "\Users\mattg\src\powershell_maint\colorized_dir_or_getchilditem.ps1"

# Import-Module -Name Microsoft.WinGet.CommandNotFound
Import-Module -Name Microsoft.PowerToys.Configure
#f45873b3-b655-43a6-b217-97c00aa0db58

# SIG # Begin signature block
# MIIFqgYJKoZIhvcNAQcCoIIFmzCCBZcCAQExDzANBglghkgBZQMEAgEFADB5Bgor
# BgEEAYI3AgEEoGswaTA0BgorBgEEAYI3AgEeMCYCAwEAAAQQH8w7YFlLCE63JNLG
# KX7zUQIBAAIBAAIBAAIBAAIBADAxMA0GCWCGSAFlAwQCAQUABCATK+Rjq3oytZz4
# yWwXwunD9G4a+6hoGuLG8ykI45CkeKCCAxgwggMUMIIB/KADAgECAhAhJdz/pZUJ
# l0w5S3ajUOpeMA0GCSqGSIb3DQEBBQUAMCIxIDAeBgNVBAMMF1Bvd2VyU2hlbGwg
# Q29kZSBTaWduaW5nMB4XDTI0MTAwNzE4Mjk1NFoXDTI1MTAwNzE4NDk1NFowIjEg
# MB4GA1UEAwwXUG93ZXJTaGVsbCBDb2RlIFNpZ25pbmcwggEiMA0GCSqGSIb3DQEB
# AQUAA4IBDwAwggEKAoIBAQC4Bl8Hih7bUudlXaJdM9rMoU8QCbbkBQPvhjGRu2Yv
# O/7Scsi2pu2fGSHpKijUTCgmSC2bZD/uNxcwLmaTrv+N6yuXPQWnQjedq/V1Bint
# 5tcO1XQwZAxNwODOTT6IWWnGixJptcUJUH/WNQjN9xMQWC28Hf7WSD1BkSetRLLE
# KdtsJUTzCucs5HphxyeBkM/22VZdiYdRAV+9db97B0m6MPuOFcBxXoBnFYeA/38D
# VvCK3cbZ89JWc0/UwaPMiWn1gbA42ySdMsmg/XFMcRXs1gznuhFKi+H7Or35+hgF
# IYSlCXx4FpiwTIveOFuPIqv1jjQmubsxgADj0HKMH2LxAgMBAAGjRjBEMA4GA1Ud
# DwEB/wQEAwIHgDATBgNVHSUEDDAKBggrBgEFBQcDAzAdBgNVHQ4EFgQUDNfnWPJj
# 818GruhRY6V7SDUpCIcwDQYJKoZIhvcNAQEFBQADggEBADx7iC/fFFVdDcRSIkNL
# pmoN0N+VlVEc8l2onOzSlEJ1SriEprKopRIl09I/mQgGbaKXTRaD/7VEtyaKHA5h
# VnrNi/TAYphBcrA2F4Z6DdGBrFjkg9SBc08Ao/kU8TuVpbBEYyfk10FuZY4ACrfG
# 61nUuo5yTtpf0Ri8ryQ0msFEUkgy8eEryV0SuzRzYmQKoE6MxNbGD2tmOhGZjpaR
# vm1aQD5B3L0aHlUzPLz8Qj9VbtVqgxPQT+z/kiDLBgc6ljCZANHtRsxrZzZMtbHA
# RV8Scbl9QdRdsrUgBc4dL0OzIfhuF/MkiQ2mnScz3Sylf5sg+uIkAGkD49hiX7l0
# bIsxggHoMIIB5AIBATA2MCIxIDAeBgNVBAMMF1Bvd2VyU2hlbGwgQ29kZSBTaWdu
# aW5nAhAhJdz/pZUJl0w5S3ajUOpeMA0GCWCGSAFlAwQCAQUAoIGEMBgGCisGAQQB
# gjcCAQwxCjAIoAKAAKECgAAwGQYJKoZIhvcNAQkDMQwGCisGAQQBgjcCAQQwHAYK
# KwYBBAGCNwIBCzEOMAwGCisGAQQBgjcCARUwLwYJKoZIhvcNAQkEMSIEIOs6YW+S
# T+XstiB1YXnHD73ohuuv1yXVd1Aicr/aOGrYMA0GCSqGSIb3DQEBAQUABIIBAHMV
# TnBI5BoGvZw5qaFQ4Nw1EprHWZSUYcijJyXj4UTWxc/+SXTxI1fjCj0EWWZ4poDG
# FCNyhHsqp2Itnz6g59hI1PzaTStV9a/9cBqguVdxWtTHZdFv3MZdDmyhJoBTt/+2
# 4ZWw5Ojbn52FYe0VsLYfjnV17jls5YppFVmB2Ar6SA0Fn4g6ySMvy53DArWB5Stm
# NCooALw03gjyum3jq7sJ8QithEXURElZOjiyFxu+/ZhQ8QN7NC+s8R1nZkH8ooO1
# RY7BgCWybz8jLFLwpceYRBPO33xP9veyyyMbeGmsJKFHIruw/CPjuX7gEaiX2Y7y
# MKHMuI6b++oWi4mRmaI=
# SIG # End signature block
