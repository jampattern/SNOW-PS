[CmdletBinding()]
param(
    [Parameter(Mandatory = $true)]
    [String]
    $Instance,
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
    [String]
    $CrdFilePath,
    
    # proxy
    [Parameter()]
    [string]
    $Proxy,
    [Parameter()]
    [switch]
    $ProxyUseDefaultCrd
)

begin {

    if (Test-Path $CrdFilePath){
        $Cred = Import-Clixml -Path $CrdFilePath
    } else {
        $Cred = Get-Credential
    }


    $UriBase = "https://" + $Instance + ".service-now.com/api/now"
    $UriResource = "/table/" + $Table

    $UriQuery = @()

    if ($Fields){
        $UriQuery += "sysparm_fields=" + [System.Web.HttpUtility]::UrlEncode($Fields)
    }

    if ($Query){
        $UriQuery += "sysparm_query=" + [System.Web.HttpUtility]::UrlEncode($Query)
    }

    if ($Limit){
        $UriQuery += "sysparm_limit", $Limit -join "="
    }

    $UriQueryEnc = "?" + ($UriQuery -join "&")
    $Uri = $UriBase + $UriResource + $UriQueryEnc

    $Conf = @{
        Method     = "Get"
        Uri        = $Uri
        Credential = $Cred
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
    $Response.Content | ConvertFrom-Json | Select-Object -ExpandProperty result
}
    
end {
}
