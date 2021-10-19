Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing
Add-Type -AssemblyName PresentationCore,PresentationFramework

#frame
$form = New-Object System.Windows.Forms.Form
$form.Text = 'WiFi password'
$form.Size = New-Object System.Drawing.Size(500,170)
$form.StartPosition = 'CenterScreen'

#list wifi
$list = netsh wlan show profiles | Select-Object -Skip 9 | Out-String
$scan = New-Object System.Windows.Forms.Button
$scan.Location = New-Object System.Drawing.Point(50,17)
$scan.Size = New-Object System.Drawing.Size(150,20)
$scan.Text = "Skanuj sieci WiFi"
$form.Controls.Add($scan)
$scan.Add_Click({scan_wifi})
function scan_wifi {
        [System.Windows.MessageBox]::Show("$list")
}

#unencryptor button
$password = New-Object System.Windows.Forms.Button
$password.Location = New-Object System.Drawing.Point(270,17)
$password.Size = New-Object System.Drawing.Size(170,20)
$password.Text = "Pokaż hasło sieci WiFi"
$password.DialogResult = [System.Windows.Forms.DialogResult]::OK
$form.Controls.Add($password)
$password.Add_Click({pass})
function pass {
    #if empty show error message 
    if ([string]::ISNullOrWhiteSpace($tb.Text)){
    [System.Windows.MessageBox]::Show("Wpisz nazwę sieci!")
    }else{
        ($rs -eq [System.Windows.Forms.DialogResult]::OK)
            $y = $tb.Text #input wifi name
                $hack = netsh wlan show profile $y key=clear | Select-Object -Skip 32 -First 1 | Out-String
                #unencryptor wifi password
                [System.Windows.MessageBox]::Show("$hack")
                
    }
}

#input
$name = New-Object System.Windows.Forms.Label
$name.Location = New-Object System.Drawing.Point(110,60)
$name.Size = New-Object System.Drawing.Size(300,20)
$name.Text = "Wpisz początek nazwy sieci WiFi (np. TP*)"
$form.Controls.Add($name)

#input frame
$tb = New-Object System.Windows.Forms.TextBox
$tb.Location = New-Object System.Drawing.Point(150,85)
$tb.Size = New-Object System.Drawing.Size(200)
$form.Controls.Add($tb)
$form.Topmost = $true
$form.Add_Shown({$tb.Select()})
$rs = $form.ShowDialog()

#do not exit after seeing password
$result = $form.ShowDialog()
if ($result -eq [System.Windows.Forms.DialogResult]::Cancel)
{
    $x = $listBox.SelectedItems
    $x
}
