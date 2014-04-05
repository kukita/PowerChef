#
# Name
#   ChefWorkStation.ps1
#
# Description
#   This defines functions regarding 'Chef Workstation'.
#   （'Chef Workstation' に関するファンクションを定義しています。）
#
# Depends
#   .\Log.ps1
#   .\Env.ps1
#   .\Vagrant.ps1
#   .\Chocolatey.ps1
#   .\VirtualBox.ps1
#   .\Git.ps1
#   .\Chef.ps1
#   .\Serverspec.ps1
#   .\Vagrant.ps1
#   .\Berkshelf.ps1
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

#
#.SYNOPSIS
#   This function sets up the local machine as 'Chef Workstation'.
#   （ローカルマシンを 'Chef Workstation' としてセットアップします。）
#
#.DESCRIPTION
#   None
#   （なし）
#
#.PARAMETER PowerChefHomePath
# Specifies the key value of the environment attribute named POWERCHEF_USER_HOME. Default value is '$env:HOMEDRIVE\PowerChef'.
# （環境変数 POWERCHEF_HOME の値を指定します。デフォルト値は '$env:HOMEDRIVE\PowerChef' です。）
#
#.INPUTS
#   None
#   （なし）
#
#.OUTPUTS
#   None
#   （なし）
#
#.NOTES
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
#.LINK
# Install-Chocolatey
#
#.LINK
# Install-VirtualBox
#
#.LINK
# Install-Git
#
#.LINK
# Install-Chef
#
#.LINK
# Install-Serverspec
#
#.LINK
# Install-Bento
#
#.LINK
# Install-Vagrant
#
#.LINK
# Install-Berkshelf
#
#.LINK
# Update-ChefWorkstation
#
function Install-ChefWorkstation
{
    Param
    (
        [Parameter(Mandatory = $false, Position = 0)]
        [string]
        [ValidateNotNull()]
        [ValidateScript({Test-Path -Path "$_" -IsValid})]
        $PowerChefHomePath = "$env:HOMEDRIVE\PowerChef"
    )

    Info "Setting up of 'Chef Workstation' is starting.`n（'Chef Workstation' のセットアップを開始します。）"
    New-Env -KeyName "POWERCHEF_HOME" -Value "$PowerChefHomePath"
    
    if(!(Test-ExistsFolder -Path "$PowerChefHomePath"))
    {
        Info "Creating The following folder is starting.`n（下記フォルダーの作製を開始します。）`n`n$PowerChefHomePath"
        try
        {
            New-Item -Path "$PowerChefHomePath" -ItemType "Directory"
        }
        catch
        {
            Error "Creating The following folder is failed.`n（下記フォルダーの作製に失敗しました。）`n`n$PowerChefHomePath`n`n$Error"
            return
        }
        Info "Creating The following folder has finished successfully.`n（下記フォルダーの作製が正常に完了しました。）`n`n$PowerChefHomePath"
    }

    Install-Chocolatey
    Install-VirtualBox
    Install-Git
    Install-Chef
    Install-Serverspec
    Install-Bento
    Install-Vagrant
    Install-Berkshelf
    New-Folder -Path "$env:POWERCHEF_HOME\chef-repositories"
    Info "Execution of the following command is starting.`n（下記コマンドを実行します。）`n`nSet-Item -Path 'WSMan:\localhost\Client\TrustedHosts' -Value '*'"
    try
    {
        Set-Item -Path "WSMan:\localhost\Client\TrustedHosts" -Value "*"
    }
    catch
    {
        Error "Execution of the following command is failed.`n（下記コマンドの実行に失敗しました。）`n`nSet-Item -Path 'WSMan:\localhost\Client\TrustedHosts' -Value '*'`n`n$Error"
        return
    }
    Info "Execution of the following command has finished successfully.`n（下記コマンドの実行が正常に完了しました。）`n`nSet-Item -Path 'WSMan:\localhost\Client\TrustedHosts' -Value '*'"
    Info "Setting up of 'Chef Workstation' has finished.`n（'Chef Workstation' のセットアップが完了しました。）"
}

Set-Alias -Name "SetUp-ChefWorkstation" -Value "Install-ChefWorkstation"

#
#.SYNOPSIS
#   This function updates the 'Chef Workstation'.
#   （'Chef Workstation' をアップデートします。）
#
#.DESCRIPTION
#   None
#   （なし）
#
#.INPUTS
#   None
#   （なし）
#
#.OUTPUTS
#   None
#   （なし）
#
#.NOTES
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
#.LINK
# Update-Chocolatey
#
#.LINK
# Update-VirtualBox
#
#.LINK
# Update-Git
#
#.LINK
# Update-Chef
#
#.LINK
# Update-Serverspec
#
#.LINK
# Update-Bento
#
#.LINK
# Update-Vagrant
#
#.LINK
# Update-Berkshelf
#
#.LINK
# Install-ChefWorkstation
#
function Update-ChefWorkstation
{

    if(!(Test-ExistsEnv -KeyName "POWERCHEF_HOME"))
    {
        Error "The environment attribute named POWERCHEF_HOME is not set.`n（環境変数 POWERCHEF_HOME が設定されていません。）"
        return
    }

    Info "Update of 'Chef Workstation' is starting.`n（'Chef Workstation' のアップデートを開始します。）"
    Update-Chocolatey
    Update-VirtualBox
    Update-Git
    Update-Chef
    Update-Serverspec
    Update-Bento
    Update-Vagrant
    Update-Berkshelf
    Info "Update of 'Chef Workstation' has finished.`n（'Chef Workstation' のアップデートが完了しました。）"
}

# SIG # Begin signature block
# MIIFcAYJKoZIhvcNAQcCoIIFYTCCBV0CAQExCzAJBgUrDgMCGgUAMGkGCisGAQQB
# gjcCAQSgWzBZMDQGCisGAQQBgjcCAR4wJgIDAQAABBAfzDtgWUsITrck0sYpfvNR
# AgEAAgEAAgEAAgEAAgEAMCEwCQYFKw4DAhoFAAQUmphveBiTh/XmKxREBtB1dHL1
# JE+gggMaMIIDFjCCAgKgAwIBAgIQliVLy3mu8q1LSkdDsNdvkzAJBgUrDgMCHQUA
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
# BgorBgEEAYI3AgELMQ4wDAYKKwYBBAGCNwIBFTAjBgkqhkiG9w0BCQQxFgQUVUZA
# 5rNyBLc2FfyQzrgF8ETRakkwDQYJKoZIhvcNAQEBBQAEggEAiUK19Sn9iQDldAcX
# Rz0++U1IC9iwuG3coTTSDEB1bF1G4+pWwSOxd1lhw+34sNOh8mo9yqAd1naZsNhU
# Uzv48VkotkuvVSB1Bn+f0Eik7cqWSiXrZc+1En8M/eBkqG407s3lP1i6YWj762/k
# ItmggoStOC621jJcGXygVl8l9167202jO1Nz2UGM/eOhA1WaOivVxU/9eejuwMQM
# gSAAdKmtm8HGmdF9MLaWtpP4H4dADIZwacJuW0VN13noHwRsygCISlo45MNLAnsZ
# yH0R5zW8wb3TanA2e7DEGfTwxT28h09FjLp05zIkvD0pByDqFuRHcJ5u+03QJiuN
# Oxn0tA==
# SIG # End signature block
