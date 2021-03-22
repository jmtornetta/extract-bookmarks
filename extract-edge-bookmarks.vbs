Const ForReading = 1, ForWriting = 2, ForAppending = 8, CreateIfNeeded = true
Set objFSO = CreateObject("Scripting.FileSystemObject")
bookmarkfile = "bookmarks-edge.html"
Set bookmarks = objFSO.OpenTextFile(bookmarkfile, ForReading)
Set regEx = New RegExp
regEx.Global = True
regex.ignorecase = True
Set regEx2 = New RegExp
regEx2.Global = True
regEx2.Pattern = "[^a-zA-Z0-9-_. ]"
dim fso, fullPathToBookmarkFile
set fso = CreateObject("Scripting.FileSystemObject")
fullPathToBookmarkFile = fso.GetAbsolutePathName(bookmarkfile)
outpath = Replace(fullPathToBookmarkFile,"\bookmarks-edge.html","\bookmarks")

regEx.Pattern = "<DT><A HREF=""(.*)"" ADD_DATE.*>(.*)</A>"
do until bookmarks.AtEndOfStream
  line = bookmarks.readline()
  if regEx.test(line) then
    shortcut = regEx.Replace(line,"$1")
    filename = trim(regEx.Replace(line,"$2"))
    filename = Regex2.Replace(filename, "_")
    filename = outpath & "\" & left(filename, 80) & ".url"
    'wscript.echo filename -- 03/20/2021 JT: commenting out to prevent dialogs from running to speed things up
    'the following skips invalid filenames, you should add a routine to filter out invalid filename characters in your codeset
    on error resume next
    Set objFile = objFSO.OpenTextFile(filename, ForWriting, CreateIfNeeded)
    if err.number <> 0 then
      wscript.echo err.description
    end if
    objFile.write "[InternetShortcut]" & vbcrlf & "URL=" & shortcut
    objFile.close
  end if
loop