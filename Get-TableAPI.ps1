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
    $Limit,
    [Parameter()]
    [string]
    $Proxy,
    [Parameter()]
    [switch]
    $ProxyUseDefaultCrd
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

    $Conf = @{
        Method = "Get"
        Uri = $Uri
        Credential = Get-Credential
    }

    if ($Proxy) {
        $Conf.Proxy = $Proxy
        if ($ProxyUseDefaultCrd) {
            $Conf.ProxyUseDefaultCredentials = $true
        }
    }

}

process {
    $Response = Invoke-WebRequest @Conf
    $Response.Content | ConvertFrom-Json | Select-Object -ExpandProperty result | Sort-Object -Property number
}
    
end {
}
