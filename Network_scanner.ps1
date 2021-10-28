#http://eddiejackson.net/web_documents/Building_Forms_with_PowerShell_Part1.pdf

Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing
Add-Type -AssemblyName PresentationCore,PresentationFramework

$font = New-Object System.Drawing.Font("Arial", 12)
#frame
$form = New-Object System.Windows.Forms.Form
$form.WindowState = 'Maximized'
$form.Text = 'Network scanner v.1.0.0'
$form.Size = New-Object System.Drawing.Size(2000,1500)
$form.StartPosition = 'CenterScreen'
$form.BackColor = 'white'
$form.Font = $font

#light/dark mode


#hostname
$lhost = hostname
$user = New-Object System.Windows.Forms.Label
$user.Location = New-Object System.Drawing.Point(35,10) #left, top
$user.Size = New-Object System.Drawing.Size(140,15) #width, height
$user.Text = 'User: ' +$lhost
$user.ForeColor = '#009EDC'
$user.BackColor = '#dcdcde'
$form.Controls.Add($user)

#Get IP address
$address = Get-NetIPAddress -AddressFamily IPv4 | Select-Object InterfaceAlias, IPAddress | Format-List | Out-String
$myIP = New-Object System.Windows.Forms.Label
$myIP.Location = New-Object System.Drawing.Point(35,50) #left, top
$myIP.Size = New-Object System.Drawing.Size(350,450)
$myIP.Text = $address
$myIP.ForeColor = '#009EDC'
$form.Controls.Add($myIP)

#LAN connection
    $pingLAN = Test-Connection 192.168.1.5  | Select-Object '@{Status=Success}' -First 1 #ping DNS
    $pingLANlog = "@{@{Status=Success}=}"
    if ($pingLANlog -eq $pingLAN){
        $statusLAN = "OK."
    }else{
        $statusLAN = "FAILED."
    }
$pingLAN = New-Object System.Windows.Forms.Label
$pingLAN.Location = New-Object System.Drawing.Point(190,10)
$pingLAN.Size = New-Object System.Drawing.Size(80,15)
$pingLAN.Text = 'LAN: '+$statusLAN
$pingLAN.ForeColor = '#009EDC'
$pingLAN.BackColor = '#dcdcde'
$form.Controls.Add($pingLAN)

#Internet connection
$pingWAN = Test-Connection 216.58.215.110  | Select-Object '@{Status=Success}' -First 1 #ping Google
$pingWANlog = "@{@{Status=Success}=}"
if ($pingWANlog -eq $pingWAN){
    $statusWAN = "OK."
}else{
    $statusWAN = "FAILED."
}
$pingWAN = New-Object System.Windows.Forms.Label
$pingWAN.Location = New-Object System.Drawing.Point(340,10)
$pingWAN.Size = New-Object System.Drawing.Size(120,15)
$pingWAN.Text = 'Internet: '+$statusWAN
$pingWAN.ForeColor = '#009EDC'
$pingWAN.BackColor = '#dcdcde'
$form.Controls.Add($pingWAN)

$up_panel = New-Object System.Windows.Forms.Label
$up_panel.Location = New-Object System.Drawing.Point(0,10)
$up_panel.Size = New-Object System.Drawing.Size(2000,20)
$up_panel.BackColor = '#dcdcde'
$form.Controls.Add($up_panel)
#change IP address

#disylay port
#Get-NetTcpConnection | Select-Object LocalPort -Unique

#show shared folders
$dictionary = Get-SmbShare | Select-Object Path -Skip 4 | Out-String
$shared = New-Object System.Windows.Forms.Label
$shared.Location = New-Object System.Drawing.Point(400,85)
$shared.Size = New-Object System.Drawing.Size(200,200)
$shared.Text = 'Shared folders: ' +$dictionary
$shared.ForeColor = '#009EDC'
$form.Controls.Add($shared)




#measure network speed
$speed = New-Object System.Windows.Forms.Button
$speed.Location = New-Object System.Drawing.Point(50,955) #left, top
$speed.Size = New-Object System.Drawing.Size(170,50) #width, height
$speed.Text = 'Speed Test (Download)'
$speed.ForeColor = '#009EDC'
$form.Controls.Add($speed)
$speed.Add_Click({NetworkSpeed})
function NetworkSpeed{
    # The test file has to be a 10MB file for the math to work. If you want to change sizes, modify the math to match
    $TestFile  = 'https://ftp.sunet.se/mirror/parrotsec.org/parrot/misc/10MB.bin'
    $TempFile  = Join-Path -Path $env:TEMP -ChildPath 'testfile.tmp'
    $WebClient = New-Object Net.WebClient
    $TimeTaken = Measure-Command { $WebClient.DownloadFile($TestFile,$TempFile) } | Select-Object -ExpandProperty TotalSeconds
    $SpeedMbps = (10 / $TimeTaken) * 8
    $Message = "{0:N2} Mbit/sec" -f ($SpeedMbps)
    [System.Windows.MessageBox]::Show("Download speed: $Message")
}


$down_panel = New-Object System.Windows.Forms.Label
$down_panel.Location = New-Object System.Drawing.Point(0,925)
$down_panel.Size = New-Object System.Drawing.Size(2000,110)
$down_panel.BackColor = '#dcdcde'
$form.Controls.Add($down_panel)

$result = $form.ShowDialog()
if ($result -eq [System.Windows.Forms.DialogResult]::OK)
{}
