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
    [ValidateSet("true", "false", "all")]
    [String]
    $DisplayValue,

    [Parameter()]
    [ValidateSet("true", "false")]
    [String]
    $ExcludeRefLink,

    [Parameter()]
    [string[]]
    $Fields,

    [Parameter()]
    [int]
    $Limit,

    [Parameter()]
    [string]
    $View,

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
    <# **************************
    import or ask for credentials
    ************************** #>
    if (Test-Path $CrdFilePath) {
        $Cred = Import-Clixml -Path $CrdFilePath
    }
    else {
        $Cred = Get-Credential
    }

    <# ******
    build uri
    ****** #>
    $UriBase = "https://" + $Instance + ".service-now.com/api/now"
    $UriResource = "/table/" + $Table

    $UriQuery = @()
    if ($Query) {
        $UriQuery += "sysparm_query=" + [System.Web.HttpUtility]::UrlEncode($Query)
    }

    if ($DisplayValue) {
        $UriQuery += "sysparm_display_value=" + $DisplayValue
    }

    if ($ExcludeRefLink) {
        $UriQuery += "sysparm_exclude_reference_link=" + $ExcludeRefLink
    }
       
    if ($Fields) {
        $UriQuery += "sysparm_fields=" + [System.Web.HttpUtility]::UrlEncode($Fields)
    }

    if ($Limit) {
        $UriQuery += "sysparm_limit", $Limit -join "="
    }

    if ($View) {
        $UriQuery += "sysparm_view=" + [System.Web.HttpUtility]::UrlEncode($View)
    }

    $UriQueryEnc = "?" + ($UriQuery -join "&")
    $Uri = $UriBase + $UriResource + $UriQueryEnc

    <# ***********
    request config
    *********** #>
    $Conf = @{
        Method     = "Get"
        Uri        = $Uri
        Credential = $Cred
    }

    <# **********
    proxy options
    ********** #>
    if ($Proxy) {
        $Conf.Proxy = $Proxy
        if ($ProxyUseDefaultCrd) {
            $Conf.ProxyUseDefaultCredentials = $true
        }
    }
}

process {
    
    try {
        $Response = Invoke-WebRequest @Conf
        $Result = $Response.Content | ConvertFrom-Json | Select-Object -ExpandProperty result
        $Result    
    }
    catch {

        $LogMessage = 
        ("Error:",
            $Error.ErrorRecord.CategoryInfo.Reason -join " "),
            $Error.ErrorRecord.CategoryInfo.Activity -join ";"
        
        $LogMessage
    }
}
    
    
end {
}
