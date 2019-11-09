# SNOW-PS
Powershell Examples and Scripts to interact with ServiceNow REST APIs

## Get-TableAPI.ps1
Issue a GET request to the Table API

Parameters:
* InstanceName
* Table
* Query (sysparm_query)
* Fields (sysparm_fields)
* Limit (sysparm_limit)
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
### POST api/now/attachment/file
```
Invoke-WebRequest -Method Post -Uri [...]/file?table_name=sc_req_item&table_sys_id=a8b6ff891b88c010c1f50d0acd4bcbd1&file_name=test.txt -ContentType multipart/form-data -InFile c:\test.txt -Credential Get-Credential
```

### GET api/now/attachment/{sys_id}
```
Invoke-WebRequest -Method Get -Uri "[...]/api/now/attachment/56754d12373000105aa7dcc773990ee0" -Credential Get-Credential

{
  "result": {
    "size_bytes": "89",
    "file_name": "type.txt",
    "sys_mod_count": "0",
    "average_image_color": "",
    "image_width": "",
    "sys_updated_on": "2019-10-31 22:35:20",
    "sys_tags": "",
    "table_name": "incident",
    "sys_id": "56754d12373000105aa7dcc773990ee0",
    "image_height": "",
    "sys_updated_by": "admin",
    "download_link": "[...]/attachment/56754d12373000105aa7dcc773990ee0/file",
    "content_type": "multipart/form-data",
    "sys_created_on": "2019-10-31 22:35:20",
    "size_compressed": "96",
    "compressed": "true",
    "state": "",
    "table_sys_id": "a623cdb073a023002728660c4cf6a768",
    "chunk_size_bytes": "734003",
    "sys_created_by": "admin"
  }
}
```

### GET api/now/attachment/{sys_id}/file

```
$Uri = "[...]]/api/now/attachment/1f543364bf1101007a6d257b3f0739d3"
$Meta = Invoke-WebRequest -Uri $Uri -Method Get -Credential $Cred
$Meta = $Meta.Content | ConvertFrom-Json | Select-Object -ExpandProperty result

$File = Invoke-WebRequest -Uri $Meta.download_link -Method Get -Credential $Cred
[System.IO.File]::WriteAllBytes(".\" + $Meta.file_name, $File.Content)
```