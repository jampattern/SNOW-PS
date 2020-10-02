# ps_ServiceNow
Powershell Examples and Scripts to interact with ServiceNow REST APIs

[Splatting](https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_splatting?view=powershell-7) is used for improved readability.

## Get-TableAPI.ps1
Issue a GET request to the Table API

Parameters:
* InstanceName
* Table
* Query (sysparm_query)
* DisplayValue (sysparm_display_value)
* ExcludeRefLink (sysparm_exclude_reference_link)
* Fields (sysparm_fields)
* Limit (sysparm_limit)
* View (sysparm_view)

### Example
```ps
$Params = @{
  InstanceName = "development"
  Table = "change_request"
  Query = "active=true"
  Fields = "number,short_description,state,assigned_to"
  Limit = 5
}

.\Get-TableAPI.ps1 @Params

```

## Attachment API - Examples
### POST api/now/attachment/file
```ps
$Params = @{
  Method = "Post"
  Uri = "[...]/file?table_name=sc_req_item&table_sys_id=abc123&file_name=test.txt"
  ContentType = "multipart/formdata"
  InFile = "test.txt"
}

Invoke-WebRequest @Params
```

### GET api/now/attachment/{sys_id}
```ps
$Params = @{
  Method = "Get"
  Uri = ".../api/now/attachment/40f93e17"
}

$Response = Invoke-WebRequest @Params

$Meta = $ResponseMeta.Content |
ConvertFrom-Json |
Select-Object -ExpandProperty result

$Meta

<#
size_bytes          : 5120
file_name           : incident.xls
download_link       : https://dev.sn.com/api/now/attachment/40f93e16c0a801130137c1f1bf538539/file
content_type        : application/vnd.ms-excel
.
.
.
#>
```

### GET api/now/attachment/{sys_id}/file
Gets the content of an attachment.  
The `x-attachment-metadata` header contains the same data that is returned by a request to `api/now/attachment/{sys_id}`
```ps

$Params = @{
  Method = "Get"
  Uri = ".../api/now/attachment/40f93e17/file"
}

$Response = Invoke-WebRequest @Params
$Meta = $Response.Headers.'x-attachment-metadata' | 
ConvertFrom-Json

# write content to file
[System.IO.File]::WriteAllBytes($Meta.file_name, $Response.Content)

