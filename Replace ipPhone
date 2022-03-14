$UserList = Import-Csv -Delimiter ';' -Path C:\users.csv
$UserList

ForEach($U in $UserList) {  
    $user = $U.Samaccountname 
    $phone = $U.Phone
    Set-ADUser -Identity $user -replace @{ipphone=$phone} 
}
