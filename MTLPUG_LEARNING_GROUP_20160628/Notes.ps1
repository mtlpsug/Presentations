# MTLPUG Learning Group 2016/06/28
#  Link: http://www.meetup.com/MontrealPowerShellUserGroup/events/230649907/

<#

 PowerShell ISE and PowerShell ?
  >ISE
    Built-in Editor
    Snapin (Ctrl + j)
    Intellisense (help you see the cmdlets, parameters, etc.. when you type)
  >Powershell
    Ctrl + Space can show some 'Intellisense' type of menu
#>

<# 
    3 important command to get started
#>
Get-Command # retrieve commands
Get-Help # retrieve help
Get-Member # retrieve properties and methods of cmdlets


# retrieve all the cmdlets available
Get-Command

# retrieve a specific command
Get-Command Get-Process

# retrieve a specific command syntax
Get-Command Get-Process -Syntax


# retrieve all the cmdlets for a specific module
Get-Command -Module Microsoft.PowerShell.Management


# Get the help for a command
Get-Help Get-Service

# Get the help from the online website
Get-Help Get-Service -Online

# Get the help in a separated window
Get-Help Get-Service -ShowWindow

<# Help #>
# Updating your help (PowerShell launch as Admin)
Update-Help
# You could launch a parallel job to update in the backgroup
Start-Job -ScriptBlock {Update-Help}


# Retrieve the services
Get-Service

# The previous command only show the default view,
#  to see other properties and methods available, do the following
Get-Service | Get-Member

# Select properties
Get-Service | Select-Object Name, Status, StartType

# find services that should be started ($_ is the current object in the pipeline)
Get-Service | Where-Object { $_.StartType -eq 'Automatic' -and $_.Status -eq 'Stopped'}

# Retrieving Alias
Get-Alias

# Discover commands
*-Service #press tab, tab, tab to see the cmdlet available finishing by '-service'

# Concept of PowerShell Object versus the legacy command

# PROFILE
#  when you launch powershell, it can run a default profile
#  you can set up your shell, load module, etc...

# Finding my profile (PowerShell ISE and PowerShell have their own profile)
$Profile

<#
 Module and their locations
   .psm1 Where the codes goes
   .psd1 Manifest, where you store information on the module, metadata
#>

# See module MTLPUG
# Generating a new manifest
New-ModuleManifest -Path c:\scripts\MTLPUG.psd1 -RootModule 'MTLPUG.psm1'

# Variables, used to store data (while your session is alive)
$Netstat = netstat -n
# Show the output
$Netstat