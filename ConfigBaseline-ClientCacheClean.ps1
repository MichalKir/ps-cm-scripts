<#
Author:         Michal Kirejczyk
Date:           2018-12-12
Version:        1.0.0
Notes:          Based on: http://eskonr.com/2016/08/sccm-configmgr-how-to-clean-ccmcache-content-older-than-x-days-using-compliance-settings/
What's new:
                1.0.0 (2018-12-12) - Script created            
#>
<#
This is two part script, discovery script and remediation script 
Create configuration item -> Windows Desktops and Servers (custom) -> Windows 10 (only one tested)
New Setting -> Name: "W10 CM Clear Client Cache" - Setting type: Script -> Data type: Boolean
Add copy and paste discovery\remediation scripts -> Language PowerShell
New Compliance Rule -> Name: "CR - W10 CM Clear Client Cache" -> Value = True -> 
-> Check "Run the specified remediation script when this setting is noncompliant" ->
-> [optional] Check "Report noncompliance if this setting instance is not found" ->
-> [optional] Select desired "Noncompliance severity for reports"
Add CI to Configuration Baseline and deploy as desired, 
, make sure that you check "Remediate noncompliant rules when supported"
#>

###### DISCOVERY SCRIPT ######
# Specify content equal or older than x days that'll be deleted
$contentEqualrOrOlderThan = 30

try {
    # Add -contentEqualrOrOlderThan to the current date 
    $dateContentAge = (Get-Date).AddDays(-$contentEqualrOrOlderThan)
    # Create UiResourceMgr-object
    $objUiResourceMgr = New-Object -ComObject UIResource.UIResourceMgr
    # Get number of content that was not used for contentEqualrOrOlderThan
    $cacheNode = $objUiResourceMgr.GetCacheInfo()
    $oldContentCount = ($cacheNode.GetCacheElements() | Where-Object {$_.LastReferenceTime -lt $dateContentAge}).Count
    # Check if any content was not used for more than contentEqualrOrOlderThan
    if ($oldContentCount -eq 0) {
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
# Specify content equal or older than x days that'll be deleted
$contentEqualrOrOlderThan = 30

try {
    # Add -contentEqualrOrOlderThan to the current date 
    $dateContentAge = (Get-Date).AddDays(-$contentEqualrOrOlderThan)
    # Create UiResourceMgr-object
    $objUiResourceMgr = New-Object -ComObject UIResource.UIResourceMgr
    # Get number of content that was not used for contentEqualrOrOlderThan
    $cacheNode = $objUiResourceMgr.GetCacheInfo()
    $oldContent = $cacheNode.GetCacheElements() | Where-Object {$_.LastReferenceTime -lt $dateContentAge}
    # Remove content that was not used for contentEqualrOrOlderThan
    foreach ($o in $oldContent) {
        $cacheNode.DeleteCacheElement($o.CacheElementID)
    } 
}
catch {
    Write-Error -ErrorRecord $_
}