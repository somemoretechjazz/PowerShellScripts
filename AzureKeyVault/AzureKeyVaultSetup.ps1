################################
#     Azure KeyVault Setup     #
################################   

Login-AzureRmAccount
$subcriptionId = "eb7cd46f-49f0-41d4-ac58-df812ca1c88f"
$tenantID = "72f988bf-86f1-41af-91ab-2d7cd011db47"
Set-AzureRmContext -SubscriptionId $subcriptionId -TenantId $tenantID


$keyVault = 'EncryptionKeysVault'
$rgName = 'KeyVaultRG'
$location = 'South India'
$aadClientSecret = 'Password@123'
$appDisplayName = 'EncVaultApp'

New-AzureRmResourceGroup -Name $rgName -Location $location
New-AzureRmKeyVault -VaultName $keyVault -ResourceGroup $rgName -Location $location

Set-AzureRmKeyVaultAccessPolicy -VaultName $keyName -ResourceGroupName $rgName -EnabledForDiskEncryption -EnableSoftDelete

$aadApp = New-AzureRmADApplication -DisplayName $appDisplayName -HomePage "http://EncVaultApp/"  -IdentifierUris "http://EncVaultApp/" -Password $aadClientSecret -debug

$appID = $aadApp.ApplicationID

$aadServicePrincipal = New-AzureADServicePrincipal -AppId $appID
Set-AzureRmKeyVaultAccessPolicy -VaultName $keyVault -ServicePrincipalName $appID -PermissionsToKeys all -PermissionsToSecrets all 
