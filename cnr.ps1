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
    return Invoke-WebRequest @Params | ConvertFrom-Json

}

function Latest() {
    $latest = List_Plugin_Versions
    return $latest[0].name
}

function Download_Appr() {
    $version = Latest
    if ($global_args.Count -eq 1) {
        $version = $global_args[0]
    }
    $Params = @{}
    $Params.add('outFile', "$Env:HELM_PLUGIN_DIR/appr.exe")
    $Params.add('uri', "https://github.com/app-registry/appr/releases/download/$version/appr-$version-win-x64.exe")
    if ($Env:HTTPS_PROXY) {
        $Params.add('Proxy', $Env:HTTPS_PROXY)
    }
    Invoke-WebRequest @Params

}

function Download_Or_Noop() {
    if (!( Test-Path $Env:HELM_PLUGIN_DIR/appr.exe)) {
        Write-Host "Registry plugin assets do not exist, download them now !"
        Download_Appr $args[0]
    }
}

Download_Or_Noop

switch ($args[0]) {
    "upgrade_plugin" { Download_Appr $args[1..($args.Length-1)] }
    "list_plugin_versions" { List_Plugin_Versions }
    default { Invoke-Expression "$Env:HELM_PLUGIN_DIR/appr.exe helm $args"}
}
