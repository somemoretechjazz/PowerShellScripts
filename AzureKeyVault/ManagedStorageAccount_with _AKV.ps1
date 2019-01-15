###########################################################
#                                                         #
#                                                         #
#        Managed Storage Account with AKV                 #
#                                                         #
#                                                         #
###########################################################

Login-AzureRmAccount
Select-AzureRmSubscription -SubscriptionId "eb7cd46f-49f0-41d4-ac58-df812ca1c88f"
$resourceGroup = "AzureKeyVault"
$storageAccount = "storagedockerimages"
$keyVaultName = "StorageAKV"

$storageAccount = Get-AzureRmStorageAccount -ResourceGroupName $resourceGroup -StorageAccountName $storageAccount
$SP = $(Get-AzureRmADServicePrincipal -ServicePrincipalName cfa8b339-82a2-471a-a3c9-0fc0be7a4093).id #Azure Key Vault's Application ID 'cfa8b339-82a2-471a-a3c9-0fc0be7a4093' Note: This needs to be entered as it is
#$appId = $(Get-AzureRmADApplication -DisplayNameStartWith "AKV").ApplicationID

New-AzureRmRoleAssignment -ObjectId $SP -RoleDefinitionName 'Storage Account Key Operator Service Role' -scope $storageAccount.Id

$userPrincipalId = $(Get-AzureRmADUser -UserPrincipalName "sourav@soumimsft.onmicrosoft.com").Id
Set-AzureRmKeyVaultAccessPolicy -VaultName $keyVaultName -ObjectId $userPrincipalId -PermissionsToStorage set, get, regeneratekey

#Set-AzureRmKeyVaultAccessPolicy -VaultName $keyVaultName -ServicePrincipalName $appId -PermissionsToStorage all

$rotationPeriod = [System.Timespan]::FromDays(1) 
$accountName = $storageAccount.StorageAccountName
Add-AzureKeyVaultManagedStorageAccount -VaultName $keyVaultName -AccountName $accountName -AccountResourceId $storageAccount.Id -ActiveKeyName 'key1' -RegenerationPeriod $rotationPeriod