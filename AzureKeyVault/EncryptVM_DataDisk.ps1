#####################################
#                                   #
#       EncryptVM - Data Disk       #
#                                   #
#####################################

$keyVault = 'EncryptionKeysVault'
$rgName = 'KeyVaultRG'
$aadClientSecret = 'Password@123'
$appDisplayName = 'EncVaultApp'
$vmName = 'EncVM'

$kv = Get-AzureRmKeyVault -VaultName $keyVault -ResourceGroupName $rgName
$kvUri = $kv.vaulturi
$kvRID = $kv.ResourceId

$aadApp = Get-AzureRmADApplication -DisplayName $appDisplayName
$appID = $aadApp.ApplicationId

Set-AzureRmVMDiskEncryptionExtension -ResourceGroupName $rgName -VMName $vmName -AadClientID $appID -AadClientSecret $aadClientSecret -DiskEncryptionKeyVaultUrl $kvUri -DiskEncryptionKeyVaultId $kvRID -Debug