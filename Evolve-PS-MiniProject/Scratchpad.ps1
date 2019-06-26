Write-Host "Red on white text." -ForegroundColor Green
Get-Service -Name Adobe* | fl
Get-Service -Name Adobe* | Select Name, StartType, Status, StartName


Get-WmiObject -Class Win32_Service -ComputerName localhost -Filter "Name='AdobeARMservice'" | select Name, StartName, State, StartMode

Get-WmiObject -Class Win32_Service -ComputerName localhost -Filter "Name='AdobeARMservice'"

 $server = 'localhost'
 $result = @()
 $Output = 'Server', 'Name', 'StartMode', 'State', 'StartName'
 $ServerDetails = Get-WmiObject -Class Win32_Service -ComputerName $server | select Name, StartName, State, StartMode 
 $property = @{
        Server    = $server
        Name      = $ServerDetails.Name
        StartMode = $ServerDetails.StartMode
        State     = $ServerDetails.State
        StartName = $ServerDetails.StartName
 }
 $result += New-Object -TypeName psobject -Property $Property
 
$result | Select-Object $Output | Convert-OutputForCSV | Export-Csv -NoTypeInformation -Path "C:\Temp\servicelist.csv"


Out-File C:\Temp\servicelist.csv






Export-Csv -NoTypeInformation -Path C:\temp\SrvList.csv 
