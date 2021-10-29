#Start > Administration > Services
#Find the Service in the list called: SQL Server (MSSQLSERVER) look for the "Log On As" column (need to add user from AD if it doesn't exist in the list).
#Restart Service SQL Server (MSSQLSERVER)

$destinationPath = '#'
$serverName = '#'
$databaseName = '#'

Backup-SqlDatabase -ServerInstance "$serverName\SQLEXPRESS" -Database "$databaseName" -BackupFile "$destinationPath\$databaseName-$(get-date -f yyyy-MM-dd).bak"