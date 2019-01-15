######################################################
#                                                    #
#             Encryption - Using KeyVault            #
#                                                    #
######################################################

Login-AzureRmAccount

$subcriptionId = "eb7cd46f-49f0-41d4-ac58-df812ca1c88f"
$tenantID = "72f988bf-86f1-41af-91ab-2d7cd011db47"
Set-AzureRmContext -SubscriptionId $subcriptionId -TenantId $tenantID

$VaultAddress="https://encryptionkeysvault.vault.azure.net"
$keyVault = 'EncryptionKeysVault'
$rgName = 'KeyVaultRG'
$aadClientSecret = 'Password@123'
$appID = '9afc8755-1cae-4925-96d0-0e1499b78fa9'


[System.Reflection.Assembly]::LoadFrom("C:\Modules\User\KeyVaultDecryptor\KeyVaultDecryptor.dll") | Out-Null ##For Azure Automation that is the path where modules get uploaded




$KeyVaultClient = New-Object KeyVaultDecryptor.KeyVaultDecryptor -argumentlist $VaultAddress, $appID, $aadClientSecret

$encrypt = $KeyVaultClient.EncryptText("Administrator@123")

$decrypt = $KeyVaultClient.DecryptText($encrypt)