[CmdletBinding()]
Param(
    [Parameter(Mandatory=$true, Position=0, HelpMessage="This is the url for the web you wish to unlock workflows")]
    [string]$siteUrl,

    [Parameter(Mandatory=$true, Position=1, HelpMessage="This is the number of the workflow task ID")]
    [int]$itemId
)

# This script must be run from the SharePoint server because it uses the local DLL referenced below
[System.Reflection.Assembly]::LoadWithPartialName(“Microsoft.SharePoint”)

$site = New-Object Microsoft.SharePoint.SPSite($siteUrl)
$web = $site.OpenWeb()
Write-Host `n`nConnected to $($web.url)
$list = $web.Lists["Workflow Tasks"]
$item = $list.GetItemByID($itemId)

    Try {
        Write-Host `nUnlocking workflow task $item.name
        $item[[Microsoft.SharePoint.SPBuiltInFieldId]::WorkFlowVersion] = 1
        $item.SystemUpdate()
    }
    Catch [System.Exception] {
        Write-Host `nCaught error trying to unlock workflow: $($_.Message) -ForegroundColor Red
    }

$web.Dispose()
$site.Dispose()
