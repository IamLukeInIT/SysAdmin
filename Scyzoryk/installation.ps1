$RegistryPath= "HKCR:\Microsoft.PowerShellScript.1\Shell"
$ValueData="0"

$newupdate = "\\192.168.1.33\HelpDesk\skrypty\Scyzoryk\Scyzoryk*.ps1"
$file = "C:\Scyzoryk\Scyzoryk.ps1"
$user = $env:UserName
$desktop = "C:\Users\$user\Desktop\Scyzoryk.ps1"

Write-Host "Proces instalacji Scyzroyk. START." -ForegroundColor Blue

New-PSDrive HKCR Registry HKEY_CLASSES_ROOT
Set-ItemProperty HKCR:\Microsoft.PowerShellScript.1\Shell '(Default)' $ValueData
New-Item 'HKCR:\Microsoft.PowerShellScript.1\Shell\Run with PowerShell (Admin)'
New-Item 'HKCR:\Microsoft.PowerShellScript.1\Shell\Run with PowerShell (Admin)\Command'
Set-ItemProperty 'HKCR:\Microsoft.PowerShellScript.1\Shell\Run with PowerShell (Admin)\Command' '(Default)' '"C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe" "-Command" ""& {Start-Process PowerShell.exe -ArgumentList ''-ExecutionPolicy RemoteSigned -File \"%1\"'' -Verb RunAs}"'

Write-Host "Wartoœæ rejestru $RegistryPath zmieniona na $ValueData" -ForegroundColor Green

Write-Host "Tworzenie folderu" -ForegroundColor Yellow

New-Item -Path "C:\Scyzoryk" -ItemType Directory

Write-Host "Kopiowanie plików." -ForegroundColor Yellow

Copy-Item -Path $newupdate -Destination C:\Scyzoryk -Confirm:$False
Copy-Item -Path $file -Destination $desktop
Copy-Item -Path \\192.168.1.33\HelpDesk\skrypty\Scyzoryk\version_104.txt -Destination C:\Scyzoryk\
    
Write-Host "Proces instalacji Scyzoryk STOP" -ForegroundColor Yellow
Write-Host "Proces instalacji Scyzoryk zakoñczony pomyœlnie." -ForegroundColor Green


pause