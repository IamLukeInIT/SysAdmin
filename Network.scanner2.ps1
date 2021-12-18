#http://eddiejackson.net/web_documents/Building_Forms_with_PowerShell_Part1.pdf

Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing
Add-Type -AssemblyName PresentationCore,PresentationFramework

$font = New-Object System.Drawing.Font("Arial", 12)
#frame
$form = New-Object System.Windows.Forms.Form
$form.Size = New-Object System.Drawing.Size(600,200) #width height
$form.Text = 'Network scanner v.2.0.0'
$form.StartPosition = 'CenterScreen'
$form.Font = $font

#hostname
$lhost = hostname
$user = New-Object System.Windows.Forms.Label
$user.Location = New-Object System.Drawing.Point(0,0) #left, top
$user.Size = New-Object System.Drawing.Size(300,20) #width, height
$user.Text = 'User: ' +$lhost
$user.ForeColor = '#009EDC'
$user.BackColor = '#dcdcde'
$form.Controls.Add($user)

#LAN connection
$pingLAN = Test-Connection 192.168.1.5 -Count 2 | Select-Object '@{Status=Success}' -First 1 #ping DNS
$pingLANlog = "@{@{Status=Success}=}"
if ($pingLANlog -eq $pingLAN){
    $statusLAN = "OK."
}else{
    $statusLAN = "FAILED."
}
$pingLAN = New-Object System.Windows.Forms.Label
$pingLAN.Location = New-Object System.Drawing.Point(300,0)
$pingLAN.Size = New-Object System.Drawing.Size(150,20)
$pingLAN.Text = 'LAN: '+$statusLAN
$pingLAN.ForeColor = '#009EDC'
$pingLAN.BackColor = '#dcdcde'
$form.Controls.Add($pingLAN)

#Internet connection
$pingWAN = Test-Connection 216.58.215.110 -Count 2 | Select-Object '@{Status=Success}' -First 1 #ping Google
$pingWANlog = "@{@{Status=Success}=}"
if ($pingWANlog -eq $pingWAN){
$statusWAN = "OK."
}else{
$statusWAN = "FAILED."
}
$pingWAN = New-Object System.Windows.Forms.Label
$pingWAN.Location = New-Object System.Drawing.Point(450,0)
$pingWAN.Size = New-Object System.Drawing.Size(145,20)
$pingWAN.Text = 'Internet: '+$statusWAN
$pingWAN.ForeColor = '#009EDC'
$pingWAN.BackColor = '#dcdcde'
$form.Controls.Add($pingWAN)

#report
$report = New-Object System.Windows.Forms.Button
$report.Location = New-Object System.Drawing.Point(210,60) #left, top
$report.Size = New-Object System.Drawing.Size(150,50) #width, height
$report.Text = 'Download report'
$report.ForeColor = '#009EDC'
$form.Controls.Add($report)
$report.Add_Click({report})
function report{
    $before = New-Object System.Windows.Forms.Label
    $before.Location = New-Object System.Drawing.Point(250,120)
    $before.Size = New-Object System.Drawing.Size(170,20)
    $before.Font = New-Object System.Drawing.Font("Arial", 8)
    $before.Text = 'In progress...'
    $before.ForeColor = '#006e9a'
    $form.Controls.Add($before)

    $path = 'C:\Reports'
    #hostname
    $device = hostname
    #Get IP address
    $address = Get-NetIPAddress -AddressFamily IPv4 | Select-Object InterfaceAlias, IPAddress
    #ping something in LAN
    $pingLAN = Test-Connection 192.168.1.255 -Count 1 | Out-String
    #ping Google   
    $pingWAN = Test-Connection 216.58.215.110 -Count 1 | Out-String
    #disylay port
    $display_ports = Get-NetTcpConnection | Select-Object LocalPort -Unique | Format-Wide -Column 6 | Out-String
    #shared folders
    $shared = Get-SmbShare | Select-Object Path -Skip 4 | Out-String
    #ipscanner
    $scanner = 1..10 | ForEach-Object -Process {
        Test-Connection 192.168.43.$_ -Count 1 -Delay 1 | Select-Object Address | Format-Wide -Column 6 | Out-String
    }

    $Print = 'Hostname:', $device, ,'','#############################################','IP addresses',$address, '#############################################','LAN connection:', $pingLAN, 'WAN connection:',$pingWAN, '#############################################','Open ports:',$display_ports, '#############################################','Shared folders',$shared, '#############################################','IP scanner',$scanner
    $Print | Format-List | Out-File -FilePath $path/Network_report_$device.txt #File location1

    $after = New-Object System.Windows.Forms.Label
    $after.Location = New-Object System.Drawing.Point(250,120)
    $after.Size = New-Object System.Drawing.Size(170,20)
    $after.BackColor = 'white'
    $form.Controls.Add($after)

    [System.Windows.MessageBox]::Show("Report complete. The report has been saved in the $path")
}

$result = $form.ShowDialog()
if ($result -eq [System.Windows.Forms.DialogResult]::OK)
{}