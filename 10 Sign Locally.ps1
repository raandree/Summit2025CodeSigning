# Define the certificate parameters
$certName = 'CN=CodeSigningCert'
$pfxPath = '.\CodeSigningCert.pfx'
$pfxPassword = 'Password1'
$timestampServer = 'http://timestamp.digicert.com'

# Create the self-signed certificate
$cert = New-SelfSignedCertificate -Subject $certName -Type CodeSigningCert -CertStoreLocation Cert:\LocalMachine\My
$cert | Move-Item -Destination Cert:\LocalMachine\Root

#Does the certificate have a private key and is a valid code signing certificate?
$cert = Get-ChildItem -Path Cert:\LocalMachine\Root -CodeSigningCert | Where-Object Subject -EQ $certName
$cert.HasPrivateKey

#-----------------------------

Set-AuthenticodeSignature -FilePath .\Test.ps1 -Certificate $cert -TimestampServer $timestampServer
Get-AuthenticodeSignature -FilePath .\Test.ps1

# Export the certificate to a PFX file
Export-PfxCertificate -Cert $cert -FilePath $pfxPath -Password (ConvertTo-SecureString -String $pfxPassword -Force -AsPlainText)

#Signtool available as part of the Windows Software Development Kit 
#https://learn.microsoft.com/en-us/windows/win32/seccrypto/signtool

.\signtool.exe sign /f $pfxPath /p $pfxPassword /t $timestampServer /fd SHA256 .\Test.ps1
.\signtool.exe verify .\Test.ps1