Write-Host "Before start change letter on CD-ROM" -ForegroundColor Red

Write-Host "New PC: START" -ForegroundColor Yellow

$choice = Read-Host "Choose:
1. Make partiton, change name and IP address, connection test, powershell update, add PC to domain
2. Make dictionary Dokumenty, make shortcut Dokemnty to Desktop, installation programs, GPO, WSUS"


if ($choice -eq 1){
    #Write-Host "Making partition"-ForegroundColor Yellow
    #New-Partition -DiskNumber 1 -Size 50GB -DriveLetter D
    #Write-Host "New partition 50GB" -ForegroundColor Green

    $name = Read-Host "New PC name:" 
    $address = Read-Host "New IP Address"

    Write-Host "Changing PC name" -ForegroundColor Yellow
    Rename-Computer -NewName $name
    Write-Host "New PC name: $name." -ForegroundColor Green
    
    Write-Host "Changing IP Address" -ForegroundColor Yellow
    New-NetIPAddress -InterfaceAlias "Ethernet" -IPAddress $address -DefaultGateway 192.168.1.5 -PrefixLength 24
    Set-DnsClientServerAddress -InterfaceAlias "Ethernet" -ServerAddresses "192.168.1.6"
    Write-Host "New IP Address: $adress" -ForegroundColor Green
            function Check{
                Write-Host "Test connection - Paszczak" -ForegroundColor Blue
                Test-Connection 192.168.1.5
                Write-Host "Test connection - Syriusz" -ForegroundColor Blue
                Test-Connection 192.168.1.13
                Write-Host "Test connection - Internet" -ForegroundColor Blue
                Test-Connection 212.77.98.9
            }
    Check

    Write-Host "Test done." -ForegroundColor Green

    Write-Host "Powershell update" -ForegroundColor Yellow
    Invoke-Expression "& { $(Invoke-RestMethod https://aka.ms/install-powershell.ps1) } -UseMSI"
    Write-Host "Powershell update done" -ForegroundColor Green

    winrm quickconfig

    Write-Host "Adding workstation to domain pup.jawor.pl" -ForegroundColor Yellow 
    Add-Computer -DomainName "pup.jawor.pl"-Credential pup.jawor.pl\test
}

if ($choice -eq 2){
    $WScriptShell = New-Object -ComObject WScript.Shell
    $shortcut = $WScriptShell.CreateShortcut("C:\Users\*\Desktop\Dokumenty.lnk")
    $shortcut.TargetPath = "D:\Dokumenty"
    $shortcut.Save()
    Write-Host "Making shortcut Dokumenty on Desktop." -ForegroundColor Green 

    $java = '\\192.168.1.33\Helpdesk\MSI\jre1.8.0_22164.msi'
    $zip = '\\192.168.1.33\Helpdesk\MSI\7z1900-x64.msi'
    $adobe = '\\192.168.1.33\HelpDesk\MSI\AcroRead.msi'
    $chrome = '\\192.168.1.33\Helpdesk\MSI\GoogleChromeStandaloneEnterprise64.msi'

    Invoke-CimMethod -ClassName Win32_Product -MethodName Install -Arguments @{PackageLocation=$java} #java
    Write-Host "Java installed" -ForegroundColor Green
    Invoke-CimMethod -ClassName Win32_Product -MethodName Install -Arguments @{PackageLocation=$zip} #7ZIP
    Write-Host "7zip installed" -ForegroundColor Green
    Invoke-CimMethod -ClassName Win32_Product -MethodName Install -Arguments @{PackageLocation=$adobe} #adobe
    Write-Host "Adobe installed" -ForegroundColor Green
    Invoke-CimMethod -ClassName Win32_Product -MethodName Install -Arguments @{PackageLocation=$chrome} #browser
    Write-Host "Chrome installed" -ForegroundColor Green

    Write-Host "Making GPO" -ForegroundColor Yellow
    Restore-GPO -All -Domain "pup.jawor.pl" -Path "\\192.168.1.34\backup\GPO"
    Invoke-GPUpdate
    Write-Host "GPO updated" -ForegroundColor Green
}

pause
Write-Host "New PC: STOP. Computer will be restart." -ForegroundColor Red
shutdown -r -t 1
