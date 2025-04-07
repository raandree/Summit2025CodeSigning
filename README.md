# PowerShell Code Signing Demo

This repository contains materials for the PowerShell Code Signing demonstration session at [PowerShell Summit 2025](https://www.powershellsummit.org/).

## Project Overview

This project demonstrates various approaches to code signing PowerShell scripts, from local signing with self-signed certificates to secure enterprise-grade signing using Azure Key Vault. The materials provide a comprehensive walkthrough of both local and cloud-based code signing methods.

## Repository Contents

- **PowerShell Scripts**:
  - `10 Sign Locally.ps1` - Create self-signed certificates and sign scripts locally
  - `20 Setup Azure Keyvault.ps1` - Configure Azure Key Vault and application permissions
  - `30 Sign AzureKeyVault.ps1` - Sign code using a certificate stored in Azure Key Vault
  - `40 Retreiving Keys.ps1` - Security considerations for key management
  - `Test.ps1` - A sample script used to demonstrate signing

- **Tools**:
  - `AzureSignTool.exe` - Tool for signing with certificates stored in Azure Key Vault
  - `signtool.exe` - Windows SDK tool for signing code

- **Assets**:
  - Sample certificates for demonstration purposes

## Prerequisites

- PowerShell 7.x or Windows PowerShell 5.1
- Azure subscription for Key Vault demonstrations
- Windows SDK (for signtool.exe)

## Workflow Steps

### Local Signing

1. Create a self-signed code signing certificate
2. Sign PowerShell scripts using Set-AuthenticodeSignature
3. Export the certificate to a PFX file
4. Sign and verify using signtool.exe

### Azure Key Vault Signing

1. Set up an Azure Key Vault with proper configurations
2. Create an Azure AD application and service principal
3. Configure proper RBAC permissions for the service principal
4. Import a code signing certificate to the Key Vault
5. Sign code using AzureSignTool with the Key Vault certificate
6. Demonstrate security considerations and best practices

## Security Considerations

- Role-based access control (RBAC) configuration for Key Vault access
- Proper credential management for service principals
- Certificate lifecycle management
- The importance of time-stamping signatures

## Getting Started

1. Clone this repository
2. Review the scripts in numerical order
3. Execute the scripts in a test environment (avoid using production Azure resources)
4. Modify the tenant ID and other Azure-specific values to match your environment

## CI/CD Pipeline Integration

This repository complements the [raandreeSamplerTest1](https://github.com/raandree/raandreeSamplerTest1) project, which demonstrates how to implement code signing within an automated release pipeline. The pipeline integration demonstration shows:

- Setting up code signing as part of CI/CD workflows
- Securely accessing certificates in Azure Key Vault during automated builds
- Implementing signing verification as a release gate
- Managing secrets and credentials within pipeline variables
- Ensuring traceability of signed artifacts

The combination of both repositories provides a complete end-to-end solution for code signing, from manual developer workflows to fully automated enterprise pipelines.

## Additional Resources

- [Microsoft Docs: Code Signing in PowerShell](https://learn.microsoft.com/en-us/powershell/scripting/whats-new/module-compatibility)
- [Azure Key Vault Documentation](https://learn.microsoft.com/en-us/azure/key-vault/)
- [AzureSignTool GitHub Repository](https://github.com/vcsjones/AzureSignTool)
- [Windows Signtool Documentation](https://learn.microsoft.com/en-us/windows/win32/seccrypto/signtool)
- [Azure DevOps Pipeline Documentation](https://learn.microsoft.com/en-us/azure/devops/pipelines/)
- [GitHub Actions for PowerShell Module Publishing](https://learn.microsoft.com/en-us/powershell/scripting/gallery/how-to/publishing-to-powershell-gallery)

## Conference Session Information

This repository serves as a demonstration for the "Secure Code Signing for PowerShell: From Local to Enterprise Solutions" session at the PowerShell Summit 2025. The session covers best practices and practical implementations of code signing techniques for PowerShell scripts and modules.
