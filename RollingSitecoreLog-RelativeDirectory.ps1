<#
.SYNOPSIS
Real-time Sitecore log monitoring using PowerShell.

.DESCRIPTION
Drop this script into your Sitecore's log folder.
Right-click and Run with PowerShell.  
The script will automatically grab the latest 'log.*' file and begin reading it with the appropriate filters.

.AUTHOR
Gabriel Streza
@GabeStreza
https://github.com/strezag

#>


Try {
        $currentDirectory = (Resolve-Path .\).Path
        Write-Host 'Folder selected: ' $currentDirectory -ForegroundColor Green

        $latestLog = Get-ChildItem -Path $currentDirectory |Where-Object {$_.Name -like 'log.*'}| Sort-Object LastAccessTime -Descending | Select-Object -First 1
        $fullFileFath = $latestLog.FullName

        Write-Host 'Opening' $fullFileFath -ForegroundColor Green '...'

        Get-Content $fullFileFath -wait
}
Catch {
    Write-Host 'Try selecting a Data/Logs folder.' -ForegroundColor Red
    $HOST.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown") | OUT-NULL
    $HOST.UI.RawUI.Flushinputbuffer()
}