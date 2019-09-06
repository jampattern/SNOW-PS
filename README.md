# SNOW-PS
Powershell Examples and Scripts to interact with ServiceNow REST APIs

## Get-TableAPI.ps1
### Example
```
.\Get-TableAPI.ps1 -InstanceName "development" -Table "change_request" -Fields "number,short_description,state,assigned_to" -Limit 5

cmdlet Get-Credential at command pipeline position 1
Supply values for the following parameters:
User: admin
Password for user admin: *************

number     short_description                                state     assigned_to   
------     -----------------                                -----     -----------   
CHG0000001 Rollback Oracle Version                          New       @{display_v...
CHG0000002 Switch Sales over to the new 555 prefix...       Canceled  @{display_v...
CHG0000003 Roll back Windows SP2 patch                      Closed    @{display_v...
CHG0000004 Upgrade to Oracle 11i                            Review    @{display_v...
CHG0000005 Install new PBX                                  Implement @{display_v...
```