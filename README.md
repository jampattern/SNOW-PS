# SNOW-PS
Powershell Examples and Scripts to interact with ServiceNow REST APIs

## Get-TableAPI.ps1
### Example
```
.\Get-TableAPI.ps1 -InstanceName "development" -Table "change_request" -Fields "number,short_description,state,assigned_to" -Limit 5

number     short_description                                state     assigned_to   
------     -----------------                                -----     -----------   
CHG0000001 Rollback Oracle Version                          New       @{display_v...
CHG0000002 Switch Sales over to the new 555 prefix...       Canceled  @{display_v...
CHG0000003 Roll back Windows SP2 patch                      Closed    @{display_v...
CHG0000004 Upgrade to Oracle 11i                            Review    @{display_v...
CHG0000005 Install new PBX                                  Implement @{display_v...
```

## Attachment API - Examples

```
# POST /now/attachment/file
Invoke-WebRequest -Method Post -Uri [...]/file?table_name=sc_req_item&table_sys_id=a8b6ff891b88c010c1f50d0acd4bcbd1&file_name=test.txt -ContentType multipart/form-data -InFile H:\test.txt -Credential Get-Credential
```
