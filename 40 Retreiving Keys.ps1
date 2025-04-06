# If this work's, this is bad.
$certificatePassword = ConvertTo-SecureString -String 'Password1' -AsPlainText -Force
$secret = Get-AzKeyVaultSecret -VaultName $keyVaultName -Name Summit2025Demo -AsPlainText
$secretBytes = [System.Convert]::FromBase64String($secret)
$pfxCertObject = New-Object System.Security.Cryptography.X509Certificates.X509Certificate2 -ArgumentList $secretBytes, '', 'Exportable'
[System.IO.File]::WriteAllBytes('.\temp.pfx', $secretBytes)
