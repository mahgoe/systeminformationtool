<#
.SYNOPSIS
SYSTEM INFORMATION TOOL (SIT)
.DESCRIPTION
This program show with help from a menu the most important informations
about the local machine. In the first step the program show a main menu
and the user can choose within the main menu the informations he wants to get and
the informations will show up in the console.
After the first step the program show a export menu and the user can choose if he wants to extract the 
informations in a CSV file. All csv-files will be saved in a folder (called "SITEXPORT") in the users local machine in 
the user folder.
With help from -UseCulture the CSV File will be in the Culture of the current machine.
The user can exit the main menu with "q".

Every usage of this program will be logged in a folder called "SITEXPORT". The folder is in the users local machine in
the user folder.
.PARAMETER <ParameterName-1>
-
.PARAMETER <ParameterName-N>
-
.EXAMPLE
-
.EXAMPLE
-
.NOTES
At the current state of this program, the full program is in the language German. A language selection is in planning.
The next step of this program is to track the user for the logfiles.
.LINK
For questions or comments/errors write on this GitHub: 
https://github.com/mahgoe

v1.0
#>


# ARGS einbinden

# Export Html



#Get-ExecutionPolicy
#Set-ExecutionPolicy RemoteSigned -Force

# Funktion Set-Bindestriche


function Set-Bindestriche 
{
    param ([string]$Strich = "-", [INT]$AnzahlStriche = 10)
    $Strich * $AnzahlStriche
}

function Show-MainMenue
{
    param 
    (
        [STRING]$MenuName = 'System Informatics Tool'
    )
    Clear-Host
    Set-Bindestriche -AnzahlStriche 100
    Write-Host $MenuName
    Write-Host "Scripted by mahgoe"
    Set-Bindestriche -AnzahlStriche 100
    Write-Host ""
    Write-Host "Button                          Description"
    Write-Host "-------                         -----------"
    Write-Host "   1                            BIOS Informationen"
    Write-Host "   2                            Betriebssystem Informationen"
    Write-Host "   3                            Harddisk Informationen"
    Write-Host "   4                            Netzwerkkonfiguration"
    Write-Host "   5                            Laufende und Gestoppte Dienste"
    Write-Host "   6                            Installierte Programme"
    Write-Host "   7                            Windows Benutzeraccounts und Gruppen"
    Write-Host "   8                            Ereignissprotokol (System)"
    Write-Host ""
    Write-Host "   h                            Help, Detailierte Beschreibung"
    Write-Host "   q                            Menue beenden"
    Set-Bindestriche -AnzahlStriche 100
    $MenueAuswahl = Read-Host -Prompt "Geben Sie die gewuenschte Auswahl an und bestaetigen Sie mit ENTER"

    switch ($MenueAuswahl) 
    {
        '1' {Get-BIOS}

        '2' {Get-OSInfo}

        '3' {Get-Harddisk}

        '4' {Get-NetworkConfig}

        '5' {Get-Service}

        '6' {Get-Program}

        '7' {Get-UserGroup}

        '8' {Get-LastEventLog}

        'h' {Get-HelpMainMenu}

        'q' {MenueExit}

        Default {Warn-Ungueltig}
    }
}

# Funktion Log Dateien
function Set-LogFile
{
    param
    (
        [STRING]$Text,
        [STRING]$LogDirectoryName = "SITLOGS"
    )
    $Datum = Get-Date -Format "dd.MM.yyyy"

    if(!(Test-Path("$env:USERPROFILE\$LogDirectoryName"))) 
    {
        New-Item -Path $env:USERPROFILE\SITLOGS -ItemType Directory
    }
    else 
    {

    }

    if(!(Test-Path("$env:USERPROFILE\$LogDirectoryName\$Datum.Log.txt"))) 
    {
        New-Item -Path $env:USERPROFILE\$LogDirectoryName\$Datum.Log.txt -ItemType File
        Set-Content -Path $env:USERPROFILE\$LogDirectoryName\$Datum.Log.txt -Value "Diese Datei wurde am $(Get-Date -Format "dddd dd. MMMM yyyy HH:mm:ss") Uhr erstellt."
        Add-Content -Path $env:USERPROFILE\$LogDirectoryName\$Datum.Log.txt -Value "Diese Commandlets wurden in diesem Script mithilfe von einer System Information Tool bedient."
        Add-Content -Path $env:USERPROFILE\$LogDirectoryName\$Datum.Log.txt -Value "`n"
        Add-Content -Path $env:USERPROFILE\$LogDirectoryName\$Datum.Log.txt -Value "`n"
        Add-Content -Path $env:USERPROFILE\$LogDirectoryName\$Datum.Log.txt -Value "Uhrzeit                               Benutztes Cmdlet"
        Add-Content -Path $env:USERPROFILE\$LogDirectoryName\$Datum.Log.txt -Value "-------                               ----------------"
        Add-Content -Path $env:USERPROFILE\$LogDirectoryName\$Datum.Log.txt -Value "`n"
        Add-Content -Path $env:USERPROFILE\$LogDirectoryName\$Datum.Log.txt -Value "[$(Get-Date -Format "HH:mm:ss")]                            $Text"
    }
    else 
    {
        Add-Content -Path $env:USERPROFILE\$LogDirectoryName\$Datum.Log.txt -Value "[$(Get-Date -Format "HH:mm:ss")]                            $Text"
    }
}

# Export CSV Funktion 
function  Export-Ergebnis
{
    param 
    (
        [STRING]$FileName = "default.csv"
    )
    Set-Bindestriche -AnzahlStriche 100
    Write-Host "Exportfunktion                               Beschreibung"
    Write-Host "--------------                               ------------"
    Write-Host "      1                                      Exportiert die Ergebnisse als CSV"
    Write-Host "beliebiger Button                            Zurueck zum Menue"
    Set-Bindestriche -AnzahlStriche 100
    Write-Host "`n"
    $ExportSetting = Read-Host -Prompt "Geben Sie die gewuenschte Exportfunktion an "
    [string]$DirectoryName = "SITEXPORT"
    [String]$ExportPath = "$env:USERPROFILE\"
    $InputExport

    switch ($ExportSetting) 
    {
        '1' 
            {if(!(Test-Path("$ExportPath\$DirectoryName")))
                {
                    New-Item -Path $ExportPath\$DirectoryName -ItemType Directory
                    $InputExport | Export-Csv -Path  $ExportPath\$DirectoryName\$FileName -UseCulture
                } 
                else 
                {
                    $InputExport | Export-Csv -Path  $ExportPath\$DirectoryName\$FileName -UseCulture
                }
            }
        Default {Show-MainMenue}
    }
    Show-MainMenue
}


function MenueExit 
{
    Clear-Host
    exit
}
function Warn-Ungueltig 
{
   Clear-Host
   "Ungueltiger Wert"
   Start-Sleep 3
   Show-MainMenue
}

# Menü BIOS Informationen
function Get-BIOS
{
    Clear-Host
    Set-LogFile -Text "Get-wmiobject win32_bios | Select-Object * ausgefuehrt durch: "
    Get-wmiobject win32_bios | Select-Object *
    $InputExport = Get-wmiobject win32_bios | Select-Object *
    $InputExport | Export-Ergebnis -FileName "BIOSInformation.csv"
}


# Menü Betriebssystem Informationen
function Get-OSInfo
{
    Clear-Host
    Set-LogFile -Text "Get-ComputerInfo ausgefuehrt durch: "
    Get-ComputerInfo
    $InputExport = Get-ComputerInfo
    $InputExport | Export-Ergebnis -FileName "ComputerInformation.csv"
}

# Menü Harddisk Informationen
function Get-Harddisk 
{
    Clear-Host
    Set-LogFile -Text "Get-wmiobject -class win32_logicaldisk | Select-Object * ausgefuehrt durch: "
    Get-wmiobject -class win32_logicaldisk | Select-Object *
    $InputExport = Get-wmiobject -class win32_logicaldisk | Select-Object *
    $InputExport | Export-Ergebnis -FileName "HarddiskInformation.csv"
}

# Netzwerkkonfiguration 
function Get-NetworkConfig
{
    Clear-Host
    Set-LogFile -Text "Get-NetIPAddress ausgefuehrt durch: "
    Get-NetIPAddress
    $InputExport = Get-NetIPAddress
    $InputExport = Export-Ergebnis -FileName "Netzwerkkonfiguration.csv"
}

# Alle laufenden und gestoppten Windows Dienste
function Get-Service
{
    Clear-Host
    Set-LogFile -Text "Get-Service ausgefuehrt durch: "
    Get-Service
    $InputExport = Get-Service
    $InputExport = Export-Ergebnis -FileName "Service.csv"
}

# Installierte Programme
function Get-Program
{
    Clear-Host
    Set-LogFile -Text "Get-ItemProperty HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\* wurde ausgefuehrt durch: "
    Get-ItemProperty HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\*
    $InputExport = Get-ItemProperty HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\*
    $InputExport = Export-Ergebnis -FileName "InstallierteProgramme.csv"
}

# Benutzer und Gruppen auslesen
function Get-UserGroup
{
    Clear-Host
    Set-LogFile -Text "Get-LocalGroup und Get-LocalGroupUser wurde ausgefuehrt durch: "
    Get-LocalUser
    $localUser = Get-LocalUser
    $localUser
    $InputExport = $localUser
    $InputExport | Export-Ergebnis -FileName "Benutzer-Gruppe.csv"
}

# Ereignisprotokoll auslesen
function Get-LastEventLog 
{
 Clear-Host
 Set-LogFile -Text "Get-EventLog -LogName Application -After (Get-Date).AddDays(-2) wurde ausgefuehrt durch: "
 Get-EventLog -LogName Application -After (Get-Date).AddDays(-2)
 $InputExport = Get-EventLog -LogName Application -After (Get-Date).AddDays(-2)
 $InputExport = Export-Ergebnis -FileName "EventLog.csv"
}

# Help Menü
function Get-HelpMainMenu
{
    Clear-Host
    Set-LogFile -Text "Menuehilfe wurde aufgerufen von: "

    Set-Bindestriche -AnzahlStriche 100
    Write-Host $MenuName
    Set-Bindestriche -AnzahlStriche 100
    Write-Host "Hilfemenue"
    Write-Host "v1.0"
    Set-Bindestriche -AnzahlStriche 100
    Write-Host "Allgemeine Informationen:"
    Write-Host "Du kannst mit diesen Buttons eine Funktion aufrufen. Die Funktion wird Ihnen in der Console angezeigt und Sie können die Ergebnisse in eine CSV Datei speichern!"
    Write-Host "Bitte beachten Sie, dass alle CSV und Logdateien im Userordner gespeichert werden."
    Write-Host "Es lohnt sich, die gewünschten Dateien nach der Speicherung umzubennenen!"
    Set-Bindestriche -AnzahlStriche 100
    Write-Host "Button                          Description"
    Write-Host "-------                         -----------"
    Write-Host "   1                            BIOS Informationen"
    Write-Host "   2                            Betriebssystem Informationen"
    Write-Host "   3                            Harddisk Informationen"
    Write-Host "   4                            Netzwerkkonfiguration"
    Write-Host "   5                            Laufende und Gestoppte Dienste"
    Write-Host "   6                            Installierte Programme"
    Write-Host "   7                            Windows Benutzeraccounts und Gruppen"
    Write-Host "   8                            Ereignissprotokol (System)"
    Write-Host ""
    Write-Host "   z                            Zuruck zum Menue"
    Write-Host "   q                            Menue beenden"
    Set-Bindestriche -AnzahlStriche 100
    $MenueAuswahlHelp = Read-Host -Prompt "Geben Sie die gewuenschte Auswahl an und bestaetigen Sie mit ENTER"

    switch ($MenueAuswahlHelp) 
    {
        'q' {MenueExit}
        condition {Show-MainMenue}
        Default {Show-MainMenue}
    }
}

# Main
Show-MainMenue
