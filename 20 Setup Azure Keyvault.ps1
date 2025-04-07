Install-Module -Name Az.KeyVault, Az.Resources -Force

$tenantId = 'a1627b4f-281e-4f8b-bf13-bddc0eb6857e'
Connect-AzAccount -TenantId $tenantId -AuthScope MicrosoftGraphEndpointResourceId

$subscriptionId = (Get-AzContext).Subscription.Id
$keyVaultName = 'Summit2025Demo'
$resourceGroupName = 'Summit2025'
$appName = 'CodeSigningDemoApp'

# Create an Azure AD application registration
$app = New-AzADApplication -DisplayName $appName
# Add an authentication secret to the Azure AD application
$authSecret = New-AzADAppCredential -ObjectId $app.Id -EndDate (Get-Date).AddYears(1)
$authSecret.SecretText | Out-File -FilePath '.\Assets\secret.txt' -Force

# Create a service principal for the application
$servicePrincipal = New-AzADServicePrincipal -ApplicationId $app.AppId

# Check if the resource group exists, and create it if it doesn't
if (-not (Get-AzResourceGroup -Name $resourceGroupName -ErrorAction SilentlyContinue)) {
    New-AzResourceGroup -Name $resourceGroupName -Location EastUS
}

# Create a new Azure Key Vault
New-AzKeyVault -ResourceGroupName $resourceGroupName -VaultName $keyVaultName -Location EastUS -Sku Premium
$scope = (Get-AzKeyVault -Name $keyVaultName -ResourceGroupName $resourceGroupName).ResourceId

$roles = 'Key Vault Crypto User', 'Key Vault Certificate User', 'Key Vault Reader'

foreach ($role in $roles) {
    New-AzRoleAssignment -ObjectId $servicePrincipal.Id -RoleDefinitionName $role -Scope $scope | Out-Null
}
New-AzRoleAssignment -ObjectId f4afdf8c-6701-46fe-993b-5dd76192a292 -RoleDefinitionName 'Key Vault Administrator' -Scope $scope | Out-Null

# Upload a certificate to the Key Vault
$certificatePassword = ConvertTo-SecureString -String Password1 -AsPlainText -Force
$certificatePath = '.\Assets\SignTest.pfx'

Connect-AzAccount -TenantId $tenantId -AuthScope KeyVault
# Import the certificate into the Key Vault
Import-AzKeyVaultCertificate -VaultName $keyVaultName -Name Summit2025Demo -FilePath $certificatePath -Password $certificatePassword
