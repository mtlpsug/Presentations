# MTLPUG Learning Group
#  Link: http://www.meetup.com/MontrealPowerShellUserGroup/events/230649907/

<#
    Learning PowerShell
        Made for automation
        Language pattern, easy to repeat
        Cmdlets 
        Abstraction of complexity (.net, ...)
        

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


# PowerShell Object
#   (Example of a car)
#  Property (information) color, size, weight, door, wheel, seats, bumper, ...
#  Methode (action) open door, accelerate, brake, turn left, turn right, ...

# Verb + Noun
#  <VERB> - <NOUN>
Get-Verb

# Singular Noun
(Get-Command).Noun

# Retrieve all the cmdlets available
Get-Command

# Neat view to see all the command using Out-GridView
Get-Command | Out-Gridview

# Partial search
Get-Command *Process


# retrieve a specific command
Get-Command Get-Process

# retrieve a specific command syntax
Get-Command Get-Process -Syntax


# retrieve all the cmdlets for a specific module
Get-Command -Module Microsoft.PowerShell.Management


# Get the help for a command
Get-Help Get-Service

# Get the help for a command
Get-Help Get-Service -Examples

# Get the help from the online website
Get-Help Get-Service -Online

# Get the help in a separated window
Get-Help Get-Service -ShowWindow


# Parameters
# some kind of filtering



# Default 'view'
Get-Process # The author of this command defined a view by default
# To see all the other properties of each process
Get-Process | Select-Object -Property *
Get-Process | Select *


# Brackets
{} # {Statement Block}
() # 
[]
''
""
@"
"@


# Variables
$Process = Get-process
$process.name
$process.refresh()
Get-Process -OutVariable a


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

# Pipeline
Get-Process -OutVariable a | Where-Object {$_.name -like 'p*'} -OutVariable b | sort -OutVariable c

Get-Service | Where-Object {$_.StartType -eq 'Automatic' -and $_.status -eq 'Stopped'} | Start-Service -WhatIf

# Performance Pipeline (filter left)
Get-Book -Name "PowerShell for Beginner" | Read-Book -Page "101"

# find services that should be started ($_ is the current object in the pipeline)
Get-Service | Where-Object { $_.StartType -eq 'Automatic' -and $_.Status -eq 'Stopped'}

Get-Service -ComputerName 'SERVER01','SERVER02' |
    Where-Object { $_.StartType -eq 'Automatic' -and $_.Status -eq 'Stopped'}

Get-Service -ComputerName (Get-Content c:\Computerlist.txt) |
    Where-Object { $_.StartType -eq 'Automatic' -and $_.Status -eq 'Stopped'}

# Retrieving Alias
Get-Alias

# Unix/Linux guys friendly
ls
man

New-alias 

# Discover commands
*-Service #press tab, tab, tab to see the cmdlet available finishing by '-service'

# operators
-eq
-lt
-le
-gt
-ge
-match
$matches
-like
-notlike


# Algorithm
# Condition
if($MyServiceStatus -eq 'Stopped'){
    "The Service is Stopped"  
}
elseif($MyServiceStatus -eq 'Started'){
    "The Service is Started"
}
else{
    "The Service is in an unknown state ($MyServiceStatus)"  
}



# Looping
while(){}
do{}while()
get-process | foreach {}
foreach ($i in $process){}




# PROFILE
#  when you launch powershell, it can run a default profile
#  you can set up your shell, load module, etc...

# Finding my profile (PowerShell ISE and PowerShell have their own profile)
$Profile

##########
# MODULE #
##########
# Powershell is extensible by using modules

# Retrieve the list of module already loaded
Get-Module 

# Retrieve list of module not loaded
Get-Module -ListAvailable

<#
 Module and their locations
   .psm1 Where the codes goes
   .psd1 Manifest, where you store information on the module, metadata
#>

###########
# PARSING #
###########

# Variables, used to store data (while your session is alive)
$Netstat = netstat -n
# Show the output
$Netstat




#######
# WMI #
#######
Get-WmiObject -List | ogv
Get-WmiObject -class win32_operatingsystem 
Get-WmiObject -class win32_operatingsystem -ComputerName (Get-ADComputer) -Credential (Get-Credential)

############
# remoting #
############
Enter-PSSession -ComputerName REMOTEMACHINE01

Get-Process | ForEach-Object {}

# HTML
get-process | ConvertTo-Html # Generate a full page
get-process | ConvertTo-Html | Set-COntent file.html
get-process | ConvertTo-Html -Fragment # Generate just a table

# regex


#legacy command
#reporting
#parsing
# how to implement whatif

# MODULE
# Generating a new manifest
New-ModuleManifest -Path c:\scripts\MTLPUG.psd1 -RootModule 'MTLPUG.psm1'

# Examples of projects
#  Inventory of Computer or multiple computers (CSV or HTML or both)
#  Report on sessions open on a machine
#  Report on AD Group membership changes
#  Report on AD Groups that are empty
#  Create a Graphical Interface that retrieve the process
#  

# Funny scripts
# Lee Holmes - Never Let You Down
#  iex (New-Object Net.WebClient).DownloadString("http://bit.ly/e0Mw9w")