#
# Name
#   Git.ps1
#
# Description
#   This defines functions regarding 'Git'.
#   （'Git' に関するファンクションを定義しています。）
#
# Depends
#   .\Log.ps1
#   .\Folder.ps1
#   .\Execute.ps1
#   .\Env.ps1
#   .\Chocolatey.ps1
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
# This function installs 'Git' and 'posh-git'.
# （'Git' と 'posh-git' をインストールします。）
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
# Install-Git
#
#.LINK
# Update-Git
#
function Install-Git
{
    if(!(Get-Content -Path "$PROFILE" | Select-String -Pattern "PATH.*Git" -Quiet))
    {
        Add-Env -KeyName "PATH" -Value "`$env:Programfiles\Git\bin\"
		Add-Env -KeyName "PATH" -Value "`${env:Programfiles(x86)}\Git\bin\"
    }

    Install-ChocolateyPackage -PackageName "Git"
    Install-ChocolateyPackage -PackageName "poshgit"
    Invoke-Execute "git.exe" config "--global" core.quotepath false
    Invoke-Execute "git.exe" config "--global" core.autoCRLF false
    Invoke-Execute "git.exe" config "--global" gui.encoding "utf-8"
    Invoke-Execute "git.exe" config "--global" coloer.ui true
}

#
#.SYNOPSIS
# This function updates 'Git' and 'posh-git'.
# （'Git' と 'posh-git' をアップデートします。）
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
# Install-Git
#
#.LINK
# Update-Git
#
function Update-Git
{
    Update-ChocolateyPackage -PackageName "Git"
    Update-ChocolateyPackage -PackageName "poshgit"
}

#
# NAME（名前）
#   Sync-GitRepository
#
# DESCRIPTION（説明）
#   This function execute `git clone`.
#   （`git clone` を実行します。）
#
# SYNTAX（構文）
#   Sync-GitRepository [-RepositoryURL] <string> [-DistinationFolderPath] <string>
#
# PARAMETERS（パラメーター）
#   -RepositoryURL <string>
#       Specifies the URL of repository. This parameter is required.
#       （リポジトリの URL を指定します。このパラメーターは必須です。）
#
#   -DistinationFolderPath <string>
#       Specifies the path of distination folder. This parameter is required.
#       （同期先フォルダーのパスを指定します。このパラメーターは必須です。）
#
# INPUTS（入力）
#   String
#       This functions inputs the URL of repository from the incoming pipeline.
#       （パイプライン入力からリポジトリの URL を入力します。）
#
# OUTPUTS（出力）
#       None
#       （なし）
#
function Sync-GitRepository
{
    Param
    (
        [Parameter(Mandatory = $true, Position = 0, ValueFromPipeline = $true)]
        [string]
        [ValidateNotNull()]
        $RepositoryURL,

        [Parameter(Mandatory = $true, Position = 1)]
        [string]
        [ValidateNotNull()]
        [ValidateScript({Test-Path -Path "$_" -IsValid})]
        $DistinationFolderPath
    )

    if(!(Test-IsExistFolder -Path "$DistinationFolderPath"))
    {
        Error "The following folder is not found.`n（下記フォルダーが見つかりません。）`n`n$DistinationFolderPath"
        return
    }

    Info "Syncing from the following repository to the following folder is starting.`n（下記レポジトリから下記フォルダーへの同期を開始します。）`n`nRepository URL: $RepositoryURL`nDistination folder path: DistinationFolderPath"
    Push-Location
    Set-Location -Path "$DistinationFolderPath"
    Invoke-Execute "git.exe" clone "$RepositoryURL"
    Pop-Location
    info "Syncing from the following repository to the following folder has finished.`n（下記レポジトリから下記フォルダーへの同期が完了しました。）`n`nRepository URL: $RepositoryURL`nDistination folder path: DistinationFolderPath"
    Get-ChildItem -Path "$DistinationFolderPath"
}

# SIG # Begin signature block
# MIIFcAYJKoZIhvcNAQcCoIIFYTCCBV0CAQExCzAJBgUrDgMCGgUAMGkGCisGAQQB
# gjcCAQSgWzBZMDQGCisGAQQBgjcCAR4wJgIDAQAABBAfzDtgWUsITrck0sYpfvNR
# AgEAAgEAAgEAAgEAAgEAMCEwCQYFKw4DAhoFAAQUtZk0O1zxK1iHdC1kFm4BDZU4
# Wt6gggMaMIIDFjCCAgKgAwIBAgIQliVLy3mu8q1LSkdDsNdvkzAJBgUrDgMCHQUA
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
# BgorBgEEAYI3AgELMQ4wDAYKKwYBBAGCNwIBFTAjBgkqhkiG9w0BCQQxFgQU3P+O
# LBKSkIkxhegXxNveKG0iseQwDQYJKoZIhvcNAQEBBQAEggEAZtax00pDgjdE1LN3
# WbETiuuSkJAvhnjQWy6+I8j8KWvUvCNjxA0UNZvMsEL9azJfhuUpfYCuGVEsF39c
# 72FABcwRNiKesMVAnlBSUPYXrb5sN605Mv0/d+aEgQES+mPtwj5C6u3wWBg4EMKj
# yxnSbYPwY/2g8dI+X28GluDN8qMZumZQ1a8Fg5qOsCcgPUK36w/bqyck/gaHM3XC
# xh/NZLTWKLyQH+HsxIAnfSrMypV32K1LEQrJQ241e1ncCeRfFu58d9QdDLlCloIY
# AC+d2/5bQXTi30FEJAywatnqUMDS2GsCfdV40SEwaQWJv/Q9iS4/9PaNUueGsCAT
# uFH+NA==
# SIG # End signature block
