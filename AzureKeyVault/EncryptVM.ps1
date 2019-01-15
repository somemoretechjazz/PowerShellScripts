#####################################
#                                   #
#           EncryptVM               #
#                                   #
#####################################


Login-AzureRmAccount -Credential $cred

$subcriptionId = "eb7cd46f-49f0-41d4-ac58-df812ca1c88f"
$tenantID = "72f988bf-86f1-41af-91ab-2d7cd011db47"
Set-AzureRmContext -SubscriptionId $subcriptionId -TenantId $tenantID

$keyVault = 'EncryptionKeysVault'
$rgName = 'KeyVaultRG'
$aadClientSecret = 'Password@123'
$appID = '9afc8755-1cae-4925-96d0-0e1499b78fa9'
$vmName = 'EncVM'

$kv = Get-AzureRmKeyVault -VaultName $keyVault -ResourceGroupName $rgName
$kvUri = $kv.vaulturi
$kvRID = $kv.ResourceId


Set-AzureRmVMDiskEncryptionExtension -ResourceGroupName $rgName -VMName $vmName -AadClientID $appID -AadClientSecret $aadClientSecret -DiskEncryptionKeyVaultUrl $kvUri -DiskEncryptionKeyVaultId $kvRID -Debug