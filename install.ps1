#
# Name
#     install.ps1
#
# Description
#     This is install script of "PowerChef".
#     （"PowerChef" のインストールスクリプトです。）
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

Param
(
    [Parameter(Mandatory = $false, Position = 0, ValueFromPipeline = $true)]
    [string]
    [ValidateNotNull()]
    $Branch = "master"
)

[string]$SourceURL = "https://raw.github.com/kukita/PowerChef/${Branch}/PowerChef"
[string]$PowerChefFolderPath = [Environment]::GetFolderPath("MyDocuments") + "\WindowsPowerShell\Modules\PowerChef"
$webClient = New-Object System.Net.WebClient

if(Test-Path -Path "$PowerChefFolderPath")
{
    Remove-Item -Path "$PowerChefFolderPath" -Recurse -Force
}

Write-Host -Object "[$(Get-Date -Format 'yyyy/MM/dd HH:mm:ss')] Installation of 'PowerChef' is Starting."
try
{
    New-Item -Path "$PowerChefFolderPath" -ItemType "Directory"
    $webClient.DownloadFile("$SourceURL\PowerChef.psd1", "$PowerChefFolderPath\PowerChef.psd1")
    $webClient.DownloadFile("$SourceURL\PowerChef.psm1", "$PowerChefFolderPath\PowerChef.psm1")
    $webClient.DownloadFile("$SourceURL\Log.ps1", "$PowerChefFolderPath\Log.ps1")
    $webClient.DownloadFile("$SourceURL\Folder.ps1", "$PowerChefFolderPath\Folder.ps1")
    $webClient.DownloadFile("$SourceURL\File.ps1", "$PowerChefFolderPath\File.ps1")
    $webClient.DownloadFile("$SourceURL\Execute.ps1", "$PowerChefFolderPath\Execute.ps1")
    $webClient.DownloadFile("$SourceURL\Env.ps1", "$PowerChefFolderPath\Env.ps1")
    $webClient.DownloadFile("$SourceURL\MSIPackage.ps1", "$PowerChefFolderPath\MSIPackage.ps1")
    $webClient.DownloadFile("$SourceURL\Chocolatey.ps1", "$PowerChefFolderPath\Chocolatey.ps1")
    $webClient.DownloadFile("$SourceURL\VirtualBox.ps1", "$PowerChefFolderPath\VirtualBox.ps1")
    $webClient.DownloadFile("$SourceURL\Git.ps1", "$PowerChefFolderPath\Git.ps1")
    $webClient.DownloadFile("$SourceURL\Chef.ps1", "$PowerChefFolderPath\Chef.ps1")
    $webClient.DownloadFile("$SourceURL\Serverspec.ps1", "$PowerChefFolderPath\Serverspec.ps1")
    $webClient.DownloadFile("$SourceURL\Bento.ps1", "$PowerChefFolderPath\Bento.ps1")
    $webClient.DownloadFile("$SourceURL\Vagrant.ps1", "$PowerChefFolderPath\Vagrant.ps1")
    $webClient.DownloadFile("$SourceURL\Berkshelf.ps1", "$PowerChefFolderPath\Berkshelf.ps1")
    $webClient.DownloadFile("$SourceURL\ChefWorkstation.ps1", "$PowerChefFolderPath\ChefWorkstation.ps1")
    $webClient.DownloadFile("$SourceURL\ChefRepo.ps1", "$PowerChefFolderPath\ChefRepo.ps1")
    $webClient.DownloadFile("$SourceURL\Cookbook.ps1", "$PowerChefFolderPath\Cookbook.ps1")
    $webClient.DownloadFile("$SourceURL\ChefNode.ps1", "$PowerChefFolderPath\ChefNode.ps1")
    Import-Module -Name "PowerChef"
}
catch
{
    Write-Error -Message "[$(Get-Date -Format 'yyyy/MM/dd HH:mm:ss')] Installation of 'PowerChef' is failed."
}
Write-Host -Object "[$(Get-Date -Format 'yyyy/MM/dd HH:mm:ss')] Installation of 'PowerChef' has finished successfully."

# SIG # Begin signature block
# MIIFcAYJKoZIhvcNAQcCoIIFYTCCBV0CAQExCzAJBgUrDgMCGgUAMGkGCisGAQQB
# gjcCAQSgWzBZMDQGCisGAQQBgjcCAR4wJgIDAQAABBAfzDtgWUsITrck0sYpfvNR
# AgEAAgEAAgEAAgEAAgEAMCEwCQYFKw4DAhoFAAQU6rMvQtwXtMh3txXElytezcFS
# ayigggMaMIIDFjCCAgKgAwIBAgIQliVLy3mu8q1LSkdDsNdvkzAJBgUrDgMCHQUA
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
# BgorBgEEAYI3AgELMQ4wDAYKKwYBBAGCNwIBFTAjBgkqhkiG9w0BCQQxFgQUFazo
# 2W7f0d4S8awi6lseRvV12TgwDQYJKoZIhvcNAQEBBQAEggEApm8TCOodEzltSCbj
# UP9RKq41eZ6Uf6Tqug4mO9drQrH8deC/syVuQwOOp7W1cCX936FA7DVgv7U3mNeJ
# t6DjClFILHJMzQHN9bFUQ1+doNI/A4PXYwR7Khz0HiklqMxMnew5YUHnodQ0nNDs
# OOMcrjUC6cLj4m50Q02Za7TBGU8EtkcsH8Fxsk4JOcjhKyJzB3E2aOd8d8J4ChUS
# SSYVN1thO7PkgLU61gixV42vUsWyKODwhmlhP2ARZ36jDFeM4GbNtemd7ULiMK96
# DczimvNT6QYMQjaZDJEbHbhm/OH28mHp3iZj76loqq4XtyNooxnQyCBwT76S3oA2
# /9eVvw==
# SIG # End signature block
