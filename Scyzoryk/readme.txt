1. Skopiuj plik installation.ps1 na pulpit komputera. 
2. Uruchom powershell jako administrator. 
	W pasek start wpisz powershell i naciśnij Ctrl+Shift+Enter
3. W powershell zezwól na wykonywanie plików .ps1.
	Set-ExecutionPolicy -ExecutionPolicy RemoteSigned
4. W powershell przejdź do folderu Desktop użytkownika.
	cd 'C:\Users\nazwa_użytkownika\Desktop\'
5. W powershell uruchom skrypt instlacyjny.
	./installation.ps1
6. Kliknij na utworzony na pulpicie plik Scyzoryk.ps1.
7. Jeśli uruchamia się prawidłowo usuń z pulpitu plik installation.ps1.
	Remove-Item -Path "C:\Users\nazwa_użytkownika\Desktop\installation.ps1"