##########
# Win 10 / Server 2016 / Server 2019 / GPD Win Initial Setup Script - Main loop
# Author: BlackDragonBE
# Based on script by: Disassembler <disassembler@dasm.cz>
# Version: v2.5 2018-11-21
# Based on: v3.3
# Source: https://github.com/BlackDragonBE/Win10-Initial-Setup-Script
##########

# Relaunch the script with administrator privileges
Function RequireAdmin {
	If (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]"Administrator")) {
		Start-Process powershell.exe "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`" $PSCommandArgs" -Verb RunAs
		Exit
	}
}

$tweaks = @()
$PSCommandArgs = @()

Function AddOrRemoveTweak($tweak) {
	If ($tweak[0] -eq "!") {
		# If the name starts with exclamation mark (!), exclude the tweak from selection
		$global:tweaks = $global:tweaks | Where-Object { $_ -ne $tweak.Substring(1) }
	} ElseIf ($tweak -ne "") {
		# Otherwise add the tweak
		$global:tweaks += $tweak
	}
}

# Parse and resolve paths in passed arguments
$i = 0
While ($i -lt $args.Length) {
	If ($args[$i].ToLower() -eq "-include") {
		# Resolve full path to the included file
		$include = Resolve-Path $args[++$i]
		$PSCommandArgs += "-include `"$include`""
		# Import the included file as a module
		Import-Module -Name $include
	} ElseIf ($args[$i].ToLower() -eq "-preset") {
		# Resolve full path to the preset file
		$preset = Resolve-Path $args[++$i]
		$PSCommandArgs += "-preset `"$preset`""
		# Load tweak names from the preset file
		Get-Content $preset -ErrorAction Stop | ForEach-Object { AddOrRemoveTweak($_.Split("#")[0].Trim()) }
	} Else {
		$PSCommandArgs += $args[$i]
		# Load tweak names from command line
		AddOrRemoveTweak($args[$i])
	}
	$i++
}

# Confirmation
Write-Host
Write-Host
Write-Host "WIN 10 Optimization Script For Windows 10 by BlackDragonBE"
Write-Host "(Adapted version of https://github.com/Disassembler0/Win10-Initial-Setup-Script by Disassembler <disassembler@dasm.cz>)"
Write-Host "--------------------------------------------"
Write-Host "Make sure you've checked which tweaks are turned on before running this. Edit by placing # before anything you don't want to run."
Write-Host
$confirmation = Read-Host "If you're sure you want to run this, press y and ENTER. If not, just press ENTER to exit."

if ($confirmation -ne 'y') {
    Write-Host
    Write-Host "Cancelled script execution."
    exit
}


# Call the desired tweak functions
$tweaks | ForEach-Object { Invoke-Expression $_ }
