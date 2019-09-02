[CmdletBinding()]
param(
    [Parameter(Mandatory = $true)]
    [String]
    $InstanceName
)
process {
    $Uri = (
        "https://" + 
        $InstanceName +
        ".service-now.com/api/now" +
        "/table/problem?" +
        "sysparm_fields=sys_id%2Cnumber%2Cshort_description" +
        "&sysparm_limit=100"
    )

    $Response = Invoke-WebRequest -Method Get -Uri $Uri -Credential $Cred
    $Response.Content | ConvertFrom-Json | Select-Object -ExpandProperty result | Sort-Object -Property number
}
    
end {
}


