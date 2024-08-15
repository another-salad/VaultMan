
Import-Module Microsoft.PowerShell.SecretManagement
Import-Module Microsoft.PowerShell.SecretStore

## Secret vault fun
# https://learn.microsoft.com/en-us/powershell/utility-modules/secretmanagement/get-started/using-secretstore?view=ps-modules

Function Set-VaultManNonInteractiveVault {
    [CmdletBinding()]
    param (
        [string]$VaultName
    )
    # You can't set some vaults to be non-interactive and some to be interactive. It's all or nothing.
    # If you want an interactive vault, simply run, Set-VaultManVault.
    # Even in this non-interactive mode, you'll need to set an initial password, once the config is complete you won't be
    # prompted for this again.
    Write-Warning "This will set ALL VAULTS to non-interactive, no authentication mode. Think about this wisely."
    Set-SecretStoreConfiguration -Interaction None -Authentication None -Scope CurrentUser
    Set-VaultManVault -vaultName $VaultName
}

Function Set-VaultManVault {
    [CmdletBinding()]
    param (
        [string]$VaultName
    )
    Register-SecretVault -Name $VaultName -ModuleName Microsoft.PowerShell.SecretStore
    Get-SecretVault -Name $VaultName
}

Function Set-VaultManSecureStringToVault {
    [CmdletBinding()]
    param (
        [string]$SecretName,
        [string]$VaultName,
        [securestring]$SecretValue
    )
    Set-Secret -Name $SecretName -Secret $SecretValue -Vault $VaultName
}

Function Set-VaultManSecureStringToVaultInteractive {
    [CmdletBinding()]
    param (
        [string]$SecretName,
        [string]$VaultName
    )
    $SecretValue = Read-Host -Prompt "Enter secret value" -AsSecureString
    Set-VaultManSecureStringToVault -SecretName $SecretName -VaultName $VaultName -SecretValue $SecretValue
}

Function Get-VaultManSecureStringFromVault {
    [CmdletBinding()]
    param (
        [string]$SecretName,
        [string]$VaultName,
        [switch]$AsPlainText
    )
    $secret = Get-Secret -Name $SecretName -Vault $VaultName
    if ($AsPlainText) {
        $secret = $secret | ConvertFrom-SecureString -AsPlainText
    }
    $Secret
}
