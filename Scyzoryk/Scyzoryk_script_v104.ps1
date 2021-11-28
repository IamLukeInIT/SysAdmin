Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing
Add-Type -AssemblyName PresentationCore,PresentationFramework

$version = 'Scyzoryk ver. 1.0.4'

$form = New-Object System.Windows.Forms.Form
$form.Text = $version
$form.Size = New-Object System.Drawing.Size(300,500)
$form.StartPosition = 'CenterScreen'
$form.BackColor = '#081c15'
$form.ForeColor = '#ffff3f'

$label = New-Object System.Windows.Forms.Label
$label.Location = New-Object System.Drawing.Point(94,25)#left, top
$label.Size = New-Object System.Drawing.Size(280,20)#height, width
$label.Text = 'Zatrzymaj program:'
$form.Controls.Add($label)

$Word = New-Object System.Windows.Forms.Button
$Word.Location = New-Object System.Drawing.Point(85,50)
$Word.Size = New-Object System.Drawing.Size(115,23)
$Word.Text = 'Microsoft Word'
$form.Controls.Add($Word)
$Word.Add_Click({ Turnoff_WORD })
function Turnoff_WORD{
    Stop-Process -Name WINWORD
}

$Excel = New-Object System.Windows.Forms.Button
$Excel.Location = New-Object System.Drawing.Point(85,80)
$Excel.Size = New-Object System.Drawing.Size(115,23)
$Excel.Text = 'Microsoft Excel'
$form.Controls.Add($Excel)
$Excel.Add_Click({ Turnoff_Excel })
function Turnoff_Excel{
    Stop-Process -Name EXCEL
}    

$Syriusz = New-Object System.Windows.Forms.Button
$Syriusz.Location = New-Object System.Drawing.Point(85,110)
$Syriusz.Size = New-Object System.Drawing.Size(115,23)
$Syriusz.Text = 'SyriuszSTD'
$form.Controls.Add($Syriusz)
$Syriusz.Add_Click({ Turnoff_Syriusz })
function Turnoff_Syriusz{
    Stop-Process -Name java
	& C:\Users\*\Desktop\SyriuszSTD.lnk
}  

$Platnik = New-Object System.Windows.Forms.Button
$Platnik.Location = New-Object System.Drawing.Point(85,140)
$Platnik.Size = New-Object System.Drawing.Size(115,23)
$Platnik.Text = 'P³atnik'
$form.Controls.Add($Platnik)
$Platnik.Add_Click({ Turnoff_Platnik })
function Turnoff_Platnik{
    Stop-Process -Name P2
    & C:\"Program Files (x86)\Asseco Poland SA"\Platnik\P2Start.exe
}  

$adm = New-Object System.Windows.Forms.Label
$adm.Location = New-Object System.Drawing.Point(97,195)
$adm.Size = New-Object System.Drawing.Size(280,20)
$adm.Text = '--Administracja--'
$form.Controls.Add($adm)

$Shutdown = New-Object System.Windows.Forms.Button
$Shutdown.Location = New-Object System.Drawing.Point(85,220)
$Shutdown.Size = New-Object System.Drawing.Size(115,23)
$Shutdown.Text = 'Zamknij komputer'
$form.Controls.Add($Shutdown)
$Shutdown.Add_Click({ Turnoff_PC })
function Turnoff_PC{
    Stop-Computer -Force
}  

$Restart = New-Object System.Windows.Forms.Button
$Restart.Location = New-Object System.Drawing.Point(85,250)
$Restart.Size = New-Object System.Drawing.Size(115,23)
$Restart.Text = 'Uruchom ponownie'
$form.Controls.Add($Restart)
$Restart.Add_Click({ Restart_PC })
function Restart_PC{
    Restart-Computer -Force
}  

$Ethernet = New-Object System.Windows.Forms.Button
$Ethernet.Location = New-Object System.Drawing.Point(85,280)
$Ethernet.Size = New-Object System.Drawing.Size(115,23)
$Ethernet.Text = 'Restart sieci'
$form.Controls.Add($Ethernet)
$Ethernet.Add_Click({ Restart_ET })
$card = "Po³¹czenie lokalne"
function Restart_ET{	
netsh interface set interface "$card" Disable 
netsh interface set interface "$card" Enable  
}

#Get logged user
$user = Get-WmiObject Win32_Process -Filter "Name='explorer.exe'" |
ForEach-Object { $_.GetOwner() } |
Select-Object -Unique -Expand User;

$TEMP = New-Object System.Windows.Forms.Button
$TEMP.Location = New-Object System.Drawing.Point(85,310)
$TEMP.Size = New-Object System.Drawing.Size(115,23)
$TEMP.Text = 'Usuñ pliki TEMP'
$form.Controls.Add($TEMP)
$TEMP.Add_Click({ TEMP })
function TEMP{
    Remove-Item -Path ("C:\Windows\Temp\*", "C:\Users\$user\Appdata\Local\Temp\*") -Force -Recurse -ErrorAction "silently"
} 

$Name = New-Object System.Windows.Forms.Button
$Name.Location = New-Object System.Drawing.Point(85,340)
$Name.Size = New-Object System.Drawing.Size(115,23)
$Name.Text = 'Nazwa i adres IP'
$form.Controls.Add($Name)
$Name.Add_Click({ Name })
$showname = $env:computername
# $win7 = "Adres IPv4"
# $win10 = "IPv4 Address"
$showIPwin7 = ipconfig | findstr /R /C:"Adres IPv4"
$showIPwin10 = ipconfig | findstr /R /C:"192.*"
function Name{
    [System.Windows.MessageBox]::Show( "Nazwa komputera: $showname. 
Adres IP: $showIPwin7 $showIPwin10")
}

$chat = New-Object System.Windows.Forms.Button
$chat.Location = New-Object System.Drawing.Point(85,370)
$chat.Size = New-Object System.Drawing.Size(115,23)
$chat.Text = 'ANetChat'
$form.Controls.Add($chat)
$chat.Add_Click({ chat })
function chat{
    Stop-Process -Name ANetChat
    netsh advfirewall firewall add rule name="anetchat" dir=in action=allow
    & D:\ANetChat\ANetChat.exe
}

$cancelButton = New-Object System.Windows.Forms.Button
$cancelButton.Location = New-Object System.Drawing.Point(200,410)
$cancelButton.Size = New-Object System.Drawing.Size(75,23)
$cancelButton.Text = 'WyjdŸ'
$cancelButton.DialogResult = [System.Windows.Forms.DialogResult]::Cancel
$form.CancelButton = $cancelButton
$form.Controls.Add($cancelButton)

$About = New-Object System.Windows.Forms.Button
$About.Location = New-Object System.Drawing.Point(10,410)
$About.Size = New-Object System.Drawing.Size(75,23)
$About.Text = 'O programie'
$form.Controls.Add($About)
$About.Add_Click({ About })
function About{
    [System.Windows.MessageBox]::Show( "Program Scyzoryk powsta³ w celu szybkiego rozwi¹zywania prostych i czêstych problemóww w codziennej pracy.

Wersja 1.0.4: dodano opcjê resetowania nowej wersji SyriuszSTD.
Wersja 1.0.3: dodano opcjê naprawy ANetChat.
Wersja 1.0.2: dodano opcjê aktualizacji programu.
Wersja 1.0.1: dodano opcjê restartowania aplikacji P³atnik, zak³adki Linki oraz Konta.","O porgramie", "OK", "Information")
}

# top banner
$Links = New-Object System.Windows.Forms.Button
$Links.Location = New-Object System.Drawing.Point(0,0)
$Links.Size = New-Object System.Drawing.Size(45,20)
$Links.Text = 'Linki'
$form.Controls.Add($Links)
$Links.Add_Click({ Links })
function Links{
    [System.Windows.MessageBox]::Show( "Przydatne linki:
	
- 192.168.1.13:8080 - SyriuszSTD
- 192.168.1.20:8181 - Intranet
- www.pdf2doc.com - zamiana plikóww pdf na word

# Wpisz je w pasek wyszukiwania w swojej przegl¹darce."
,"Przydatne linki", "OK", "Asterisk") 
}

$PUP = New-Object System.Windows.Forms.Button
$PUP.Location = New-Object System.Drawing.Point(45,0)
$PUP.Size = New-Object System.Drawing.Size(45,20)
$PUP.Text = 'Konta'
$form.Controls.Add($PUP)
$PUP.Add_Click({ PUP })
function PUP{
    [System.Windows.MessageBox]::Show( "Zapisuj swoje dokumenty na dysku D swojego komputera 
w celu zapobiegniêcia ich ca³kowitemu usuniêciu.
	
Login do stacji roboczej: Login zawsze sk³ada siê z Twojego nazwiska i imienia, bez polskich znaków, rozdzielonymi kropk¹.
Przyk³ad: kowalski.jan

Login do SyriuszSTD: Login sk³ada siê z trzech pierwszych liter Twojego imienia i nazwiska oraz czterech losowo wybranych cyfr. Login i has³o nadawane jst przez system Broker i podane na Twojego maila podanego przy tworzeniu konta.
Przyk³ad: jankow1234

Has³a do domeny jak i aplikacji SyriuszSTD musz¹ sk³adaæ siê
z minimum oœmiu znaków, maa³ej i du¿ej litery, cyfry oraz znaku specjalnego. Has³o zmieniane jest co 30 dni i nie mo¿e powtarzaæ siê w przeci¹gu 12 miesiêcy."
,"Informacje o kontach", "OK", "Asterisk") 
}

$akt = New-Object System.Windows.Forms.Button
$akt.Location = New-Object System.Drawing.Point(90,0)
$akt.Size = New-Object System.Drawing.Size(75,20)
$akt.Text = 'Aktualizacja'
$form.Controls.Add($akt)
$akt.Add_Click({ akt })
function akt {
    if (Test-Path -Path \\192.168.1.33\HelpDesk\skrypty\Scyzoryk\version_104.txt){
        [System.Windows.MessageBox]::Show("Posiadasz aktualną wersję programu Scyzoryk.","Wersja", "OK","Information")
    }else{
    Start-Process powershell "\\ryjek\HelpDesk\skrypty\Scyzoryk\Scyzoryk_update.ps1"
    }
}

$credits = New-Object System.Windows.Forms.Label
$credits.Location = New-Object System.Drawing.Point(60,440)
$credits.Size = New-Object System.Drawing.Size(280,20)
$credits.Text = 'Copyright 2021 £ukasz Jedynak'
$form.Controls.Add($credits)

$result = $form.ShowDialog()
if ($result -eq [System.Windows.Forms.DialogResult]::OK)
{}

