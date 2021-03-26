<#
    Script d'installation d'un serveur Active Directory
    Partie 3 : Ajout des données dans le serveur Active Directory
    Cédric Peston, 06/2018

#>

Import-Module ScheduledTasks

If (Get-ScheduledTask AddUserAD){
    Unregister-ScheduledTask -TaskName AddUserAD -Confirm:$false
}


# Attend que le service Active Directory soir lancé pour continuer

Import-Module Microsoft.PowerShell.Utility

# Crée les utilisateurs ainsi que les unité d'organisation de Active Directory

Import-Module ActiveDirectory

Do{
    Sleep 1
    Get-ADDomain
}Until($?)

$server = (Get-ADDomain).InfrastructureMaster
$path = (Get-ADDomain).DistinguishedName
$passwd = "VitryGTR94"
New-ADOrganizationalUnit -Name:"Utilisateurs" -Path:$Path -Server:$server -ProtectedFromAccidentalDeletion:$false
New-ADOrganizationalUnit -Name:"Ordinateurs" -Path:$Path -Server:$server -ProtectedFromAccidentalDeletion:$false

$Path = (Get-ADOrganizationalUnit -Filter 'Name -like "Utilisateurs"').DistinguishedName

New-ADOrganizationalUnit -Name:"R&D" -Path:$Path -Server:$server -ProtectedFromAccidentalDeletion:$false
New-ADOrganizationalUnit -Name:"Finance" -Path:$Path -Server:$server -ProtectedFromAccidentalDeletion:$false
New-ADOrganizationalUnit -Name:"Admins" -Path:$Path -Server:$server -ProtectedFromAccidentalDeletion:$false

$Path = (Get-ADOrganizationalUnit -Filter 'Name -like "Ordinateurs"').DistinguishedName

New-ADOrganizationalUnit -Name:"Bureau" -Path:$Path -Server:$server -ProtectedFromAccidentalDeletion:$false
New-ADOrganizationalUnit -Name:"Openspace" -Path:$Path -Server:$server -ProtectedFromAccidentalDeletion:$false

$Path = (Get-ADOrganizationalUnit -Filter 'Name -like "R&D"').DistinguishedName

New-ADUser -Name:"Pinkman" -Path:$Path -SamAccountName:"pinkman" -Type:"user" -Server:$server -AccountPassword (convertto-securestring $passwd -asplaintext -force) -Enabled:$true
New-ADUser -Name:"White" -Path:$Path -SamAccountName:"white" -Type:"user" -Server:$server -AccountPassword (convertto-securestring $passwd -asplaintext -force) -Enabled:$true

$Path = (Get-ADOrganizationalUnit -Filter 'Name -like "Finance"').DistinguishedName

New-ADUser -Name:"Mike" -Path:$Path -SamAccountName:"mike" -Type:"user" -Server:$server -AccountPassword (convertto-securestring $passwd -asplaintext -force) -Enabled:$true
New-ADUser -Name:"Saul" -Path:$Path -SamAccountName:"saul" -Type:"user" -Server:$server -AccountPassword (convertto-securestring $passwd -asplaintext -force) -Enabled:$true

$Path = (Get-ADOrganizationalUnit -Filter 'Name -like "Admins"').DistinguishedName

New-ADUser -Name:"Gus" -Path:$Path -SamAccountName:"gus" -Type:"user" -Server:$server -AccountPassword (convertto-securestring $passwd -asplaintext -force) -Enabled:$true
New-ADUser -Name:"Salamanca" -Path:$Path -SamAccountName:"salamanca" -Type:"user" -Server:$server -AccountPassword (convertto-securestring $passwd -asplaintext -force) -Enabled:$true
