#
# Name
#     PowerChef.psm1
#
# Description
#     'PowerChef' is a module of PowerShell to support the development in the Windows environment used the 'chef'.
#     （'PowerChef' は 'Chef' を使用した Windows 環境での開発をサポートするための PowerShell のモジュールです。）
#
# Copyright (C) 2014 Keisuke Kukita
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

if(Get-Module -Name PowerChef)
{
    return
}

Push-Location
[string]$PowerChefFolderPath = [Environment]::GetFolderPath("MyDocuments") + "\WindowsPowerShell\Modules\PowerChef"
Set-Location -Path "$PowerChefFolderPath"
. .\Log.ps1
. .\Folder.ps1
. .\File.ps1
. .\Execute.ps1
. .\Env.ps1
. .\MSIPackage.ps1
. .\Chocolatey.ps1
. .\VirtualBox.ps1
. .\Git.ps1
. .\Chef.ps1
. .\Serverspec.ps1
. .\Bento.ps1
. .\Vagrant.ps1
. .\Berkshelf.ps1
. .\ChefWorkstation.ps1
. .\ChefRepo.ps1
. .\Cookbook.ps1
. .\ChefNode.ps1
Pop-Location

Export-ModuleMember `
        -Alias @(
                "SetUp-ChefWorkstation",
                "Upload-Cookbook",
                "Create-ChefNode",
                "SetUp-ChefNode",
                "Converge-ChefNode",
                "Verify-ChefNode") `
        -Function @(
                "Install-ChefWorkstation",
                "Install-Chocolatey",
                "Install-VirtualBox",
                "Install-Git",
                "Install-Chef",
                "Install-Serverspec",
                "Install-Bento",
                "Install-Vagrant",
                "Install-Berkshelf",
                "Update-ChefWorkstation",
                "Update-Chocolatey",
                "Update-VirtualBox",
                "Update-Git",
                "Update-Chef",
                "Update-Serverspec",
                "Update-Bento",
                "Update-Vagrant",
                "Update-Berkshelf",
                "Open-HomeVagrantfile",
                "Show-VeeweeDefinitionVboxList",
                "Invoke-VeeweeVboxBuild",
                "New-VagrantBox",
                "New-ChefRepo",
                "Show-ChefRepoList",
                "Get-ChefRepoPath",
                "New-Cookbook",
                "Show-CookbookList",
                "Open-CookbookMetadata",
                "Open-CookbookReadme",
                "New-CookbookRecipe",
                "Open-CookbookRecipe",
                "New-ChefZeroACL",
                "Start-ChefZero",
                "Update-Cookbook",
                "New-ChefNodeSpecFile",
                "New-ChefNode",
                "Show-ChefNodeList",
                "Open-ChefNodeVagrantfile",
                "Open-ChefNodeSpecFile",
                "Show-ChefNodeStatus",
                "Install-ChefNode",
                "Update-ChefNode",
                "Test-ChefNode",
                "Start-ChefNode",
                "Stop-ChefNode",
                "Remove-ChefNode")

[string]$moduleName = Split-Path -Path "$(Split-Path -Path $MyInvocation.MyCommand.Path -Parent)" -Leaf
New-EventLogSource -Name "$script:moduleName"

# SIG # Begin signature block
# MIIFcAYJKoZIhvcNAQcCoIIFYTCCBV0CAQExCzAJBgUrDgMCGgUAMGkGCisGAQQB
# gjcCAQSgWzBZMDQGCisGAQQBgjcCAR4wJgIDAQAABBAfzDtgWUsITrck0sYpfvNR
# AgEAAgEAAgEAAgEAAgEAMCEwCQYFKw4DAhoFAAQUWQdV3lDmB6VIhIbocJDTwcc/
# PcegggMaMIIDFjCCAgKgAwIBAgIQliVLy3mu8q1LSkdDsNdvkzAJBgUrDgMCHQUA
# MBMxETAPBgNVBAMTCEt1a2l0YUNBMB4XDTEzMTIzMTE1MDAwMFoXDTI0MTIzMDE1
# MDAwMFowEzERMA8GA1UEAxMIS3VraXRhQ0EwggEiMA0GCSqGSIb3DQEBAQUAA4IB
# DwAwggEKAoIBAQDIf6ysnGVdR2AWTeY+1nqz4ikXOtwK3hKCsUbmqUqL4Gdarybh
# EslueBtU1gErl/ttVsdi2ID0s6jWHNTiO4o8IZfsoXpb55ziKEhV5ksfR4TINcby
# NUH2+Iz5XjQOwOTTAQzDoE6nBCFO5wUgT/HHu6BIhdwd0R09drCn8tV/WEllgeVG
# VJk3d6WaoyqFZ2qux542+W/iwEK97pOcXxFzh/uiRJs4QuCM4UE+iZrpHmHaEZt/
# iucIIJiB+dxnLMmm1QbdxWV6rnvQeIOB5jcZvX0iKlR93L0d3TzvxaNlwz4/Cjy9
# TAhwTyXClqKTG9EY43MbLeOY5TBAqA3U4E4HAgMBAAGjbjBsMA8GA1UdEwEB/wQF
# MAMBAf8wEwYDVR0lBAwwCgYIKwYBBQUHAwMwRAYDVR0BBD0wO4AQki7y8P8fF1L1
# kk+OW2TYcKEVMBMxETAPBgNVBAMTCEt1a2l0YUNBghCWJUvLea7yrUtKR0Ow12+T
# MAkGBSsOAwIdBQADggEBAK97X6ieQyvUWRDdq7xuRokivGdwP4THLFcW4xvtaoll
# B5N9vJLgWOLaHFnQKr8Y24UtCB9hXiX2lbllUaghIk8oHTu/g4M14+39J1q9srhU
# lqxUEq3qIxNr+XhYtF+PqjX/6M3Yt3oPdkzBmc/Gq/HNcNyp83P4t7qE950JSFDh
# 4i0lcUQ8WZx5eNXh4uFiF0A4ChTsCIdUwxz0d6rGY8MFup6X+mKq/4DNqtbV5jIs
# x97njFfykkHIu4K+y7USnFLwGxkI4rvMj1CZS5rvS3GWn8f9YI7bp5AiXluNA+jt
# BtIfah+r9bhKUBZPlqd8Glzb/4wH/ImbnmNQYeBUrg4xggHAMIIBvAIBATAnMBMx
# ETAPBgNVBAMTCEt1a2l0YUNBAhCWJUvLea7yrUtKR0Ow12+TMAkGBSsOAwIaBQCg
# cDAQBgorBgEEAYI3AgEMMQIwADAZBgkqhkiG9w0BCQMxDAYKKwYBBAGCNwIBBDAc
# BgorBgEEAYI3AgELMQ4wDAYKKwYBBAGCNwIBFTAjBgkqhkiG9w0BCQQxFgQUSbab
# TdoyQk7xxWUouHDvTuZ1CFUwDQYJKoZIhvcNAQEBBQAEggEAn5uJCeAzVtqatkWS
# Akb/7CN3wCfdIldeRi8b1JwFIizAxgz0ygyPQ0fIMRBFXxNegWJUKX8pvTpD93ZI
# yAcOL4hO0TPthMEhcuemwlCZpDJXa7bNwbbZO4GZYjzvpoPEpRlGaiiM6AVimz4a
# 6HLiQKFZlng1v5UX/QLQcRyss7YcQcy/R4Hfaf6J4JtcaX5A6GeeKZuTK95CcNjU
# yT8NQmX0Bl+TQtXyiwBy+KiMnwXUMM/VyHxgllB3Q/l0nzsMfYI/4t9yhfPKjrrl
# REuUFnoDaxCkImIs5IzRKgZwW2wS1LcBF1cTgtfDT41gbyvQ4ie0tTlWBodUo1SF
# VYCAdw==
# SIG # End signature block
