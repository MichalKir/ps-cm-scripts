<#
Author:         Michal Kirejczyk
Date:           2018-11-06
Version:        1.0.0
What's new:
                1.0.0 (2018-11-06) - Script created            
#>
<#
    This is two part script, discovery script and remediation script 
    Create configuration item -> Windows Desktops and Servers (custom) -> Windows 10 (only one tested)
    New Setting -> Name: "W10 CM Client Cache Size" - Setting type: Script -> Data type: Boolean
    Add copy and paste discovery\remediation scripts -> Language PowerShell
    New Compliance Rule -> Name: "CR - W10 CM Client Cache Size" -> Value = True -> 
    -> Check "Run the specified remediation script when this setting is noncompliant" ->
    -> [optional] Check "Report noncompliance if this setting instance is not found" ->
    -> [optional] Select desired "Noncompliance severity for reports"
    Add CI to Configuration Baseline and deploy as desired, 
    , make sure that you check "Remediate noncompliant rules when supported"
#>

###### DISCOVERY SCRIPT ######
[int]$desiredCacheSizeInMB = 61440
try {
    # Create UiResourceMgr-object
    $objUiResourceMgr = New-Object -ComObject UIResource.UIResourceMgr
    # Check if cache size is correct 
    if ([int]$objUiResourceMgr.GetCacheInfo().TotalSize -eq $desiredCacheSizeInMB) {
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
[int]$desiredCacheSizeInMB = 61440
try {
    # Create UIResourceMgr-object
    $objUiResourceMgr = New-Object -ComObject UIResource.UIResourceMgr
    # Set cache to desired cache
    $cacheNode = $objUiResourceMgr.GetCacheInfo()
    $cacheNode.TotalSize = $desiredCacheSizeInMB
}
catch {
    Write-Error -ErrorRecord $_
}