$name = hostname
$date = Get-Date | Select-Object DateTime

$PC = Get-CimInstance -ClassName Win32_ComputerSystem | Select-Object Name, Manufacturer, Model, SystemType
$OS = Get-CimInstance -ClassName Win32_OperatingSystem | Select-Object Version
$USR = Get-CimInstance -ClassName Win32_ComputerSystem | Select-Object UserName
$Address = Get-NetIPAddress | Where-Object InterfaceAlias -eq Ethernet | Select-Object IPAddress, InterfaceIndex
$Disk = Get-Disk | Select-Object FriendlyName, HealthStatus
$DiskSize = Get-CimInstance -ClassName Win32_LogicalDisk | Select-Object @{n="Size GB";e={[math]::Round($_.Size/1GB,2)}}, @{n="FreeSpace GB";e={[math]::Round($_.FreeSpace/1GB,2)}}
$RAM = Get-CimInstance win32_physicalmemory | Select-Object Manufacturer, @{n="Capacity GB";e={[math]::Round($_.Capacity/1GB,2)}}

$Print = 'Log z inwentaryzacji komputera', $date, $USR, 'Podstawowe dane:',$PC, 'System Windows:',$OS, 'Dysk:', $Disk, $DiskSize, 'RAM:', $RAM, 'Ustawienia karty sieciowej:',$Address

$Print | Format-List | Out-File -FilePath \\192.168.1.33\HelpDesk\Komputery\$name.txt #File location