#Copyright© Philosobear.com, 2015
#1
Set-ExecutionPolicy ByPass

#2
dir c:\Windows | Where-Object { $_.LastWriteTime.AddDays(7) -ge (Get-date)}

#3
function Get-Greeting
{
	return “Hello world”
}

#4
function Get-NewFiles
{
	dir c:\Windows | Where-Object { $_.LastWriteTime.AddDays(7) -ge (Get-date)}
}

#5
function Get-NewFiles
{
param(
    [Parameter(Position=1)][string]$Folder=".",
    [Parameter(Mandatory=$true,Position=0,HelpMessage="How many days ago?")][int]$Day,
    [switch]$Recurse
    )
    Get-ChildItem -LiteralPath $Folder -Recurse:$Recurse | Where-Object { $_.LastWriteTime.AddDays($Day) -gt (Get-date)}
    #"Function ran successfully." | Out-Host
}

#Stop here and create the script version

#7.1 Simple function skeleton
function Verb-Noun
{
	param()
	...
}

#7.2 Advanced function skeleton
function Verb-Noun
{
	param()
	begin{...}
	process{...}
	end{...}
}

#8. Advanced example
#Get-Service | Where-Object {$_.Status -like "Stopped" -and $_.Name -match "^w"}
#Get-Service | Select-Service -Name ^w -Status Stopped
function Select-Service
{
    param(
        [String]$Name,
        [String]$Status
    )
    process {
        $filter=$false
        if($Status -and $_.Status -notlike $Status) {
            $filter=$true
        }
        if ($_.Name -notmatch $Name) {
            $filter=$true
        }
        if (-not $filter) {
            $_
        }
    }
}

#9. CmdletBinding and Parametersets
function Select-Service
{
[CmdletBinding(DefaultParameterSetName="MyNameSet")]
    param(
        [ValidateSet('Running', 'Stopped','Stopping','Starting','Disabled')]
            [String]$Status,
        [Parameter(ValueFromPipeline=$True)]
            $InputObject,
        [Parameter(ParameterSetName='MyNameSet',Position=0)]
            [String]$Name,
        [Parameter(ParameterSetName='DisplayName')]
            [String]$DisplayName
        )
    process {
        $filter=$false
        if($Status -and $InputObject.Status -notlike $Status) {
            $filter=$true
        }
        if ($PSCmdlet.ParameterSetName -like "MyNameSet") {
            if ($InputObject.Name -notmatch $Name) {
                $filter=$true
            }
        }
        else {
            if ($InputObject.DisplayName -notmatch $DisplayName) {
                $filter=$true
            }
        }
        if (-not $filter) {
            $InputObject
        }
    }
}

