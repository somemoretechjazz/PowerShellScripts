$RG = "AzIdentityRG"
$location = "eastasia"
$keyVaultName = "AzIdentityKV"

#Create a new Storage Account
New-AzureRmStorageAccount -ResourceGroupName $RG `
  -Name "azidentitykvlogs" `
  -Location $location `
  -SkuName Standard_LRS `
  -Kind Storage

$sa = Get-AzureRmStorageAccount -ResourceGroupName $RG 

$kv = Get-AzureRmKeyVault -VaultName $keyVaultName

#Set the logging on Azure Key Vault
Set-AzureRmDiagnosticSetting -ResourceId $kv.ResourceId -StorageAccountId $sa.Id -Enabled $true -Categories AuditEvent -RetentionEnabled $true -RetentionInDays 90

#Create a new Secret
Set-AzureKeyVaultSecret -VaultName AzIdentityKV -Name 'FirstSecret1' -SecretValue (ConvertTo-SecureString -String 'WhyShouldITellYou??' -AsPlainText -Force)

#Create a container inside the Storage
$container = 'insights-logs-auditevent'
Get-AzureStorageBlob -Container $container -Context $sa.Context

#Create a directory
New-Item -Path 'D:\Backup\PowerShellScripts\Azure key Vault\KeyVaultLogs' -ItemType Directory -Force

#Get the list of all Blobs
$blobs = Get-AzureStorageBlob -Container $container -Context $sa.Context

#Download the blobs into the destination folder
$blobs | Get-AzureStorageBlobContent -Destination 'D:\Backup\PowerShellScripts\Azure key Vault\KeyVaultLogs'
