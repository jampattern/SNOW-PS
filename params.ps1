[CmdletBinding()]
param(
    [Parameter(Mandatory = $true)]
    [String]
    $InstanceName,

    [Parameter(Mandatory = $true)]
    [String]
    $Table,

    [Parameter()]
    [String]
    $Query
)
process {
    $Uri = (
        "https://" + 
        $InstanceName +
        ".service-now.com/api/now/table/" +
        $Table +
        "?sysparm_fields=sys_id%2Cnumber%2Cshort_description" +
        "&sysparm_limit=100"
    )

    $Response = Invoke-WebRequest -Method Get -Uri $Uri -Credential $Cred
    $Response.Content | ConvertFrom-Json | Select-Object -ExpandProperty result | Sort-Object -Property number
}
    
end {
}


