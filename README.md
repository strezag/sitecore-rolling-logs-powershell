# Real-time Rolling/Trailing Sitecore Logs with PowerShell
Real-time Sitecore log monitoring using PowerShell.

## Choose between two scripts:

### RollingSitecoreLogs.ps1
Option to filter in/out INFO, WARN, ERROR entries.
Save this script anywhere on your PC.

1. Right-click and Run with PowerShell.  
![](https://github.com/strezag/sitecore-rolling-logs-powershell/blob/master/screenshots/1.png?raw=true)
2. Select the folder of you Sitecore logs (Data/logs).
![](https://github.com/strezag/sitecore-rolling-logs-powershell/blob/master/screenshots/2.png?raw=true)
3. Prompt displays to filter log messages (INFO, WARN, ERROR).
![](https://github.com/strezag/sitecore-rolling-logs-powershell/blob/master/screenshots/4.png?raw=true)
4. The script will automatically grab the latest 'log.*' file and begin reading it with the appropriate filters.
![](https://github.com/strezag/sitecore-rolling-logs-powershell/blob/master/screenshots/3.png?raw=true)

### RollingSitecoreLogs-RelativeDirectory.ps1
Runs without any UI.  Runs in the directory you place it in. 

1. Drop this script into your Sitecore's log folder.
![](https://github.com/strezag/sitecore-rolling-logs-powershell/blob/master/screenshots/5.png?raw=true)
2. Right-click and Run with PowerShell.  
![](https://github.com/strezag/sitecore-rolling-logs-powershell/blob/master/screenshots/6.png?raw=true)
3. The script will automatically grab the latest 'log.*' file and begin reading it with the appropriate filters.
![](https://github.com/strezag/sitecore-rolling-logs-powershell/blob/master/screenshots/3.png?raw=true)