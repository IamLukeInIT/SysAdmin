$name = hostname
$date = Get-Date | Select-Object DateTime

$PC = Get-CimInstance -ClassName Win32_ComputerSystem | Select-Object Name, Manufacturer, Model, SystemType
$OS = Get-CimInstance -ClassName Win32_OperatingSystem | Select-Object Version
$USR = Get-CimInstance -ClassName Win32_ComputerSystem | Select-Object UserName
$Address = Get-NetIPAddress | Where-Object InterfaceAlias -eq Ethernet | Select-Object IPAddress, InterfaceIndex
$Disk = Get-Disk | Select-Object FriendlyName, HealthStatus
$DiskSize = Get-CimInstance -ClassName Win32_LogicalDisk | Select-Object @{n="Size";e={[math]::Round($_.Size/1GB,2)}}, @{n="FreeSpace";e={[math]::Round($_.FreeSpace/1GB,2)}}

$Print = 'Log z inwentaryzacji komputera', $date, $USR, 'Podstawowe dane:',$PC, 'System Windows:',$OS, 'Ustawienia karty sieciowej:', $Address, 'Dysk:', $Disk, $DiskSize

$Print | Format-List | Out-File -FilePath #$name.txt #File location