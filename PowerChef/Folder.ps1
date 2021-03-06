﻿#
# Name
#   Folder.ps1
#
# Description
#   This defines functions regarding creating a folder.
#   （フォルダーの作製に関するファンクションを定義しています。）
#
# Depends
#   .\Log.ps1
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
# NAME（名前）
#   Test-ExistsFolder
#
# DESCRIPTION（説明）
#   This function returns a bool value to confirm the presence of the folder with the specified path.
#   （指定したパスのフォルダーの有無を確認し bool 値を返します。）
#
# SYNTAX（構文）
#   Test-ExistsFolder [-Path] <string>
#
# PARAMETERS（パラメーター）
#   -Path <string>
#       Specifies the path of folder. This parameter is required.
#       （フォルダーのパスを指定します。このパラメーターは必須です。）
#
# INPUTS（入力）
#   String
#       This functions inputs the path of folder from the incoming pipeline.
#       （パイプライン入力からフォルダーのパスを入力します。）
#
# OUTPUTS（出力）
#   bool
#       Test-ExistsFile returns a bool value to confirm the presence of the folder with the specified path.
#       （指定したフォルダーの有無を確認し bool 値で返します。）
#
function Test-ExistsFolder
{
    Param
    (
        [Parameter(Mandatory = $true, Position = 0, ValueFromPipeline = $true)]
        [string]
        [ValidateNotNull()]
        [ValidateScript({Test-Path -Path "$_" -IsValid})]
        $Path
    )

    [bool]$existsFolder = $false

    try
    {
        $existsFolder = Test-Path -Path "$Path" -PathType "Container"
    }
    catch
    {
        Error "The Check for existence of the following folder is failed`n（下記フォルダーの有無の確認に失敗しました。）`n`n$Path`n$Error"
        return
    }
    return $existsFolder
}

#
# NAME（名前）
#   New-Folder
#
# DESCRIPTION（説明）
#   This function creates a new folder the specified path.
#   （指定したパスのフォルダーを作製します。）
#
# SYNTAX（構文）
#   New-Folder [-Path] <string>
#
# PARAMETERS（パラメーター）
#   -Path <string>
#       Specifies the path of folder. This parameter is required.
#       （フォルダーのパスを指定します。このパラメーターは必須です。）
#
# INPUTS（入力）
#   String
#       This functions inputs the path of folder from the incoming pipeline.
#       （パイプライン入力からフォルダーのパスを入力します。）
#
# OUTPUTS（出力）
#   System.Object
#       This function returns the folder that it creates.
#       （作成したフォルダーをオブジェクトとして返します。）
#
function New-Folder
{
    Param
    (
        [Parameter(Mandatory = $true, Position = 0, ValueFromPipeline = $true)]
        [string]
        [ValidateNotNull()]
        [ValidateScript({Test-Path -Path "$_" -IsValid})]
        $Path
    )

    if(Test-ExistsFolder -Path "$Path")
    {
        Warning "The following folder already exists.`n（下記フォルダーは既に存在します。）`n`n$Path"
        return $(Get-Item -Path "$Path")
    }

    Info "Creating The following folder is starting.`n（下記フォルダーの作製を開始します。）`n`n$Path"
    try
    {
        New-Item -Path "$Path" -ItemType "Directory"
    }
    catch
    {
        Error "Creating The following folder is failed.`n（下記フォルダーの作製に失敗しました。）`n`n$Path`n`n$Error"
        return
    }
    Info "Creating The following folder has finished successfully.`n（下記フォルダーの作製が正常に完了しました。）`n`n$Path"
    return $(Get-Item -Path "$Path")
}

#
# NAME（名前）
#   Remove-Folder
#
# DESCRIPTION（説明）
#   This function removes a folder the specified path.
#   （指定したパスのフォルダーを削除します。）
#
# SYNTAX（構文）
#   Remove-Folder [-Path] <string>
#
# PARAMETERS（パラメーター）
#   -Path <string>
#       Specifies the path of folder. This parameter is required.
#       （フォルダーのパスを指定します。このパラメーターは必須です。）
#
# INPUTS（入力）
#   String
#       This functions inputs the path of folder from the incoming pipeline.
#       （パイプライン入力からフォルダーのパスを入力します。）
#
# OUTPUTS（出力）
#       None
#       （なし）
#
function Remove-Folder
{
    Param
    (
        [Parameter(Mandatory = $true, Position = 0, ValueFromPipeline = $true)]
        [string]
        [ValidateNotNull()]
        [ValidateScript({Test-Path -Path "$_" -IsValid})]
        $Path
    )

    if(!(Test-ExistsFolder -Path "$Path"))
    {
        Warning "The following folder is not found.`n（下記フォルダーが見つかりません。）`n`n$Path"
        return
    }

    Info "Removing the following folder is starting.`n（下記フォルダーの削除を開始します。）`n`n$Path"
    try
    {
        Remove-Item -Path "$Path" -Recurse
    }
    catch
    {
        Error "Removing the following folder is failed.`n（下記フォルダーの削除に失敗しました。）`n`n$Path`n`n$Error"
        return
    }
    Info "Removing the following folder has finished successfully.`n（下記フォルダーの削除が正常に完了しました。）`n`n$Path"
}

# SIG # Begin signature block
# MIIFcAYJKoZIhvcNAQcCoIIFYTCCBV0CAQExCzAJBgUrDgMCGgUAMGkGCisGAQQB
# gjcCAQSgWzBZMDQGCisGAQQBgjcCAR4wJgIDAQAABBAfzDtgWUsITrck0sYpfvNR
# AgEAAgEAAgEAAgEAAgEAMCEwCQYFKw4DAhoFAAQUri0lrnSpCuisGURruL+mNS1L
# 2NygggMaMIIDFjCCAgKgAwIBAgIQliVLy3mu8q1LSkdDsNdvkzAJBgUrDgMCHQUA
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
# BgorBgEEAYI3AgELMQ4wDAYKKwYBBAGCNwIBFTAjBgkqhkiG9w0BCQQxFgQUpLfG
# lbHNx63zvPidM+rCkIr7yOYwDQYJKoZIhvcNAQEBBQAEggEAiTjMWkr1dyxLGiPm
# DGw2HnLcmX3LZtOwFXKb1dP6/M3mzUy8i9v94KWPAz6HQCO6f8fEM0y84mmIwY++
# WlE9jIOM8zoBpy8qMKHbhX3aOdNgBeCCCVivYA+MRWmRW/y8DGjtGpr/gCQiQ6I4
# N5D7GPY5pE75HOGPJaZ4vwwY0ZsiQG8/U+82QeIXTcEEpiliG8dSH0d+9vN+caIr
# Qborahoi8NAkOKlWwkFw10EyiTFd+7/qpDyoqrA1LkDYFRicI9KHsChgLAVLeEEj
# m/9nXceFHnPcWdRrlQpCWESJmZKKvM58EHSx/7gUCQJjl3VBDoSWR0I+waK+4gKH
# O6KKAw==
# SIG # End signature block