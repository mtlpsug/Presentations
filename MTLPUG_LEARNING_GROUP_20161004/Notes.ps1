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


# PowerShell Object
#  Property (information)
#  Methode (action)
#  (Example of a car)

# Verb + Noun
Get-Verb


# retrieve all the cmdlets available
Get-Command

# ogv
Get-Command | OGV

# Partial search
Get-Command *Process


# retrieve a specific command


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

# 


# Brackets
{} # ScriptBlock
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

# Performance Pipeline (filter left)
Get-Book -Page 101 | Read-Book

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

# Condition
if(){}
elseif(){}
else{}

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

<#
 Module and their locations
   .psm1 Where the codes goes
   .psd1 Manifest, where you store information on the module, metadata
#>

# PARSING
# Variables, used to store data (while your session is alive)
$Netstat = netstat -n
# Show the output
$Netstat

# WMI
Get-WmiObject -List | ogv
Get-WmiObject win32_operatingsystem 
Get-WmiObject win32_operatingsystem -ComputerName (Get-ADComputer) -Credential (Get-Credential)

# remoting

# 

# HTML
get-process | ConvertTo-Html


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
