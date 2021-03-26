<#
    Script d'installation d'un serveur Active Directory
    Partie 2 : Installation du service Active Directory
    Cédric Peston, 06/2018


    @Param
        Path        : Chemin absolue du répertoire des scripts
        domainName  : Nom du domaine
        adminPasswd : Mot de passe de la session Administrateur en mode sans échec
#>

Param(
[string] $Path ="C:\adScript",
[string] $domainName = "bluesky.org",
[string] $adminPasswd = "VitryGTR94"
)

# Supprime la tache planifier

Import-Module ScheduledTasks

If (Get-ScheduledTask InstallAD){
    Unregister-ScheduledTask -TaskName InstallAD -Confirm:$false
}

# Installe le module Active Directory ainsi que la première forêt

Import-Module ServerManager

Install-windowsfeature -name AD-Domain-Services -IncludeManagementTools -Confirm:$false
Install-ADDSForest -DomainName $domainName -SafeModeAdministratorPassword (convertto-securestring $adminPasswd -asplaintext -force) -NoRebootOnCompletion -Confirm:$false

# Crée une tache planifiée pour executer le script d'ajout des utilisateurs au serveur au redemarrage

$Act = New-ScheduledTaskAction -Execute "powershell.exe" -Argument "-ExecutionPolicy Bypass $Path\step3-addUserAD.ps1 -Path $Path *> $Path\logAddUserAD.txt"
$Trig = New-ScheduledTaskTrigger -AtStartup
$Set = New-ScheduledTaskSettingsSet -AllowStartIfOnBatteries -DontStopIfGoingOnBatteries

Register-ScheduledTask -TaskName AddUserAD -Action $Act -Trigger $Trig -Settings $Set -User "System" -RunLevel Highest

# Redemarre la machine

Import-Module Microsoft.PowerShell.Management

Restart-Computer -Force
