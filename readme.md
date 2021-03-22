# instructions
1. Run "exportAndExtractBookmarks.ps1" via PowerShell
2. Find exported bookmark links in "bookmarks" folder in this directory. Optionally add this directory to your launcher index.
3. Extra: import the "ExportAndExtractBookmarks--TaskScheduler.xml" file into Windows Task Scheduler to run this at login and every day at 4PM. Modify as needed.

# troubleshoot
## all links are not appearing
1. Edit "exportAndExtractBookmarks.ps1" with your favorite text editor
2. Replace everything after "$pathEdgeBookmarks =" and "$pathChromeBookmarks =" with respective Microsoft Edge and Chrome file paths for your Bookmarks file, bounded in quotes.
3. Example: $pathChromeBookmarks = "C:\Users\bobsmith\AppData\Local\Google\Chrome\User Data\Profile 2\Bookmarks"

# problem
Modern broswers do not often export bookmarks into multiple shortcut/link files. They instead create a single html export file. While faster, this approach does not allow a user to easily index bookmark files when using launcher tools like the Windows Search, Cortana, Launchy, Wox, Everything and PowerToys Run 

# summary
Exports and extracts bookmarks from Chrome and Edge into a folder that can be easily archived by launchers like Windows Search, Cortana, Launchy, Wox, Everything and PowerToys Run.

# future
1. Combine export and extract scripts to minimize redundant code and increase speed.
2. Add support for Firefox by importing and converting "<Drive>:\Users\<Name>\AppData\Roaming\Mozilla\Firefox\Profiles\<edition>-default\bookmarkbackups" into HTML file
3. Test application with all launcher tools. I have only tested this program with PowerToys Run as it is supported by Microsoft, secure and fairly stable.
