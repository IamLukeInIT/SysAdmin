$UserList = Import-Csv -Delimiter ';' -Path C:\plik.csv
$UserList

ForEach ($U in $UserList) {
    $user = $U.Samaccountname
    $ipphone = $U.Phone
    $otheripphone = $U.otherIpPhone

    Set-ADUSer -Identity $user -replace @{ipphone=$ipphone}
    Set-ADUSer -Identity $user -replace @{otheripphone=$otheripphone}
    Write-Host -ForegroundColor Green "Ustawiono IpPhone na: $ipphone oraz otherIpPhone na: $otheripphone dla $user"
}
