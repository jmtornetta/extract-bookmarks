$pathExportChrome = "$PSScriptRoot\export-chrome-bookmarks.ps1"
$pathExportEdge = "$PSScriptRoot\export-edge-bookmarks.ps1"
$pathExtractChrome = "$PSScriptRoot\extract-chrome-bookmarks.vbs"
$pathExtractEdge = "$PSScriptRoot\extract-edge-bookmarks.vbs"

Write-Output "Exporting bookmarks as html..."
invoke-expression -Command $pathExportChrome
invoke-expression -Command $pathExportEdge
Write-Output "Emptying bookmarks link directory to recompile..."
Remove-Item "$PSScriptRoot\bookmarks\*.*"
Write-Output "Extracting links from export files..."
invoke-expression -Command "cmd /C cscript $pathExtractChrome"
invoke-expression -Command "cmd /C cscript $pathExtractEdge"
Write-Output "Cleaning export files..."
Remove-item "$PSScriptRoot\bookmarks-chrome.html"
Remove-item "$PSScriptRoot\bookmarks-edge.html"
Write-Output "Done! Closing in 10 seconds..."
Start-Sleep -Seconds 10