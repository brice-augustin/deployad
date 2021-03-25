<#
    Déploiement automatisé d'un domaine AD.
    Utilise les tâches planifiées pour lancer sucessivement :
      1) step1-ConfigServerAD.ps1
          Nommage et adressage IP du serveur AD
      2) step2-installAD.ps1
          Installation et configuration du rôle ADDS
      3) step3-addUserAD.ps1
          Création des utilisateurs et OU

    Cédric Peston, 06/2018
#>

﻿# Voir les GPO pour l'installation

Param(
[string] $Path ="C:\adScript",
[string] $nameIf ="Ethernet*",
[string] $addrIp = "198.51.100.3",
[int] $lenSubMask = 24,
[string] $nameServer = "DC-1",
[string] $domainName = "bluesky.org",
# Mot de passe du mode rescue
[string] $adminPasswd = "VitryGTR2021"
)

# Crée un répertoire et copie les scripts a l'intérieur pour les taches planifiés

Import-Module Microsoft.PowerShell.Management

New-Item -Path $Path -ItemType Directory -Force
Copy-Item -Path *AD.ps1 -Destination $Path -Force

powershell $Path\step1-ConfigserverAD.ps1 -Path $Path -nameIf $nameIf -addrIp $addrIp -lenSubMask $lenSubMask -nameServer $nameServer -domainName $domainName -adminPasswd $adminPasswd *> $Path\logConf.txt
