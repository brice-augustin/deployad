<#
    Script d'installation d'un serveur Active Directory
    Partie 1 : Configuration du serveur Active Directory
    Cédric Peston, 06/2018

    @Param
        Path        : Chemin absolue du répertoire des scripts
        nameIf      : Nom de l'interface réserau
        addrIp      : Addresse IP du serveur
        lenSubMask  : Longeur du masque de sous-réseau
        nameServer  : Nom du Serveur Active Directory
        domainName  : Nom du domaine
        adminPasswd : Mot de passe de la session Administrateur en mode sans échec
#>

Param(
[string] $Path ="C:\adScript",
[string] $nameIf ="Ethernet*",
[string] $addrIp = "198.51.100.3",
[int] $lenSubMask = 24,
[string] $nameServer = "DC-1",
[string] $domainName = "bluesky.org",
[string] $adminPasswd = "VitryGTR94"
)

# Configure une interface en adressage statique


Import-Module NetAdapter

$ifIndex = (Get-NetAdapter -Name $nameIf).ifIndex # Récupère l'index de la interface reseau a configurer en statique

Import-Module NetTCPIP

Set-NetIPInterface -InterfaceIndex $ifIndex -Dhcp Disabled -PolicyStore PersistentStore # Déactive l'auto confuguration sur l'interface réseau
Remove-NetIPAddress -InterfaceIndex $ifIndex -Confirm:$false                            # Supprime toute les adresses de l'interfaces
New-NetIPAddress –InterfaceIndex $ifIndex –IPAddress $addrIp –PrefixLength $lenSubMask  # Configure l'interface avec l'adresse IP donnée

# Execute le script d'intallation si le nom de la machine n'est pas à modifier

If ((Hostname) -eq $nameServer){

        powershell $Path\step2-installAD.ps1 -Path $Path -domainName $domainName -adminPasswd $adminPasswd *> $Path\logInstallAD.txt # Exercute
    }

else{

    # Crée une tache planifié pour executer le script d'intallation du serveur au redemarrage de la machine si le nom à été modifié

    Import-Module ScheduledTasks

    $Act = New-ScheduledTaskAction -Execute "powershell.exe" -Argument "-ExecutionPolicy Bypass $Path\step2-installAD.ps1 `"-Path $Path -domainName $domainName -adminPasswd $adminPasswd`" *> $Path\logInstallAD.txt"
    $Trig = New-ScheduledTaskTrigger -AtStartup
    $Set = New-ScheduledTaskSettingsSet -AllowStartIfOnBatteries -DontStopIfGoingOnBatteries

    Register-ScheduledTask -TaskName InstallAD -Action $Act -Trigger $Trig -Settings $Set -User "System" -RunLevel Highest

    Rename-Computer -NewName $nameServer

    Restart-Computer -Force
}
