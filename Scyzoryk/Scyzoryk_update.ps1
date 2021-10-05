$update = "104" #new version
$newupdate = "\\192.168.1.33\HelpDesk\skrypty\Scyzoryk\Scyzoryk*.ps1"
$old = "C:\Scyzoryk\Scyzoryk_script_v$version.ps1"
$user = $env:UserName
$shortcut = "C:\Users\$user\Desktop\Scyzoryk.ps1"
$desktop = "C:\Users\$user\Desktop\Scyzoryk.ps1"
$file = "C:\Scyzoryk\Scyzoryk.ps1"

Write-Host "Najnowsza wersja programu: $update" -ForegroundColor Yellow

    Write-Host "Twoja wersja programu: $version. Wymagana jest aktualizacja." -ForegroundColor Yellow
    Write-Host "##########AKTUALIZOWANIE##########" -ForegroundColor Blue
    Copy-Item -Path $newupdate -Destination C:\Scyzoryk -Confirm:$False

    Remove-Item -Path $old
    Remove-Item -Path $shortcut
    Copy-Item -Path $file -Destination $desktop

    Remove-Item -Path C:\Scyzoryk\Scyzoryk_script_v103.ps1

    Remove-Item -Path C:\Scyzoryk\version_103.txt
    Copy-Item -Path \\192.168.1.33\HelpDesk\skrypty\Scyzoryk\version_104.txt -Destination C:\Scyzoryk\
    
    Write-Host "Aktualizacja do wersji $update zakoñczona." -ForegroundColor Green

