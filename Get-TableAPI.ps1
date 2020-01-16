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
    $ProxyUseDefaultCrd,

    # configuration
    [ArgumentCompleter( {
            param ( $commandName,
                $parameterName,
                $wordToComplete,
                $commandAst,
                $fakeBoundParameters )
            $possibleValues = Get-Content -Path .\configs.json | ConvertFrom-Json
            $possibleValues.Configurations | ForEach-Object { $_.Name }
        })]
    [String] $Configuration
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
    if ($Fields) {
        $UriQuery += "sysparm_fields=" + [System.Web.HttpUtility]::UrlEncode($Fields)
    }

    if ($Query) {
        $UriQuery += "sysparm_query=" + [System.Web.HttpUtility]::UrlEncode($Query)
    }

    if ($Limit) {
        $UriQuery += "sysparm_limit", $Limit -join "="
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
