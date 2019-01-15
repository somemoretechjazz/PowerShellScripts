Login-AzureRmAccount
Select-AzureRmSubscription -SubscriptionId "eb7cd46f-49f0-41d4-ac58-df812ca1c88f"
$RG = "AzIdentityRG"
$location = "eastasia"
Get-AzureRmKeyVault -VaultName AzIdentityKV
($resource = Get-AzureRmResource -ResourceId (Get-AzureRmKeyVault -VaultName "AzIdentityKV").ResourceId).Properties | Add-Member -MemberType "NoteProperty" -Name "enableSoftDelete" -Value "true"
Set-AzureRmResource -resourceid $resource.ResourceId -Properties $resource.Properties

$kv_new = "AzIdentityNew"
# Enabling Soft Delete for a new Key Vault
New-AzureRmKeyVault -Name $kv_new -ResourceGroupName $RG -Location $location -EnableSoftDelete
Get-AzureRmKeyVault -VaultName $kv_new
#Deleting a Key Vault protected by Soft-Delete
Remove-AzureRmKeyVault -VaultName $kv_new

#To view the Key Vaults in deleted state
Get-AzureRmKeyVault -InRemovedState

#Recovering a Key Vault from deleted state
Undo-AzureRmKeyVaultRemoval -VaultName $kv_new -ResourceGroupName $RG -Location $location

#Provide permission to user to perform functions on keys in Key Vault
Set-AzureRmKeyVaultAccessPolicy -VaultName $kv_new -UserPrincipalName soumi@microsoft.com -PermissionsToSecrets get,list,set,delete,recover,backup,restore,purge

#Create a Secret
Set-AzureKeyVaultSecret -VaultName $kv_new -Name 'FirstSecret1' -SecretValue (ConvertTo-SecureString -String 'WhyShouldITellYou??' -AsPlainText -Force)

#Delete a Secret from the Key Vault with soft-delete enabled
Remove-AzureKeyVaultSecret -VaultName $kv_new -Name FirstSecret1
Get-AzureKeyVaultSecret -VaultName $kv_new -Name FirstSecret1

#To Check the Secret Vault
$secret = (Get-AzureKeyVaultSecret -VaultName $kv_new -Name FirstSecret1).SecretValueText


#Check the Secret in deleted state
Get-AzureKeyVaultSecret -VaultName $kv_new -InRemovedState

#Recovering the Secret
Undo-AzureKeyVaultSecretRemoval -VaultName $kv_new -Name FirstSecret1

#To Purge a Secret permanently from Sof-Delete container
Remove-AzureKeyVaultSecret -VaultName $kv_new -Name FirstSecret1 -InRemovedState

#Deleting a Key Vault completely
Remove-AzureRmKeyVault -VaultName $kv_new -InRemovedState -Location $location





