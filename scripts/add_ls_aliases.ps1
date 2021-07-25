# SkyLeach NOTE: this is useful to get colorized item keys and
# formatting like bash ls, installed by `choco install
# get-childitemcolor`
#
If (-Not (Test-Path Variable:PSise)) {  # Only run this in the console and not in the ISE
    Import-Module Get-ChildItemColor
    
    Set-Alias ll Get-ChildItem -option AllScope
    Set-Alias ls Get-ChildItemColorFormatWide -option AllScope
}
# Change color for directories to Blue
$GetChildItemColorTable.File['Directory'] = "Blue"

# Change color for executables to Green
ForEach ($Exe in $GetChildItemColorExtensions.ExecutableList) {
    $GetChildItemColorTable.File[$Exe] = "Green"
}
$Global:GetChildItemColorVerticalSpace = 1

