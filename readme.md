# Royal TS Setup

## Description

I hate setting up RoyalTS connection files by hand. I hate setting the credential inheritance flag by hand even more. This does the work consistently for me. Right now the project only handles Windows servers, but I might extend it to Linux/SSH sessions as well over time.

Technically you can accomplish the credential inheritance by editing the Application document -> Default Settings items, but I found that I am bad at remembering to do that.

## Pre-reqs not handled by the script

* pre-install the RSAT AD tools for `get-adcomputer`

## Files

* init.ps1: handles installation of the RoyalTS powershell modules. You don't need to run this directly.
* windows-connections.ps1: Reads servers from your current AD domain, groups by OS. You'll probably want to group them in different ways, add credentials to the connection file, set it to not-shared and encrypt it with a password.  The resulting connection file will be placed in your documents folder, wherever that is. 
* vmware-vms.ps1: processes a csv from https://github.com/aaroneg/PS-VMWare/blob/trunk/get-vmNetworkInfo.ps1
