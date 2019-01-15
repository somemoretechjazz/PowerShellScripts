######################################################
#                                                    #
#             VM Deployment - ARM Template           #
#                                                    #
######################################################

$keyVault = 'EncryptionKeysVault'
$rgName = 'KeyVaultRG'
$aadClientSecret = 'Password@123'
$appDisplayName = 'EncVaultApp'
$vmName = 'EncVM1'

Get-AzureRmResourceGroup -Name $rgName

Test-AzureRmResourceGroupDeployment -ResourceGroupName $rgName -TemplateFile 'D:\Backup\PowerShellScripts\Azure key Vault\VM_ARM_Deployment\azuredeploy.json' -TemplateParameterFile 'D:\Backup\PowerShellScripts\Azure key Vault\VM_ARM_Deployment\azuredeploy_parameters.json' -Debug
New-AzureRmResourceGroupDeployment -Name EncVM1Deployment01 -ResourceGroupName $rgname -TemplateFile 'D:\Backup\PowerShellScripts\Azure key Vault\VM_ARM_Deployment\azuredeploy.json' -TemplateParameterFile 'D:\Backup\PowerShellScripts\Azure key Vault\VM_ARM_Deployment\azuredeploy_parameters.json' -Debug
