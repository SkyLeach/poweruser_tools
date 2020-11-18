# hideous powershell script format... blech
# iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))

# choco install -y git

# Make `refreshenv` available right away, by defining the $env:ChocolateyInstall
# variable and importing the Chocolatey profile module.
# Note: Using `. $PROFILE` instead *may* work, but isn't guaranteed to.
$env:ChocolateyInstall = Convert-Path "$((Get-Command choco).Path)\..\.."   
Import-Module "$env:ChocolateyInstall\helpers\chocolateyProfile.psm1"

# refreshenv is now an alias for Update-SessionEnvironment
# (rather than invoking refreshenv.cmd, the *batch file* for use with cmd.exe)
# This should make git.exe accessible via the refreshed $env:PATH, so that it
# can be called by name only.
refreshenv

# verify it worked?  Maybe a test function?  Nah...
