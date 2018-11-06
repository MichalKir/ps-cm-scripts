##################################
# This is two part script, discovery script and remediation script 
# Create configuration item -> Windows Desktops and Servers (custom) -> Windows 10 (only one tested)
# New Setting -> Name: "W10 CM Client Cache Location" - Setting type: Script -> Data type: Boolean
# Add copy and paste discovery\remediation scripts -> Language PowerShell
# New Compliance Rule -> Name: "CR - W10 CM Client Cache Location" -> Value = True -> 
# -> Check "Run the specified remediation script when this setting is noncompliant" ->
# -> [optional] Check "Report noncompliance if this setting instance is not found" ->
# -> [optional] Select desired "Noncompliance severity for reports"
# Add CI to Configuration Baseline and deploy as desired, 
# , make sure that you check "Remediate noncompliant rules when supported"


###### DISCOVERY SCRIPT ######
$desiredCacheLocation = Join-Path -Path $env:windir -ChildPath "ccmcache"
try {
    # Create UiResourceMgr-object
    $objUiResourceMgr = New-Object -ComObject UIResource.UIResourceMgr
    # Check if cache location is correct 
    if ($objUiResourceMgr.GetCacheInfo().Location -eq $desiredCacheLocation) {
        return [boolean]$true
    }
    else {
        return [boolean]$false
    }
}
catch {
    Write-Error -ErrorRecord $_
}

##### REMEDIATION SCRIPT #####
$desiredCacheLocation = Join-Path -Path $env:windir -ChildPath "ccmcache"
try {
    # Create UIResourceMgr-object
    $objUiResourceMgr = New-Object -ComObject UIResource.UIResourceMgr
    # Set cache to desired location
    $cacheNode = $objUiResourceMgr.GetCacheInfo()
    $cacheNode.Location = $desiredCacheLocation
}
catch {
    Write-Error -ErrorRecord $_
}