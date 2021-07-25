# GARYTOWN.COM @gwblok
# Modded by suggestion from Lor Moua on Aug 18, 2020
# rewritten by SkyLeach on 11/17/2020 11:06:30 PM
# Script to Add and/or remove items from the System Path

# param ($ptoadd=null)
# Write-Host "Argv is $args"

# Turn immutable collection from split() into Array...
[System.Collections.ArrayList]$SystemPathList = [System.Environment]::GetEnvironmentVariable("Path", "Machine").Split(";")

[System.String]$cwd
if ($args[0] -like "") {
    Write-Host "Setting cwd to current location..."
    $cwd = [System.String](Get-Location)
} else {
    Write-Host "Setting cwd to"$args[0]
    $cwd = $args[0]
}
if ($SystemPathList -contains $cwd) {
    Write-Host "$cwd already in"$SystemPathList
} else {
    $SystemPathList.Add($cwd)
 
    Write-Host "Adding '$cwd' to the System path..."
    # Set Updated Path only if cwd isn't already in it...
    [System.Environment]::SetEnvironmentVariable("Path", $SystemPathList-Join ";", "Machine")
}
