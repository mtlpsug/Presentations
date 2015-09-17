<# WHAT IS POWERSHELL ? #>
# Command Shell
PowerShell.exe

# Integrated Scripting Environment (ISE)
Powershell_ise.exe

# Verify the version of PowerShell
$PSVersiontable

Get-Service



# Properties and Methods
Get-Service | Get-Member
#TypeName: System.ServiceProcess.ServiceController

Get-Service | Get-Member -MemberType Properties
Get-Service | Get-Member -MemberType methods




<# IMPORTANT TERMINOLOGY ? #>

# CmdLets ('Command-Lets')
<Verb>-<SingularNoun>

Get-Verb #  List of standard verbs allowed

Get-Command -Noun process # List of Noun in used
Get-Command -Verb update


# Pipeline
#  Pipeline - Ease to read
Get-Service | Where-Object {$_.Status -eq 'Running'} |
    Select-Object -first 10 -Property Name

#  Pipeline - Tool
Get-Content C:\LazyWinAdmin\ComputersList.txt |
    ForEach-Object { Test-Connection -Count 1 -Quiet -ComputerName $_}

Get-content C:\LazyWinAdmin\ComputersList.txt | clip



<# THE 3 IMPORTANT CMDLETS #>

# GET-COMMAND
Get-Command
Get-command *service
Get-Command *ess*
Get-Command -Verb Invoke
Get-Command -Module ActiveDirectory
Get-Command -Module remotedesktop -Verb get

#discoverable (see Intellisense in ISE/PSreadLine module in PowerShell too)
*Service
*et*Service
service # powershell assume it is a 'Get' by default

# Using PSReadLine

# GET-HELP
Get-Help Get-Process
Get-Help Get-Process -Parameter name
Get-Help Get-Process -Examples
Get-Help Get-Process -Full
Get-Help Get-Process -ShowWindow
Get-Help Get-Process -Online

# About_ HelpFiles
Get-Help about*
Get-Help about_Updatable_Help
Get-Help about_Updatable_Help

# Updating help
Update-Help -Verbose

## Get-Member
# Default view don't show you all the properties availabled
Get-Service
Get-Service | Get-Member
Get-Service | Select-Object -Property S*





<# OTHER COOL EXAMPLE #>
# Alias
Get-Alias # ls dir cd cls md

# Small GUI
Show-Command Get-Service
Get-Process | Out-GridView
get-service | Out-GridView -OutputMode Single | stop-service -WhatIf

# Manipulation in the console
1+1

900/5

1..10

-2..5

40960/1KB

40960/1MB

22525582454812800/1GB

2048GB/1PB

"James:TestUser" -split ":"

"James"+"TestUser"


# PROCESSES
Get-Process -IncludeUserName

# REGISTRY
cd HKLM:\SOFTWARE
dir HKLM:\SOFTWARE\Microsoft

# EVENT LOGS
Get-EventLog -LogName System -Newest 5 -ComputerName .,$env:ComputerName -EntryType Error

# NTFS Folder Permissions
Get-ACL C:\LazyWinAdmin
Get-ChildItem C:\LazyWinAdmin -recurse | Get-Acl

# FILES MANIPULATION
Get-Content -Path C:\Windows\WindowsUpdate.log
Get-Content -Tail 100 -Path C:\Windows\WindowsUpdate.log | Select-string -Pattern "Warning" -Context 5

# CSV
Import-CSV -Path C:\Windows\WindowsUpdate.log -Delimiter "`t" | Out-GridView

# HTML
Get-Process | ConvertTo-Html 
Get-Process | ConvertTo-Html -Title "My Page" -Head "My Super Report" -PostContent "<i>Generated from $env:ComputerName<i>" > C:\lazywinadmin\process.htm

ii C:\lazywinadmin\process.htm


# PS REMOTING
#open session to a server
Enter-PSSession -ComputerName .

#define a session
$FX = New-PSSession -ComputerName .

#invoke a command within the session
Invoke-Command -Session $FX -ScriptBlock {Get-Process}

#open a session to a server using the session created
Enter-PSSession -Session $FX


# COM Object
#  Make PowerShell speaks
$s = New-Object -ComObject SAPI.SPVoice
$s.Rate = -5
$s.Speak("Montreal PowerShell User Group")


# WMI Inventory
#Report the USB Devices installed
Get-WmiObject -Class Win32_USBControllerDevice -computername . |Format-List Antecedent,Dependent

#XML
$HotFix = Get-HotFix
$HotFix | Export-Clixml C:\LazyWinAdmin\MTLPUG-HotFix.xml -Force
Import-Clixml C:\LazyWinAdmin\MTLPUG-HotFix.xml

#Get the list of class available
Get-WmiObject -list | ogv

#Report the computersystem class
Get-WmiObject -Class Win32_ComputerSystem -ComputerName .

#Report the USB Devices installed
Get-WmiObject -Class Win32_USBControllerDevice -computername . |Format-List Antecedent,Dependent