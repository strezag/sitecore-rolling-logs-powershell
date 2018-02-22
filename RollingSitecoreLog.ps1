<#
.SYNOPSIS
Real-time Sitecore log monitoring using PowerShell with the option to filter in/out INFO, WARN, ERROR entries.

.DESCRIPTION
Right-click and Run with PowerShell.  
Select the folder of you Sitecore logs (Data/logs).
Prompt displays to filter log messages (INFO, WARN, ERROR).
The script will automatically grab the latest 'log.*' file and begin reading it with the appropriate filters.

.AUTHOR
Gabriel Streza
@GabeStreza
https://github.com/strezag

#>

Function ConfirmOptions{
    [void] [System.Reflection.Assembly]::LoadWithPartialName("System.Windows.Forms")
    [void] [System.Reflection.Assembly]::LoadWithPartialName("System.Drawing")
    
    $Form = New-Object System.Windows.Forms.Form
    $Form.width = 450
    $Form.height = 200
    $Form.Text = "Enable Log Options"
    $Form.Topmost = $True

    $enableInfoCb = new-object System.Windows.Forms.checkbox
    $enableInfoCb.Location = new-object System.Drawing.Size(300,30)
    $enableInfoCb.Size = new-object System.Drawing.Size(250,50)
    $enableInfoCb.Text = "Enable INFO"
    $enableInfoCb.Checked = $true
    $Form.Controls.Add($enableInfoCb)  

    $enableWarnCb = new-object System.Windows.Forms.checkbox
    $enableWarnCb.Location = new-object System.Drawing.Size(165,30)
    $enableWarnCb.Size = new-object System.Drawing.Size(250,50)
    $enableWarnCb.Text = "Enable WARN"
    $enableWarnCb.Checked = $true
    $Form.Controls.Add($enableWarnCb)  

    $enableErrorCB = new-object System.Windows.Forms.checkbox
    $enableErrorCB.Location = new-object System.Drawing.Size(30,30)
    $enableErrorCB.Size = new-object System.Drawing.Size(250,50)
    $enableErrorCB.Text = "Enable ERROR"
    $enableErrorCB.Checked = $true
    $Form.Controls.Add($enableErrorCB)  

    $OKButton = new-object System.Windows.Forms.Button
    $OKButton.Location = new-object System.Drawing.Size(60,100)
    $OKButton.Size = new-object System.Drawing.Size(100,40)
    $OKButton.Text = "OK"
    $OKButton.Add_Click({
        $script:enableInfo = $enableInfoCb.Checked
        $script:enableWarn = $enableWarnCb.Checked
        $script:enableError = $enableErrorCB.Checked
        $Form.Close()
    })
	
    $form.Controls.Add($OKButton)
 
    $CancelButton = new-object System.Windows.Forms.Button
    $CancelButton.Location = new-object System.Drawing.Size(255,100)
    $CancelButton.Size = new-object System.Drawing.Size(100,40)
    $CancelButton.Text = "Cancel"
    $CancelButton.Add_Click({$Form.Close()})
    $form.Controls.Add($CancelButton)
        
    $Form.Add_Shown({$Form.Activate()})
    [void] $Form.ShowDialog() 
}
 

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

        $confirmedOptions = ConfirmOptions
        
        if(($script:enableInfo -eq $true) -and ($script:enableWarn -eq $true) -and ($script:enableError -eq $true)){
             Write-Host 'All Log Options Enabled...'
            Get-Content $fullFileFath -wait 

        }elseif(($script:enableInfo -eq $true) -and ($script:enableWarn -eq $true) -and ($script:enableError -eq $false)){
             Write-Host 'Disable ERROR'
             Get-Content $fullFileFath -wait | where { $_ -NotMatch " ERROR " }

        }elseif(($script:enableInfo -eq $true) -and ($script:enableWarn -eq $false) -and ($script:enableError -eq $false)){
             Write-Host 'Enable INFO only'
            Get-Content $fullFileFath -wait | where { $_ -Match  " INFO " }
        }
        elseif(($script:enableInfo -eq $false) -and ($script:enableWarn -eq $true) -and ($script:enableError -eq $false)){
             Write-Host 'Enable WARN only'
            Get-Content $fullFileFath -wait | where { $_ -Match " WARN " }
        }
        elseif(($script:enableInfo -eq $false) -and ($script:enableWarn -eq $false) -and ($script:enableError -eq $true)){
             Write-Host 'Enable ERROR only'
            Get-Content $fullFileFath -wait | where { $_ -Match " ERROR " }
        }
        elseif(($script:enableInfo -eq $false) -and ($script:enableWarn -eq $true) -and ($script:enableError -eq $true)){
             Write-Host 'Disable INFO'
            Get-Content $fullFileFath -wait | where { $_ -NotMatch  " INFO " }
        }elseif(($script:enableInfo -eq $true) -and ($script:enableWarn -eq $false) -and ($script:enableError -eq $true)){
             Write-Host 'Disable WARN'
            Get-Content $fullFileFath -wait | where { $_ -NotMatch  " WARN " }
        }
        
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
