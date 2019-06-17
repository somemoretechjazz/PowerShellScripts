############################################################################################# 
#                                                                                           #
#                   UploadDownloadCertificatesFromKeyVault.ps1  ----> V1.0                  #
#             Upload and Download .pfx files with Passwords from Azure Key Vault            #
#                                                                                           #
#############################################################################################


Write-Host "Login to Azure"
Connect-AzAccount


#$vaultName = "SecretzVault"
$RGName = "SecretzRG"
$Subscription = "04c48986-6495-4bf4-b098-92e5f1233cf0"

$vaultName = Read-Host -Prompt "Enter Key Vault Name"


Write-Host "`n`n--------------------Azure Key Vault Certificate Operations-----------------------------`n`n" -ForegroundColor Cyan
Write-Host "1: Upload a .pfx/.pem certificate file to Azure Key Vault." -ForegroundColor Cyan
Write-Host "2: Download a .pfx/.pem certificate file from Azure Key Vault." -ForegroundColor Cyan
Write-Host "3: View the available certificates in this Vault." -ForegroundColor Cyan
Write-Host "4: Exit" -ForegroundColor Cyan
Write-Host "`n`n---------------------------------------------------------------------------------------`n`n" -ForegroundColor Cyan
$choice = Read-Host -Prompt "Enter your choice"

:main switch($choice)
{
    1 {
        Write-Host "`n`n------------------------------------------------------------------`n`n" -ForegroundColor Cyan
        Write-Host "1: Export certificate from Users' Certificate Store."
        Write-Host "2: Export certificate from Machine's' Certificate Store."
        Write-Host "3: Upload certificate from a folder."
        Write-Host "4: Exit."
        Write-Host "`n`n------------------------------------------------------------------`n`n" -ForegroundColor Cyan
        $ch = Read-Host -Prompt "Select option"

        switch($ch)
        {
            1{
               $certPassword = Read-Host -AsSecureString -Prompt "Enter Password"
               $fileName = Read-Host -Prompt "Enter certificate file name"
               $filePath = "c:\temp\" + $fileName + ".pfx"
               Write-Host "Exporting the certificate......" -ForegroundColor Green
               Export-PfxCertificate -Cert "Cert:\CurrentUser\My\$($cert.Thumprint)" -FilePath $filePath -Password $certPassword 
               #Uploading the cert to Azure Key Vault
               Write-Host "Uploading the certiifcate to vault $vaultName...."  -ForegroundColor Green
               Import-AzKeyVaultCertificate -VaultName $vaultName -Name ADFSCert -FilePath $filePath -Password $certPassword  
               Write-Host "Certficate uploaded successfully!!" -ForegroundColor Green
            }

            2{
               $certPassword = Read-Host -AsSecureString -Prompt "Enter Password"
               $fileName = Read-Host -Prompt "Enter certificate file name"
               $filePath = "c:\temp\" + $fileName + ".pfx"
               Write-Host "Exporting the certificate......" -ForegroundColor Green
               Export-PfxCertificate -Cert "Cert:\LocalMachine\My\$($cert.Thumprint)" -FilePath $filePath -Password $certPassword 
               #Uploading the cert to Azure Key Vault
               Write-Host "Uploading the certiifcate to vault $vaultName...."  -ForegroundColor Green
               Import-AzKeyVaultCertificate -VaultName $vaultName -Name ADFSCert -FilePath $filePath -Password $certPassword  
               Write-Host "Certficate uploaded successfully!!" -ForegroundColor Green        
            }

            3{
                $certPassword = Read-Host -AsSecureString -Prompt "Enter Password"
                $filepath = Read-Host -Prompt "Enter Certificate Location"

                #Uploading the cert to Azure Key Vault
                Write-Host "Uploading the certiifcate to vault $vaultName...."  -ForegroundColor Green
                Import-AzKeyVaultCertificate -VaultName $vaultName -Name ADFSCert -FilePath $filePath -Password $certPassword  
                Write-Host "Certficate uploaded successfully!!" -ForegroundColor Green  

            }
            4{
                Write-Host "`n`nExiting......." -ForegroundColor Yellow
                break;
            }
        }
       
     }

     2 {
         
         $certName = Read-Host -Prompt "Enter cert Name"
         $pfxpath = [Environment]::GetFolderPath("Desktop") + "\$certName.pfx"
         $password = Read-Host -AsSecureString -Prompt "Enter Password to protect the private key"

         $pfxCert = Get-AzKeyVaultSecret -VaultName $vaultName -Name $certName
         $pfxUnprotectedBytes = [convert]::FromBase64String($pfxCert.SecretValueText)
         $pfx = New-Object Security.Cryptography.X509Certificates.X509Certificate2
         $pfx.Import($pfxUnprotectedBytes, $null, [Security.Cryptography.X509Certificates.X509KeyStorageFlags]::Exportable)
         $pfxProtectedBytes = $pfx.Export([Security.Cryptography.X509Certificates.X509ContentType]::Pkcs12, $password)
         [IO.File]::WriteAllBytes($pfxPath,$pfxProtectedBytes)
         Write-Host "Certificate downloaded successfully on your desktop!!" -ForegroundColor Green

     }

     3{
        Write-Host "Listing the certificates available in the Vault: $vaultName" -ForegroundColor Yellow
        Get-AzKeyVaultCertificate -VaultName $vaultName | Select-Object Name, VaultName, Expires, Notbefore | ft -AutoSize -Wrap
     }

     4 {
        Write-Host "`n`nExiting......." -ForegroundColor Yellow
        break;
     }
}


