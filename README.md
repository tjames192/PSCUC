# PSCUC
PowerShell Module as a wrapper for the REST API in Cisco Unity Connection
# Instructions
### Install the module
```powershell
# manual setup
    # Download the repository
    # Unblock the zip
    # Extract the  folder to a module path (e.g. $env:USERPROFILE\Documents\WindowsPowerShell\Modules\)

# Import the module
    Import-Module PSCUC # Alternatively, Import-Module \\Path\To\PSCUC

# Get commands in the module
    Get-Command -Module PSCUC

# Get help
```
# Examples
### Connecting to Cisco Unity Connection

The first thing to do is connect to a Cisco Unity cluster with the command `Connect-CUC`:

```powershell
# Connect to Cisco Unity
Connect-CUC server -Credentials
Name                           Value
----                           -----
IsConnected                    True
Server                         server
Headers                        {Accept, Authorization}
```
### User Management

You can get a user `Get-CUCUser`

```powershell
# Retrieve information about a specific user
Get-CUCUser demo@domain.com

@total User
------ ----

1      @{URI=/vmrest/users/dd528a43-22f1-46fe-8b2a-5d1dcfe89cdb; ObjectId=dd528a43-22f1-46fe-8b2a-5d1dcfe89cdb; FirstName=Demo; LastName=Demo; Alias=demo@domain.com; City=; DisplayName=Demo Demo; TimeZone=4; Creati...
```
You can create a new `New-CUCUser`

```powershell
$newuser = [pscustomobject][ordered]@{
alias = 'demo@domain.com'
firstName = 'Demo'
lastName = 'Demo'
displayName = 'Demo Demo'
extension = '1111'
emailaddress = 'demo@domain.com'
}

$newuser | New-CUCUser
# /vmrest/users/dd528a43-22f1-46fe-8b2a-5d1dcfe89cdb
```
