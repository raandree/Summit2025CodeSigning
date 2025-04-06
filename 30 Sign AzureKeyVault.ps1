$tenantId = 'a1627b4f-281e-4f8b-bf13-bddc0eb6857e'
Connect-AzAccount -TenantId $tenantId -AuthScope MicrosoftGraphEndpointResourceId

$keyVaultName = 'Summit2025Demo'
$resourceGroupName = 'Summit2025'
$appName = 'CodeSigningDemoApp'

# Get the previously created Azure AD application registration
$app = Get-AzADApplication -DisplayName $appName
$appSecret = Get-Content -Path .\Assets\secret.txt

$secureAppSecret = ConvertTo-SecureString -String $appSecret -AsPlainText -Force
$credential = New-Object System.Management.Automation.PSCredential ($app.a, $secureAppSecret)



# Connect to Azure using the service principal credentials
Connect-AzAccount -ServicePrincipal -Tenant $tenantId -Credential $credential

# Let Azure Key Vault handle the signing process
$credential = New-Object System.Management.Automation.PSCredential ($appId, $secureSecret)

Get-AzKeyVaultCertificate -VaultName $keyVaultName -Name Summit2025
Get-AzKeyVaultSecret -VaultName $keyVaultName -Name Summit2025

dotnet tool install --global AzureSignTool --version 2.0.17

$scriptFile = Get-Item -Path .\Test.ps1

.\AzureSignTool-x64.exe sign --description 'https://vcsjones.com' `
    --azure-key-vault-url "https://$keyVaultName.vault.azure.net" `
    --azure-key-vault-client-id $appId `
    --azure-key-vault-tenant-id $tenantId `
    --azure-key-vault-client-secret $secret `
    --azure-key-vault-certificate Summit2025 `
    --timestamp-rfc3161 http://timestamp.digicert.com `
    --verbose `
    $scriptFile.FullName


Key Vault Crypto User
Key Vault Certificate User
Key Vault Reader


New-AzKeyVaultRoleAssignment -HsmName bez-hsm -RoleDefinitionName 'Managed Hsm Crypto User' -ObjectId xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx


Get-AuthenticodeSignature -FilePath $scriptFile.FullName