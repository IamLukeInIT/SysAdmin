Write-Host "Pierwsza konfiguracja komputera: START" -ForegroundColor Yellow

$choice = Read-Host "Wybierz opcję:
1. Tworzenie partycji, zmiana nazwy, zmiana adresu IP, dodanie do domeny.
2. Tworzzenie folderu Dokumenty, tworzzenie skrótu Dokumenty, instalacja programów, tworzenie GPO, połączenie WSUS."


if ($choice -eq 1){
    Write-Host "Tworzenie partycji" -ForegroundColor Yellow
    New-Partition -DiskNumber 1 -Size 50gb -DriveLetter D
    Write-Host "Utworzono partycję D o wielkośći 50GB" -ForegroundColor Green

    $name= Read-Host "Wpisz nazwę komputera" 
    $address= Read-Host "Wpisz adres IP"

    Write-Host "Zmiana nazwy komputera" -ForegroundColor Yellow
    Rename-Computer -newname "$name"
    if (hostname -eq $name){
        Write-Host "Nazwa komputera zmieniona na $name." -ForegroundColor Green
    }else{
        Write-Host "Zmiana nazwy nie powiodła się." -ForegroundColor Red
    }

    Write-Host "Zmiana adresu IP komputera" -ForegroundColor Yellow
    New-NetIPAddress -InterfaceAlias "Ethernet" -IPAddress $address -DefaultGateway 192.168.1.5 -PrefixLength 24
    Set-DnsClientServerAddress -InterfaceAlias "Ethernet" -ServerAddresses "192.168.1.6"
    if ( -eq $adress){
        Write-Host "Adres IP komputera ustawiono na $adress" -ForegroundColor Green
            function Check{
                Write-Host "Sprawdzenie połączenia z Paszczak" -ForegroundColor Blue
                Test-Connection 192.168.1.5
                Write-Host "Sprawdzenie połączenia z Syriusz" -ForegroundColor Blue
                Test-Connection 192.168.1.13
                Write-Host "Sprawdzenie połączenia z Internetem" -ForegroundColor Blue
                Test-Connection 212.77.98.9
            }
    }else{
        Write-Host "Zmiana adresu nie powiodła się." -ForegroundColor Red
    }

    Write-Host "Dodawanie stacji roboczej do domeny pup.jawor.pl" -ForegroundColor Yellow 

    $domain= "pup.jawor.pl"
    $user= "test"
    $domainuser= "$domain\$user"

    Add-Computer -DomainName $domain -Credential $domainuser
}

if ($choice -eq 2){
    $folder = Read-Host "Podaj nazwę użytkownika:"
    Write-Host "Tworzenie folderu $folder" -ForegroundColor Yellow 

    New-Item -Path D:\Dokumenty -ItemType Directory
    Write-Host "Utworzenie folderu Dokumenty na dysku D dla użytkownika" -ForegroundColor Green 

    $WScriptShell = New-Object -ComObject WScript.Shell
    $shortcut = $WScriptShell.CreateShortcut("C:\Users\*\Desktop\Dokumenty.lnk")
    $shortcut.TargetPath = "D:\Dokumenty"
    $shortcut.Save()
    Write-Host "Utworzenie skrótu na pulpicie folderu Dokumenty" -ForegroundColor Green 

    $java = '\\192.168.1.33\Helpdesk\MSI\jre1.8.0_22164.msi'
    $zip = '\\192.168.1.33\Helpdesk\MSI\7z1900-x64.msi'
    $adobe = '\\192.168.1.33\HelpDesk\MSI\AcroRead.msi'
    $chrome = '\\192.168.1.33\Helpdesk\MSI\GoogleChromeStandaloneEnterprise64.msi'

    Invoke-CimMethod -ClassName Win32_Product -MethodName Install -Arguments @{PackageLocation=$java} # java
    Write-Host "Zainstalowano Java" -ForegroundColor Green
    Invoke-CimMethod -ClassName Win32_Product -MethodName Install -Arguments @{PackageLocation=$zip} #7ZIP
    Write-Host "Zainstalowano 7zip" -ForegroundColor Green
    Invoke-CimMethod -ClassName Win32_Product -MethodName Install -Arguments @{PackageLocation=$adobe} #adobe
    Write-Host "Zainstalowano Adobe" -ForegroundColor Green
    Invoke-CimMethod -ClassName Win32_Product -MethodName Install -Arguments @{PackageLocation=$chrome} #browser
    Write-Host "Zainstalowano Chrome" -ForegroundColor Green

    Write-Host "Tworzenie GPO" -ForegroundColor Yellow
    Restore-GPO -All -Domain "pup.jawor.pl" -Path "\\192.168.1.34\backup\GPO"
    Invoke-GPUpdate
    Write-Host "Zaktualizowano zasady GPO" -ForegroundColor Green
}
pause
Write-Host "Procedura stop. Komputer zostanie zresetowany" -ForegroundColor Red
shutdown -r -t 1