$nameAD = Read-Host "Podaj nazwę użytkownika w AD:"
$name = Read-Host "Podaj nazwę użytkownika:"

#Instalacja Syriusz
$client = new-object System.Net.WebClient
 $client.DownloadFile("http://192.168.1.13:8080/jtc-launcher/jtc/javawebstart?app=Og&system=SyriuszStd","C:\Users\$nameAD\Desktop\ SyriuszSTD.jtc")
 Write-Host "Pobranie SyriuszSTD na pulpit." -ForegroundColor Green 

#Skrót Ryjek
$WScriptShell = New-Object -ComObject WScript.Shell
$shortcut = $WScriptShell.CreateShortcut("C:\Users\$nameAD\Desktop\Ryjek.lnk")
$shortcut.TargetPath = "\\192.168.1.33"
$shortcut.Save()
Write-Host "Utworzenie skrótu do Ryjek na pulpicie." -ForegroundColor Green 

#Skrót Anetchat
$WScriptShell = New-Object -ComObject WScript.Shell
$shortcut = $WScriptShell.CreateShortcut("C:\Users\$nameAD\Desktop\ANetChat.lnk")
$shortcut.TargetPath = "D:\ANetChat\ANetChat.exe"
$shortcut.Save()
Write-Host "Utworzenie skrótu do ANethat na pulpicie." -ForegroundColor Green 

#Skrót Moje dokumenty
New-Item -Path D:\"Dokumenty $name" -ItemType Directory
$WScriptShell = New-Object -ComObject WScript.Shell
$shortcut = $WScriptShell.CreateShortcut("C:\Users\$nameAD\Desktop\Dokumenty $name.lnk")
$shortcut.TargetPath = "D:\Dokumenty"
$shortcut.Save()
Write-Host "Utworzenie skrótu na pulpicie folderu Dokumenty dla użytkownika $name" -ForegroundColor Green 

#Strona testowa drukarki
quser | Out-Printers

Write-Host "Procedura nowego profilu klienta zakończona." -ForegroundColor Green 
Pause