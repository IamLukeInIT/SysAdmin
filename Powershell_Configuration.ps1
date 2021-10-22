$RegistryPath= "HKCR:\Microsoft.PowerShellScript.1\Shell"
$ValueData="0"

Write-Host "
                                           █████████████████████████
                                          ██                       ██
                                         ██                         ██
                                        ██                           ██
                                       ██   ███████ ██   ██ ███████   ██
                                      ██    ██   ██ ██   ██ ██   ██    ██
                                     ██     ██   ██ ██   ██ ██   ██     ██
                                     ██     ███████ ██   ██ ███████     ██
                                      ██    ██      ██   ██ ██         ██
                                       ██   ██      ███████ ██        ██
                                        ██                           ██
                                         ██                         ██
                                          ██                       ██
                                           █████████████████████████
" -ForegroundColor Green

New-PSDrive HKCR Registry HKEY_CLASSES_ROOT
Set-ItemProperty HKCR:\Microsoft.PowerShellScript.1\Shell '(Default)' $ValueData
New-Item 'HKCR:\Microsoft.PowerShellScript.1\Shell\Run with PowerShell (Admin)'
New-Item 'HKCR:\Microsoft.PowerShellScript.1\Shell\Run with PowerShell (Admin)\Command'
Set-ItemProperty 'HKCR:\Microsoft.PowerShellScript.1\Shell\Run with PowerShell (Admin)\Command' '(Default)' '"C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe" "-Command" ""& {Start-Process PowerShell.exe -ArgumentList ''-ExecutionPolicy RemoteSigned -File \"%1\"'' -Verb RunAs}"'

Write-Host "Wartość rejestru $RegistryPath zmieniona na $ValueData" -ForegroundColor Green

pause