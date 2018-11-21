# Windows 10 Optimization Script BlackDragonBE Version

This script is a modified version of https://github.com/Disassembler0/Win10-Initial-Setup-Script

I take no credit for his work, I have merely edited it and added my own tweaks and modifications. If you run this script and something breaks, there's nothing I can do about it.

## Contents
 - [Description](#description)
 - [Usage](#usage)
 - [Windows builds overview](#windows-builds-overview)
 - [Advanced usage](#advanced-usage)

## Description

This is a PowerShell script for automation of routine tasks done after fresh installations of Windows 10 and Windows Server 2016 / 2019 / GPD Win 1 & 2. This is by no means any complete set of all existing Windows tweaks and neither is it another "antispying" type of script. It's simply a setting which I like to use and which in my opinion make the system less obtrusive.

## Usage
If you just want to run the script with the default preset, download and unpack the [latest release](https://github.com/Disassembler0/Win10-Initial-Setup-Script/releases) and then simply double-click on the *Default.cmd* file and confirm *User Account Control* prompt. Make sure your account is a member of *Administrators* group as the script attempts to run with elevated privileges.

The script supports command line options and parameters which can help you customize the tweak selection or even add your own custom tweaks, however these features require some basic knowledge of command line usage and PowerShell scripting. Refer to [Advanced usage](#advanced-usage) section for more details.

## Windows builds overview

| Version |        Code name        |     Marketing name     | Build |
| :-----: | ----------------------- | ---------------------- | :---: |
|  1507   | Threshold 1 (TH1 / RTM) | N/A                    | 10240 |
|  1511   | Threshold 2 (TH2)       | November Update        | 10586 |
|  1607   | Redstone 1 (RS1)        | Anniversary Update     | 14393 |
|  1703   | Redstone 2 (RS2)        | Creators Update        | 15063 |
|  1709   | Redstone 3 (RS3)        | Fall Creators Update   | 16299 |
|  1803   | Redstone 4 (RS4)        | April 2018 Update      | 17134 |
|  1809   | Redstone 5 (RS5)        | October 2018 Update    | 17763 |


## Advanced usage

    powershell.exe -NoProfile -ExecutionPolicy Bypass -File Win10.ps1 [-include filename] [-preset filename] [[!]tweakname]

    -include filename       load module with user-defined tweaks
    -preset filename        load preset with tweak names to apply
    tweakname               apply tweak with this particular name
    !tweakname              remove tweak with this particular name from selection

### Presets

The tweak library consists of separate idempotent functions, containing one tweak each. The functions can be grouped to *presets*. Preset is simply a list of function names which should be called. Any function which is not present or is commented in a preset will not be called, thus the corresponding tweak will not be applied. In order for the script to do something, you need to supply at least one tweak library via `-include` and at least one tweak name, either via `-preset` or directly as command line argument.

The tweak names can be prefixed with exclamation mark (`!`) which will instead cause the tweak to be removed from selection. This is useful in cases when you want to apply the whole preset, but omit a few specific tweaks in the current run. Alternatively, you can have a preset which "patches" another preset by adding and removing a small amount of tweaks.

To supply a customized preset, you can either pass the function names directly as arguments.

    powershell.exe -NoProfile -ExecutionPolicy Bypass -File Win10.ps1 -include Win10.psm1 EnableFirewall EnableDefender

Or you can create a file where you write the function names (one function name per line, no commas or quotes, whitespaces allowed, comments starting with `#`) and then pass the filename using `-preset` parameter.  
Example of a preset file `mypreset.txt`:

    # Security tweaks
    EnableFirewall
    EnableDefender

    # UI tweaks
    ShowKnownExtensions
    ShowHiddenFiles   # Only hidden, not system

Command using the preset file above:

    powershell.exe -NoProfile -ExecutionPolicy Bypass -File Win10.ps1 -include Win10.psm1 -preset mypreset.txt
