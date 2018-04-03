$global_args=$args

if(!(Test-Path $Env:HELM_PLUGIN_DIR)){
    $Env:HELM_PLUGIN_DIR="$Env:USERPROFILE/.helm/plugins/registry"
}


function List_Plugin_Versions() {
    $Params = @{
        uri = "https://api.github.com/repos/app-registry/appr/tags"
    }
    if ($Env:HTTPS_PROXY) {
        $Params.add('Proxy', $Env:HTTPS_PROXY)
    }
    [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
    return Invoke-WebRequest @Params | ConvertFrom-Json

}

function Latest() {
    $latest = List_Plugin_Versions
    return $latest[0].name
}

function Download_Appr() {
    $version = Latest
	# 2 global_args means e.g.: 
	# helm registry upgrade-plugin v0.7.2
	# then v0.7.2 is used as version, if not latest
	if ($global_args.Count -eq 2) {
        $version = $global_args[1]
    }
    $Params = @{}
    $Params.add('outFile', "$Env:HELM_PLUGIN_DIR/appr.exe")
    $Params.add('uri', "https://github.com/app-registry/appr/releases/download/$version/appr-win-x64.exe")
    if ($Env:HTTPS_PROXY) {
        $Params.add('Proxy', $Env:HTTPS_PROXY)
    }
    Invoke-WebRequest @Params

}

function Download_Or_Noop() {
    if (!( Test-Path $Env:HELM_PLUGIN_DIR/appr.exe)) {
        Write-Host "Registry plugin assets do not exist, download them now !"
        Download_Appr
    }
}

Download_Or_Noop

switch ($args[0]) {
    "upgrade-plugin" { Download_Appr }
    "list-plugin-versions" { List_Plugin_Versions }
    default { Invoke-Expression "$Env:HELM_PLUGIN_DIR/appr.exe helm $args"}
}
