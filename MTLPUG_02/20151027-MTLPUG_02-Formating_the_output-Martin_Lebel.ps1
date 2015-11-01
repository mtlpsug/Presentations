#########################
# La commande de départ #
#########################
Get-WindowsFeature


###################################################################
# Obtenir la liste des membres des objets émis par cette commande #
###################################################################
Get-WindowsFeature | Get-Member -MemberType Property -Name InstallState| Select-Object Definition


################################################
# Obtenir la liste d'une propriétée énumérable #
################################################
[Microsoft.Windows.ServerManager.Commands.InstallState].IsEnum
[System.Enum]::GetNames([Microsoft.Windows.ServerManager.Commands.InstallState])


###########################################################################################################
# Obtenir la liste des roles ou fonctionnalitées déjà installé en filtrant avec la propriété InstallState #
###########################################################################################################
Get-WindowsFeature | Where-Object {$_.InstallState -eq 'Installed'} 
Get-WindowsFeature | Where-Object {$_.InstallState -eq 'Removed'}
Get-WindowsFeature | Where-Object {$_.InstallState -eq 'Available'}
Get-WindowsFeature | where -Property "InstallState" -eq "Installed" <# Ne s'utilise pas avec des accolades #>


########################################################################
# Parce que la propriétée Installed est Boolean, on peut abréger ainsi #
########################################################################
Get-WindowsFeature | Where-Object {$_.Installed}
Get-WindowsFeature | ? {$_.Installed}
Get-WindowsFeature | where  -Property "Installed"
Get-WindowsFeature | ? "Installed"
Get-WindowsFeature | Where-Object {$_.Installed -eq $True} 
#Mais pas possible pour 
Get-WindowsFeature | Where-Object {$_.Removed}
Get-WindowsFeature | Where-Object {$_.Available}


###############################################################
# Oui mais, est ce que c'est un rôle ou une fonctionnalitée ? #
###############################################################
Get-WindowsFeature | Select-Object -Property DisplayName, Name, FeatureType, InstallState
        #####Using Calculated Properties https://technet.microsoft.com/en-us/library/ff730948.aspx
        #####On retourne à notre Get-Member pour obtenir la liste de spropriétées disponibles


##################################################
# C'est laid, on formate. Voici diverses options #
##################################################
Get-WindowsFeature | Select-Object -Property DisplayName, Name, FeatureType, InstallState | Format-Table -AutoSize
Get-WindowsFeature | Select-Object -Property DisplayName, Name, FeatureType, InstallState | Format-Wide <# C'est wierd n'est ce pas. C'est parce que Format-Wide ne supporte qu'une seule propriétée à la fois #>
Get-WindowsFeature | Select-Object -Property Name | Format-Wide -Column 4

    <#Solution to Format-Table truncation issue
    Get-Process -Name powershell | Format-Table -Property Company,Path,Id,Name -AutoSize| Out-String -Width 1024
    Increase/decrease the "1024" value as needed, this will preclude having to hassle with "$FormatEnumerationLimit=-1"
    Kudos to article by "Posholic" at http://poshoholic.com/2010/11/11/powershell-quick-tip-creating-wide-tables-with-powershell/ #>


##################################
# Ajouter un propriétée calculée #  
##################################
CD C:\windows\system32 
Get-ChildItem | Sort-Object -Property Length -Descending | Select-Object -First 10 Name,Length
Get-ChildItem | Sort-Object -Property Length -Descending | Select-Object -First 10 Name,@{Name="Size";Expression={$_.Length / 1GB}}


##################################################
# Obtenir les paramètres du formatage par défaut #
##################################################
$f = Get-WindowsFeature
$t = $f[0].GetType().FullName
Get-FormatData -TypeName $t
$d = Get-FormatData -TypeName $t
$d.FormatViewDefinition[0].Control.Headers
        #####http://windowsitpro.com/powershell/powershell-basics-formatting
        #####http://blogs.technet.com/b/heyscriptingguy/archive/2010/02/08/hey-scripting-guy-february-8-2010.aspx
        #####Get-FormatData Microsoft.Windows.ServerManager.Commands.Feature
        #####Get-FormatData Microsoft.Windows.ServerManager.Commands.Feature | Select -ExpandProperty FormatViewDefinition


######################################################
# Ajout de formatage à l'aide d'une table de hashage #
######################################################
Get-WindowsFeature | Select-Object -Property DisplayName, @{Label="Name";Expression={$_.Name};Width=55;Alignment= "Left"}, FeatureType, InstallState <#Vous donnera assurément une erreur car Width et Align ne sont pas compatible avec Select-Object#>

Get-WindowsFeature | Format-Table -Property `
@{Label="Display Name";Expression={$_.DisplayName};Width=55;Alignment= "Left"},
@{Label="Name";Expression={$_.Name};Width=23;Alignment= "Left"},
@{Label="State";Expression={$_.InstallState};Width=16;Alignment= "Right"},
@{Label="Type";Expression={$_.FeatureType};Width=23;Alignment= "Center"}
#Les clé disponibles sont :  Expression,FormatString,Label/Name,Width and Alignment,Depth
#Elles peuvent toutes être abrégé par la première lettre (E,F,L,N,W,A,D)

    #####https://technet.microsoft.com/en-us/library/hh849892.aspx
    #####https://social.microsoft.com/Forums/Azure/zh-CN/fda204d2-6c15-4fca-bfed-2881127fcb06/error-when-adjust-width-in-custom-table-headers-the-width-key-is-not-valid?forum=Offtopic


#####################################################
# Prédéfinir le formatage dans une table de hashage #
#####################################################
$FormatHash = @{Label="Display Name";Expression={$_.DisplayName};Width=55;Alignment= "Left"},
@{Label="Name";Expression={$_.Name};Width=23;Alignment= "Left"},
@{Label="State";Expression={$_.InstallState};Width=16;Alignment= "Right"},
@{Label="Type";Expression={$_.FeatureType};Width=23;Alignment= "Center"}

Get-WindowsFeature | Format-Table $FormatHash
Get-WindowsFeature | Format-Table $FormatHash, Installed <#Il est possible de rajouter une colonne de derrnière minute même avec cette méthode#>


#Remarquez que nous avons perdu notre indentation ainsi que nos checkmark ( [X] ). Nous allons maintenant utiliser les Calculated Properties pour rétablir
    #####Get-WindowsFeature | Get-Member <# Retourne Microsoft.Windows.ServerManager.Commands.Feature #>
    #####Get-WindowsFeature | Select-Object -Property DisplayName, Name, FeatureType, InstallState | Get-Member
    #####Remarquez que la propriétée DisplayName n'est pas calculé
    #####Trouver le module de cette commande
    #####Get-Command -Name Install-WindowsFeature <# Module is Server Manager #>
    #####C:\Windows\System32\WindowsPowerShell\v1.0\Modules\ServerManager\Feature.format.ps1xml


#######################################
# Ajout de l'expression d'indentation #
#######################################
Get-WindowsFeature | Select-Object `
-Property @{Name="Indentation";Expression={$indent=""
				for ($i=$_.Depth; $i -gt 1; $i--)
				{$indent += "    "}
                $indent += $_.DisplayName}}, Name, FeatureType, InstallState

#################################
# Ajout des [X] dans les boites #
#################################
Get-WindowsFeature | Select-Object `
-Property @{Name="Indentation";Expression={$indent=""
				for ($i=$_.Depth; $i -gt 1; $i--)
				{$indent += "    "}
                if ($_.InstallState -eq "Installed")
                {$indent += "[X] "}
                if ($_.InstallState -eq "Removed")
                {$indent += "[-] "}
                if ($_.InstallState -eq "Available")
                {$indent += "[ ] "} 
                $indent + $_.DisplayName}}, Name, FeatureType | Format-Table -AutoSize


#################################################################
# Création d'un fichier de formatage dans le dossier du profile #
#################################################################
if (!(Test-Path $Profile)) {New-Item -Type File -Force -Path $Profile}
$ProfilePath = Split-Path $Profile
if (Test-Path $Profile) {New-Item -Type File -Name MyCustomViews.format.ps1xml -Path $ProfilePath}


#################################################
# Copier les information à partir d'un template #
#################################################
Get-Content -Path "C:\Windows\System32\WindowsPowerShell\v1.0\Diagnostics.Format.ps1xml" | Add-Content -Path (Joint-Path $ProfilePath "MyCustomViews.format.ps1xml")
notepad.exe "$home\Documents\WindowsPowerShell\MyCustomViews.format.ps1xml"

###############################################
# Editer le fichier de formatage à notre goût #
###############################################
" !!! Ceci ce passe dans le fichier MyCustomViews.format.ps1xml que nous avons créer à l'étape précédante !!!"

############################################
# Mise à jour des information de formatage #
############################################
Update-FormatData -PrependPath "C:\Users\mlebel\Desktop\PowerShell Meetup\MEETUP\2015-10-27\Formating\Types.Custom.ps1xml"

#####################################
# Tester la commande sans formatage #
#####################################
Get-WindowsFeature

##############################################
# Une vue personalisée sur demande seulement #
##############################################
    #Mêmes étapes, définir une vue dans un fichier .format.ps1xml et l'enregistrer avec Update-FormatData. Ensuite il sera possible de l'appeller
Get-WindowsFeature | Format-Custom -View SpecialView
