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
    $Query,

    [Parameter()]
    [string[]]
    $Fields,

    [Parameter()]
    [int32]
    $Limit
)

begin {
    $Uri = (
        "https://" + 
        $InstanceName +
        ".service-now.com/api/now/table/" +
        $Table +
        "?sysparm_fields=" +
        [System.Web.HttpUtility]::UrlEncode($Fields -join ',') +
        "&sysparm_limit=" +
        $Limit + 
        "&sysparm_display_value=true"
    )
}

process {

    #$Fields = ('one', 'two', 'three')
    #$Fields | Get-Member
    #[System.Web.HttpUtility]::UrlEncode($Fields)

    $Response = Invoke-WebRequest -Method Get -Uri $Uri -Credential $Cred -Proxy "http://clientproxy.corp.int:8080" -ProxyUseDefaultCredentials
    $Response.Content | ConvertFrom-Json | Select-Object -ExpandProperty result | Sort-Object -Property number
}
    
end {
}
