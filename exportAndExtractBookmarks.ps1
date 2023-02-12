#Instructions: If you have any errors after "Locating bookmark file paths..." replace everything after "$pathEdgeBookmarks =" and "$pathChromeBookmarks =" with respective Microsoft Edge and Chrome file paths for your Bookmarks file, bounded in quotes. Example: $pathChromeBookmarks = "C:\Users\bobsmith\AppData\Local\Google\Chrome\User Data\Profile 2\Bookmarks"

#1: Declaring function to export bookmarks once browser json file path is defined
function exportBookmarks($pathToJsonFile,$htmlOut) {
##Credit1: Mike in IT @ https://community.spiceworks.com/topic/2123065-export-chrome-bookmarks-as-html
##Credit2: tobibeer and Snak3d0c @ https://stackoverflow.com/questions/47345612/export-chrome-bookmarks-to-csv-file-using-powershell

$htmlHeader = @'
<!DOCTYPE NETSCAPE-Bookmark-file-1>
<!--This is an automatically generated file.
    It will be read and overwritten.
    Do Not Edit! -->
<META HTTP-EQUIV="Content-Type" CONTENT="text/html; charset=UTF-8">
<Title>Bookmarks</Title>
<H1>Bookmarks</H1>
<DL><p>
'@

$htmlHeader | Out-File -FilePath $htmlOut -Force -Encoding utf8

##A nested function to enumerate bookmark folders
Function Get-BookmarkFolder {
[cmdletbinding()]
Param(
[Parameter(Position=0,ValueFromPipeline=$True)]
$Node
)

Process 
{

 foreach ($child in $node.children) 
 {
   $da = [math]::Round([double]$child.date_added / 1000000) #date_added - from microseconds (Google Chrome {dates}) to seconds 'standard' epoch.
   $dm = [math]::Round([double]$child.date_modified / 1000000) #date_modified - from microseconds (Google Chrome {dates}) to seconds 'standard' epoch.
   if ($child.type -eq 'Folder') 
   {
     "    <DT><H3 FOLDED ADD_DATE=`"$($da)`">$($child.name)</H3>" | Out-File -FilePath $htmlOut -Append -Force -Encoding utf8
     "       <DL><p>" | Out-File -FilePath $htmlOut -Append -Force -Encoding utf8
     Get-BookmarkFolder $child
     "       </DL><p>" | Out-File -FilePath $htmlOut -Append -Force -Encoding utf8
   }
   else 
   {
        "       <DT><a href=`"$($child.url)`" ADD_DATE=`"$($da)`">$($child.name)</a>" | Out-File -FilePath $htmlOut -Append -Encoding utf8
  } #else url
 } #foreach
 } #process
} #end function

$data = Get-content $pathToJsonFile -Encoding UTF8 | out-string | ConvertFrom-Json
$sections = $data.roots.PSObject.Properties | select -ExpandProperty name
ForEach ($entry in $sections) {
    $data.roots.$entry | Get-BookmarkFolder
}
'</DL>' | Out-File -FilePath $htmlOut -Append -Force -Encoding utf8
}

#2: Exporting bookmarks
Write-Output "Locating bookmark file paths..."
$pathEdgeBookmarks = Get-ChildItem -Recurse -Path "$env:localappdata\Microsoft\Edge\User Data\*\Bookmarks"
$pathChromeBookmarks = Get-ChildItem -Recurse -Path "$env:localappdata\Google\Chrome\User Data\*\Bookmarks"
$pathBraveBookmarks = Get-ChildItem "$env:localappdata\BraveSoftware\Brave-Browser\User Data\*\Bookmarks"
$pathVivaldiBookmarks = Get-ChildItem "$env:localappdata\Vivaldi\User Data\*\Bookmarks
Write-Output "Exporting bookmarks as html..."
exportBookmarks $pathEdgeBookmarks "$PSScriptRoot\bookmarks-edge.html"
exportBookmarks $pathChromeBookmarks "$PSScriptRoot\bookmarks-chrome.html"
exportBookmarks $pathBraveBookmarks "$PSScriptRoot\bookmarks-brave.html"
exportBookmarks $pathVivaldiBookmarks "$PSScriptRoot\bookmarks-vivaldi.html"

#3: Joining bookmark html files and prepping bookmarks directory
Get-Content bookmarks-edge.html, bookmarks-chrome.html, bookmarks-brave.html, bookmarks-vivaldi.html | Set-Content bookmarks-joined.html
Write-Output "Emptying bookmarks link directory to recompile..."
if (!(Test-Path "$PSScriptRoot/bookmarks")) {
    New-Item -itemType Directory -Path $PSScriptRoot -Name "bookmarks"
    }
else {
    Remove-Item "$PSScriptRoot\bookmarks\*.*"
    }

#4: Extrating links from html
Write-Output "Extracting links from export files..."
invoke-expression -Command "cmd /C cscript $PSScriptRoot\extractBookmarks.vbs"

#5: Cleanup
Write-Output "Cleaning export files..."
Remove-item "$PSScriptRoot\bookmarks-chrome.html"
Remove-item "$PSScriptRoot\bookmarks-edge.html"
Remove-item "$PSScriptRoot\bookmarks-brave.html"
Remove-item "$PSScriptRoot\bookmarks-vivaldi.html"
Remove-item "$PSScriptRoot\bookmarks-joined.html"
Write-Output "Done! Closing in 10 seconds..."
Start-Sleep -Seconds 10

#6: Schedule task -- In Development
# $Trigger= New-ScheduledTaskTrigger -Once -At 4PM, New-ScheduledTaskTrigger –AtLogon # Specify the trigger settings
# $Action= New-ScheduledTaskAction -Execute "PowerShell.exe" -Argument "-executionpolicy bypass -file $PSScriptRoot\exportAndExtractBookmarks.ps1" # Specify what program to run and with its parameters
# Register-ScheduledTask -TaskName "ExportExtractBookmarks" -Trigger $Trigger -Action $Action -RunLevel Highest –Force # Specify the name of the task
