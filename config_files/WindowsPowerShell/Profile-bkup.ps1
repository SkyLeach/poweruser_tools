# last verified 10/11/2024 1:37:05 PM
# $MyDocuments = [Environment]::GetFolderPath("mydocuments")
# Import-Module $MyDocuments\WindowsPowerShell\Modules\VirtualEnvWrapper.psm1
# Import-Module $env:ChocolateyInstall\helpers\chocolateyProfile.psm1
# Previous verification wasn't enough, pulled this from stackoverflow and
# tested it finding it actually works where the previous one didn't.
# Verified: 10/15/2024 9:30:42 PM

# Commented out because it doesn't work.  Replaced with above
# $PowerShellProfile = $PROFILE.CurrentUserAllHosts
# $PowerShellPath = Split-Path $PowerShellProfile
# Import-Module $PowerShellPath\Modules\VirtualEnvWrapper.psm1

$host.PrivateData.ErrorForegroundColor = 'Magenta'


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

#f45873b3-b655-43a6-b217-97c00aa0db58 PowerToys CommandNotFound module

# Import-Module -Name Microsoft.WinGet.CommandNotFound
# Import-Module -Name Microsoft.PowerToys.Configure
#f45873b3-b655-43a6-b217-97c00aa0db58

# SIG # Begin signature block
# MIIFhQYJKoZIhvcNAQcCoIIFdjCCBXICAQExCzAJBgUrDgMCGgUAMGkGCisGAQQB
# gjcCAQSgWzBZMDQGCisGAQQBgjcCAR4wJgIDAQAABBAfzDtgWUsITrck0sYpfvNR
# AgEAAgEAAgEAAgEAAgEAMCEwCQYFKw4DAhoFAAQURgE9FkHTZ0klpieHXqGTVkSu
# haegggMYMIIDFDCCAfygAwIBAgIQISXc/6WVCZdMOUt2o1DqXjANBgkqhkiG9w0B
# AQUFADAiMSAwHgYDVQQDDBdQb3dlclNoZWxsIENvZGUgU2lnbmluZzAeFw0yNDEw
# MDcxODI5NTRaFw0yNTEwMDcxODQ5NTRaMCIxIDAeBgNVBAMMF1Bvd2VyU2hlbGwg
# Q29kZSBTaWduaW5nMIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAuAZf
# B4oe21LnZV2iXTPazKFPEAm25AUD74YxkbtmLzv+0nLItqbtnxkh6Soo1EwoJkgt
# m2Q/7jcXMC5mk67/jesrlz0Fp0I3nav1dQYp7ebXDtV0MGQMTcDgzk0+iFlpxosS
# abXFCVB/1jUIzfcTEFgtvB3+1kg9QZEnrUSyxCnbbCVE8wrnLOR6YccngZDP9tlW
# XYmHUQFfvXW/ewdJujD7jhXAcV6AZxWHgP9/A1bwit3G2fPSVnNP1MGjzIlp9YGw
# ONsknTLJoP1xTHEV7NYM57oRSovh+zq9+foYBSGEpQl8eBaYsEyL3jhbjyKr9Y40
# Jrm7MYAA49ByjB9i8QIDAQABo0YwRDAOBgNVHQ8BAf8EBAMCB4AwEwYDVR0lBAww
# CgYIKwYBBQUHAwMwHQYDVR0OBBYEFAzX51jyY/NfBq7oUWOle0g1KQiHMA0GCSqG
# SIb3DQEBBQUAA4IBAQA8e4gv3xRVXQ3EUiJDS6ZqDdDflZVRHPJdqJzs0pRCdUq4
# hKayqKUSJdPSP5kIBm2il00Wg/+1RLcmihwOYVZ6zYv0wGKYQXKwNheGeg3RgaxY
# 5IPUgXNPAKP5FPE7laWwRGMn5NdBbmWOAAq3xutZ1LqOck7aX9EYvK8kNJrBRFJI
# MvHhK8ldErs0c2JkCqBOjMTWxg9rZjoRmY6Wkb5tWkA+Qdy9Gh5VMzy8/EI/VW7V
# aoMT0E/s/5IgywYHOpYwmQDR7UbMa2c2TLWxwEVfEnG5fUHUXbK1IAXOHS9DsyH4
# bhfzJIkNpp0nM90spX+bIPriJABpA+PYYl+5dGyLMYIB1zCCAdMCAQEwNjAiMSAw
# HgYDVQQDDBdQb3dlclNoZWxsIENvZGUgU2lnbmluZwIQISXc/6WVCZdMOUt2o1Dq
# XjAJBgUrDgMCGgUAoHgwGAYKKwYBBAGCNwIBDDEKMAigAoAAoQKAADAZBgkqhkiG
# 9w0BCQMxDAYKKwYBBAGCNwIBBDAcBgorBgEEAYI3AgELMQ4wDAYKKwYBBAGCNwIB
# FTAjBgkqhkiG9w0BCQQxFgQUnlDN/DHnzmv7xYg8z83mVVVKTg4wDQYJKoZIhvcN
# AQEBBQAEggEARRUBcoe4GCuI+DprOuPrjZGZDfJYff4Q63tZTpNriB+u/oIuxrKt
# JNqJudoLXXVORVpiZtPrWxJGYi/d6I8sZTN4VDqciOlHOoiFl4sn09jb+YDboVJ6
# xn/y9K+zOdMeGg06Z2ivraiUSTofSlg0bhnjxZMyypRBP23TQpWIjd11LQyPo5kq
# LJLeQ9rcLXxnyqBy+7VF3/NYxORdv0tUTmnuJlHOG+b8DXuQJJ50PSjy1+rP/2NW
# LIV7yZRNaDGzSz+zGBoOq44wa7q5P7ZouhDiCj5AZnx5yE1FFrIYYzXEYSsjiaNp
# T5cnujXWfno2J+FGz94WmPeFA/xwbCSg5w==
# SIG # End signature block
