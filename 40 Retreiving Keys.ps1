$tenantId = 'a1627b4f-281e-4f8b-bf13-bddc0eb6857e'
Connect-AzAccount -TenantId $tenantId -AuthScope MicrosoftGraphEndpointResourceId

$keyVaultName = 'Summit2025Demo'
$resourceGroupName = 'Summit2025'
$appName = 'CodeSigningDemoApp'

# Get the previously created Azure AD application registration
$app = Get-AzADApplication -DisplayName $appName
$servicePrincipal = Get-AzADServicePrincipal -ApplicationId $app.AppId

$keyVault = Get-AzKeyVault -VaultName $keyVaultName -ResourceGroupName $resourceGroupName
$scope = $keyVault.ResourceId

$appSecret = Get-Content -Path .\Assets\secret.txt
$secureAppSecret = ConvertTo-SecureString -String $appSecret -AsPlainText -Force
$credential = New-Object System.Management.Automation.PSCredential ($app.AppId, $secureAppSecret)

# Connect to Azure using the service principal credentials
Connect-AzAccount -ServicePrincipal -Tenant $tenantId -Credential $credential


# If this work's, this is bad.
$secret = Get-AzKeyVaultSecret -VaultName $keyVaultName -Name Summit2025Demo -AsPlainText
$secretBytes = [System.Convert]::FromBase64String($secret)
$pfxCertObject = New-Object System.Security.Cryptography.X509Certificates.X509Certificate2 -ArgumentList $secretBytes, '', 'Exportable'
[System.IO.File]::WriteAllBytes('.\temp.pfx', $secretBytes)


Connect-AzAccount -TenantId $tenantId -AuthScope MicrosoftGraphEndpointResourceId
$roles = 'Key Vault Crypto User', 'Key Vault Certificate User', 'Key Vault Reader'

Remove-AzRoleAssignment -ObjectId $servicePrincipal.Id -RoleDefinitionName 'Key Vault Certificate User' -Scope $scope | Out-Null

# Test it again with the removed role assignment
# If this work's, this is bad.
Connect-AzAccount -ServicePrincipal -Tenant $tenantId -Credential $credential

$secret = Get-AzKeyVaultSecret -VaultName $keyVaultName -Name Summit2025Demo -AsPlainText
