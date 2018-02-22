Try {

   Write-Host 'Folder Browser opened.  Select your Sitecore log folder.' -ForegroundColor Green

    Add-Type -AssemblyName System.Windows.Forms
    $FolderBrowser = New-Object System.Windows.Forms.FolderBrowserDialog
    $FolderBrowser.Description = 'Select the folder containing the Sitecore logs.'
    $result = $FolderBrowser.ShowDialog((New-Object System.Windows.Forms.Form -Property @{ 
    TopMost = $true }))
    if ($result -eq [Windows.Forms.DialogResult]::OK){
        Write-Host 'Folder selected: ' $FolderBrowser.SelectedPath -ForegroundColor Green

        $latestLog = Get-ChildItem -Path $FolderBrowser.SelectedPath |Where-Object {$_.Name -like 'log.*'}| Sort-Object LastAccessTime -Descending | Select-Object -First 1
        $fullFileFath = $latestLog.FullName

        Write-Host 'Opening' $fullFileFath -ForegroundColor Green '...'

        Get-Content $fullFileFath -wait
    }
    else {
        Write-Host 'Maybe next time...' -ForegroundColor Red
        exit
    }

}

Catch {
    Write-Host 'Try selecting a Data/Logs folder.' -ForegroundColor Red
    $HOST.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown") | OUT-NULL
    $HOST.UI.RawUI.Flushinputbuffer()
}