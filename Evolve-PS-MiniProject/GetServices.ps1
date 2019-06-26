############################################################################################# 
#                          GetServices.ps1  ----> V2.0                                      #
#       Listing the services from different machines as mentioned in the text file          #
#                                                                                           #
#############################################################################################


$moduleName = "ActiveDirectory" 

Write-Host "`nStarting prerequisites tests....." "`n`nChecking $moduleName module availability on this server." -ForegroundColor Green

#Checking the Active Directory Modele availability

if(Get-Module -ListAvailable -Name $moduleName)
{
    Write-Host "$moduleName module is available on this server." -ForegroundColor Green
}
else
{
    Write-Host "$moduleName is not available on this server." -ForegroundColor Red
    Write-Host "Importing $moduleName module." -ForegroundColor Green
    Import-Module -Name $moduleName
}


$serversList = Get-ADComputer -Filter * -Property * | Select-Object Name 
$LogFilePath = "C:\LogFiles"

#Checking Temp folder availability

if(!(test-path $LogFilePath))
{
    Write-Host "`nDirectory $LogFilePath, is not available." -ForegroundColor Red
    Write-Host "`nCreating the Directory $LogFilePath" -ForegroundColor Green
    New-Item -ItemType Directory -Force -Path $LogFilePath
}
else
{
    Write-Host "`nDirectory $LogFilePath is available" "`nGenerating the ServersList.txt file" -ForegroundColor Green
    $file = $LogFilePath + "\" + "ServersList.txt"
    $ServerListFile = New-Item -ItemType File -Force -Path $file
    Get-ADComputer -Filter * -Property * | Select-Object -ExpandProperty Name | Set-Content -Path $ServerListFile
}

$i = 0
$ServiceListFile = $LogFilePath + "\" + "ServiceList.csv"
$servers = Get-Content -Path $ServerListFile
foreach($srv in $servers)
{
    $i++
    Write-Progress -Activity "Fetching services for: $srv" -Status "Count: $i of $($servers.Count)" -PercentComplete (($i/$servers.Count)*100)
    Write-Host "Fetching services for: $srv" -ForegroundColor Yellow
    $ServerDetails = Get-WmiObject -Class Win32_Service -ComputerName $srv| Select-Object -Property __Server, Name, StartMode, State, StartName, DisplayName
    $ServerDetails | Export-Csv -NoTypeInformation -Path $ServiceListFile -Append
    
}

 

