# Royal TS Setup

## Description

I hate setting up RoyalTS connection files by hand. I hate setting the credential inheritance flag by hand even more. This does the work consistently for me. Right now the project only handles Windows servers, but I might extend it to Linux/SSH sessions as well over time.

Technically you can accomplish the credential inheritance by editing the Application document -> Default Settings items, but I found that I am bad at remembering to do that.

## Files

* init.ps1: handles installation of the RoyalTS powershell modules. You don't need to run this directly.
* windows-connections.ps1: Reads servers from your current AD domain, groups by OS. You'll probably want to group them in different ways, add credentials to the connection file, set it to not-shared and encrypt it with a password. 

