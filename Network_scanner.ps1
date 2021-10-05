Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing
Add-Type -AssemblyName PresentationCore,PresentationFramework

#frame
$form = New-Object System.Windows.Forms.Form
$form.Text = 'Network scanner v.1.0.0'
$form.Size = New-Object System.Drawing.Size(1000,500)
$form.StartPosition = 'CenterScreen'

#hostname
$lhost = hostname
$user = New-Object System.Windows.Forms.Label
$user.Location = New-Object System.Drawing.Point(850,10) #left, top
$user.Size = New-Object System.Drawing.Size(70,50) #width, height
$user.Text = 'User: ' +$lhost
$form.Controls.Add($user)

#Get IP address
$address = ipconfig | Select-Object -Skip 7 -First 3
$myIP = New-Object System.Windows.Forms.Label
$myIP.Location = New-Object System.Drawing.Point(35,10) #left, top
$myIP.Size = New-Object System.Drawing.Size(800,20)
$myIP.Text = $address
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
$pingLAN.Location = New-Object System.Drawing.Point(44,30)
$pingLAN.Size = New-Object System.Drawing.Size(250,20)
$pingLAN.Text = 'LAN: '+$statusLAN
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
$pingWAN.Location = New-Object System.Drawing.Point(44,50)
$pingWAN.Size = New-Object System.Drawing.Size(250,20)
$pingWAN.Text = 'Internet: '+$statusWAN
$form.Controls.Add($pingWAN)












$result = $form.ShowDialog()
if ($result -eq [System.Windows.Forms.DialogResult]::OK)
{}