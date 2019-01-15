###########################################################
#                                                         #
#                                                         #
#        SAS Token Generation and File Upload             #
#                                                         #
#                                                         #
###########################################################

Login-AzureRmAccount
$resourceGroup = "AzureKeyVault"
$storageAccount = "storagedockerimages"
$keyVaultName = "StorageAKV"
$container = "dockerimages"
$localpath = "C:\ARMTemplate.json"
$dir = "E:\StorageFiles\"

$storageAccount = Get-AzureRmStorageAccount -ResourceGroupName $resourceGroup -StorageAccountName $storageAccount
$accountName = $storageAccount.StorageAccountName

#Name of the SAS Token
$writeSasName = "writeBlobSas" 
#Period the SAS Token will be valid
$validityPeriod = [System.Timespan]::FromMinutes(10)

$sctx = New-AzureStorageContext -StorageAccountName $accountName -Protocol Https -StorageAccountKey Key1
$start = [System.DateTime]::Now.AddDays(-1)
$end = [System.DateTime]::Now.AddMonths(1)
#Generates a SAS Token
$at = New-AzureStorageAccountSasToken -Service blob,file,Table,Queue -ResourceType Service,Container,Object -Permission "racwdlup" -Protocol HttpsOnly -StartTime $start -ExpiryTime $end -Context $sctx
#Sets a Shared Access Signature (SAS) definition with Key Vault for a given Key Vault managed Azure Storage Account.
$sas = Set-AzureKeyVaultManagedStorageSasDefinition -AccountName $accountName -VaultName $keyVaultName -Name $writeSasName -TemplateUri $at -SasType 'account' -ValidityPeriod ([System.Timespan]::FromDays(30))

$sasToken = (Get-AzureKeyVaultSecret -VaultName $keyVaultName -Name $sas.Sid.Substring($sas.Sid.LastIndexOf('/')+1)).SecretValueText
$azureStorageAccountContext = New-AzureStorageContext -SasToken $sasToken -StorageAccountName $accountName

#foreach($file in $dir)
#{
    #Write-Output("Uploading file")
    Set-AzureStorageBlobContent -File $localpath -Container $container -Blob "ARMTemplate.json" -Context $azureStorageAccountContext -Force
#}




