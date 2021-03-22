#Instructions: If you have any errors after "Locating bookmark file paths..." replace everything after "$pathEdgeBookmarks =" and "$pathChromeBookmarks =" with respective Microsoft Edge and Chrome file paths for your Bookmarks file, bounded in quotes. Example: $pathChromeBookmarks = "C:\Users\bobsmith\AppData\Local\Google\Chrome\User Data\Profile 2\Bookmarks"
Write-Output "Locating bookmark file paths..."
$pathEdgeBookmarks = Get-ChildItem -Recurse -Path "$env:localappdata\Microsoft\Edge\User Data\*\Bookmarks"
$pathChromeBookmarks = Get-ChildItem -Recurse -Path "$env:localappdata\Google\Chrome\User Data\*\Bookmarks"
#$pathEdgeBookmarks = "$env:localappdata\Microsoft\Edge\User Data\Default\Bookmarks"
#$pathChromeBookmarks = "$env:localappdata\Google\Chrome\User Data\Profile 2\Bookmarks"
Write-Output "Exporting bookmarks as html..."
.\exportBookmarks.ps1 -pathToJsonFile $pathEdgeBookmarks -htmlOut "$PSScriptRoot\bookmarks-edge.html"
.\exportBookmarks.ps1 -pathToJsonFile $pathChromeBookmarks -htmlOut "$PSScriptRoot\bookmarks-chrome.html"
Get-Content bookmarks-edge.html, bookmarks-chrome.html | Set-Content bookmarks-joined.html
Write-Output "Emptying bookmarks link directory to recompile..."
if (!(Test-Path "$PSScriptRoot/bookmarks")) {
    New-Item -itemType Directory -Path $PSScriptRoot -Name "bookmarks"
    }
else {
    Remove-Item "$PSScriptRoot\bookmarks\*.*"
    }
Write-Output "Extracting links from export files..."
invoke-expression -Command "cmd /C cscript $PSScriptRoot\extractBookmarks.vbs"
Write-Output "Cleaning export files..."
Remove-item "$PSScriptRoot\bookmarks-chrome.html"
Remove-item "$PSScriptRoot\bookmarks-edge.html"
Remove-item "$PSScriptRoot\bookmarks-joined.html"
Write-Output "Done! Closing in 10 seconds..."
Start-Sleep -Seconds 10