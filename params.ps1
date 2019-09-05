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

    $UriScheme = "https://"
    $UriPath = "/api/now/table/" + $Table
    $UriQuery = ""
    $UriFields = "?sysparm_fields=" + [System.Web.HttpUtility]::UrlEncode($Fields -join ',')
    
    if ($Limit){
        $UriLimit = "&sysparm_limit=" + $Limit
    } else {
        $UriLimit = ""    
    }
    

    $Uri = (
        $UriScheme + 
        $InstanceName +
        ".service-now.com" + 
        $UriPath +
        $UriFields + 
        $UriLimit +
        "&sysparm_display_value=true"
    )

    $Args = @{
        Method = "Get"
        Uri = $Uri
        Credential = Get-Credential
        Proxy = "http://proxy.example.com:8000"
        ProxyUseDefaultCredentials = $true
    }

}

process {

    $Response = Invoke-WebRequest @Args
    $Response.Content | ConvertFrom-Json | Select-Object -ExpandProperty result | Sort-Object -Property number

}
    
end {
}
