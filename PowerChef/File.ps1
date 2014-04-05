#
# Name
#   File.ps1
#
# Description
#   This defines functions regarding creating a file.
#   （ファイルの作製に関するファンクションを定義しています。）
#
# Depends
#   .\Log.ps1
#   .\Folder.ps1
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
#   Test-ExistsFile
#
# DESCRIPTION（説明）
#   This function returns a bool value to confirm the presence of the file with the specified path.
#   （指定したパスのファイルの有無を確認し bool 値を返します。）
#
# SYNTAX（構文）
#   Test-ExistsFile [-Path] <string>
#
# PARAMETERS（パラメーター）
#   -Path <string>
#       Specifies the path of file. This parameter is required.
#       （ファイルのパスを指定します。このパラメーターは必須です。）
#
# INPUTS（入力）
#   String
#       This functions inputs the path of file from the incoming pipeline.
#       （パイプライン入力からファイルのパスを入力します。）
#
# OUTPUTS（出力）
#   bool
#       This function returns a bool value to confirm the presence of the file with the specified path.
#       （指定したファイルの有無を確認し bool 値で返します。）
#
function Test-ExistsFile
{
    Param
    (
        [Parameter(Mandatory = $true, Position = 0, ValueFromPipeline = $true)]
        [string]
        [ValidateNotNull()]
        [ValidateScript({Test-Path -Path "$_" -IsValid})]
        $Path
    )

    [bool]$existsFile = $false

    try
    {
        $existsFile = Test-Path -Path "$Path" -PathType "Leaf"
    }
    catch
    {
        Error "Check for the existence of the following file is faild.`n（下記ファイルの有無の確認に失敗しました。`n`n$Path`n`n$Error）"
        return
    }
    return $existsFile
}

#
# NAME（名前）
#   New-File
#
# DESCRIPTION（説明）
#   This function creates a new file the specified path.
#   （指定したパスのファイルを作製します。）
#
# SYNTAX（構文）
#   New-File [-Path] <string> [-Value <string>]
#
# PARAMETERS（パラメーター）
#   -Path <string>
#       Specifies the path of file. This parameter is required.
#       （ファイルのパスを指定します。このパラメーターは必須です。）
#
#   -Value <string>
#       Specifies the content of file. The default value is null charactor.
#       （ファイルの中身を指定します。デフォルト値は空文字です。）
#
# INPUTS（入力）
#   String
#       This functions inputs the path of fil from the incoming pipeline.
#       （パイプライン入力からファイルのパスを入力します。）
#
# OUTPUTS（出力）
#   System.Object
#       This function returns the file that it creates.
#       （作成したファイルをオブジェクトとして返します。）
#
function New-File
{
    Param
    (
        [Parameter(Mandatory = $true, Position = 0, ValueFromPipeline = $true)]
        [string]
        [ValidateNotNull()]
        [ValidateScript({Test-Path -Path "$_" -IsValid})]
        $Path,

        [Parameter(Mandatory = $false, Position = 1)]
        [string]
        $Value = ""
    )

    [string]$parentFolderPath = Split-Path -Path "$Path" -Parent

    if(!(Test-ExistsFolder -Path "$parentFolderPath"))
    {
        New-Folder -Path "$parentFolderPath"
    }

    if(Test-ExistsFile -Path "$Path")
    {
        Warning "The following file already exists.`n（下記ファイルは既に存在します。）`n`n$Path"
        return $(Get-Item -Path "$Path")
    }

    Info "Creating The following file is starting.`n（下記ファイルの作製を開始します。`n`n$Path）"
    try
    {
        New-Item -Path "$Path" -ItemType "File" -Value "$Value"
    }
    catch
    {
        Error "Creating The following file is failed.`n（下記ファイルの作製に失敗しました。）`n`n$Path`n`n$Error"
        return
    }
    Info "Creating The following file has finished successfully.`n（下記ファイルの作製が正常に完了しました。）`n`n$Path`n$(Get-Content -Path $Path -Raw)"
    return $(Get-Item -Path "$Path")
}

#
# NAME（名前）
#   Remove-File
#
# DESCRIPTION（説明）
#   This function removes a file the specified path.
#   （指定したパスのファイルを削除します。）
#
# SYNTAX（構文）
#   Remove-File [-Path] <string>
#
# PARAMETERS（パラメーター）
#   -Path <string>
#       Specifies the path of file. This parameter is required.
#       （ファイルのパスを指定します。このパラメーターは必須です。）
#
# INPUTS（入力）
#   String
#       This functions inputs the path of file from the incoming pipeline.
#       （パイプライン入力からファイルのパスを入力します。）
#
# OUTPUTS（出力）
#       None
#       （なし）
#
function Remove-File
{
    Param
    (
        [Parameter(Mandatory = $true, Position = 0, ValueFromPipeline = $true)]
        [string]
        [ValidateNotNull()]
        [ValidateScript({Test-Path -Path "$_" -IsValid})]
        $Path
    )

    if(!(Test-ExistsFile -Path "$Path"))
    {
        Warning "The following file is not found.`n（下記ファイルが見つかりません。）`n`n$Path"
        return
    }

    Info "Removing the following file is starting.`n（下記ファイルの削除を開始します。）`n`n$Path"
    try
    {
        Remove-Item -Path "$Path"
    }
    catch
    {
        Error "Removing the following file is failed.`n（下記ファイルの削除に失敗しました。）`n`n$Path`n`n$Error"
        return
    }
    Info "Removing the following file has finished successfully.`n（下記ファイルの削除が正常に完了しました。）`n`n$Path"
}

#
# NAME（名前）
#   Download-File
#
# DESCRIPTION（説明）
#   This function download a file from the specified URL.
#   （指定したパスのファイルを作製します。）
#
# SYNTAX（構文）
#   Download-File [-SourceURL] <string> [-DistinationFilePath] <string>
#
# PARAMETERS（パラメーター）
#   -SourceURL <string>
#       Specifies the URL of source. This parameter is required.
#       （ダウンロード元の URL を指定します。このパラメーターは必須です。）
#
#   -DistinationFilePath <string>
#       Specifies the file path of distination. This parameter is required.
#       （ダウンロード先のファイルパスを指定します。このパラメーターは必須です。）
#
# INPUTS（入力）
#   String
#       This functions inputs the URL of source from the incoming pipeline.
#       （パイプライン入力からダウンロード元の URL を入力します。）
#
# OUTPUTS（出力）
#   System.Object
#       This function returns the file that it download.
#       （ダウンロードしたファイルをオブジェクトとして返します。）
#
function Download-File
{
    Param
    (
        [Parameter(Mandatory = $true, Position = 0, ValueFromPipeline = $true)]
        [string]
        [ValidateNotNull()]
        $SourceURL,

        [Parameter(Mandatory = $true, Position = 1)]
        [string]
        [ValidateNotNull()]
        [ValidateScript({Test-Path -Path "$_" -IsValid})]
        $DistinationFilePath
    )

    if(Test-ExistsFile -Path "$DistinationFilePath")
    {
        Warning "The following file already exists. This file is overridden.`n（下記ファイルが既に存在します。このファイルを上書きします。）`n`n$DistinationFilePath"
        Remove-File -Path "$DistinationFilePath"
    }

    Info "Downloading of the following file is starting.`n（下記ファイルのダウンロードを開始します。）`n`nSource URL: $SourceURL`nDistination file path: $DistinationFilePath"
    try
    {
        (New-Object System.Net.WebClient).DownloadFile("$SourceURL", "$DistinationFilePath")
    }
    catch
    {
        Error "Downloading of the following file is failed.`n（下記ファイルのダウンロードに失敗しました。）`n`nSource URL: $SourceURL`nDistination file path: $DistinationFilePath`n`n$Error"
        return
    }
    Info "Downloading of the following file has finished successfully.`n（下記ファイルのダウンロードが正常に完了しました。）`n`nSource URL: $SourceURL`nDistination file path: $DistinationFilePath"
    return $(Get-Item -Path "$DistinationFilePath")
}

#
# NAME（名前）
#   Open-File
#
# DESCRIPTION（説明）
#   This function opens a file the specified path.
#   （指定したパスのファイルを開きます。）
#
# SYNTAX（構文）
#   Open-File [-Path] <string>
#
# PARAMETERS（パラメーター）
#   -Path <string>
#       Specifies the path of file. This parameter is required.
#       （ファイルのパスを指定します。このパラメーターは必須です。）
#
# INPUTS（入力）
#   String
#       This functions inputs the path of file from the incoming pipeline.
#       （パイプライン入力からファイルのパスを入力します。）
#
# OUTPUTS（出力）
#       None
#       （なし）
#
function Open-File
{
    Param
    (
        [Parameter(Mandatory = $true, Position = 0, ValueFromPipeline = $true)]
        [string]
        [ValidateNotNull()]
        [ValidateScript({Test-Path -Path "$_" -IsValid})]
        $Path
    )

    if(!(Test-ExistsFile -Path "$Path"))
    {
        Error "The following file is not found.`n（下記ファイルが見つかりません。）`n`n$Path"
        return
    }

    Info "Opening of the following file is starting.`n（下記ファイルを開きます。）`n`n$Path"
    try
    {
        Invoke-Item -Path "$Path"
    }
    catch
    {
        Error "Opening of the following file is failed.`n（下記ファイルのオープンに失敗しました。）`n`n$Path`n`n$Error"
        return
    }
    Info "Opening of the following file has finished successfully.`n（下記ファイルを正常に開きました。）`n`n$Path"
}

# SIG # Begin signature block
# MIIFcAYJKoZIhvcNAQcCoIIFYTCCBV0CAQExCzAJBgUrDgMCGgUAMGkGCisGAQQB
# gjcCAQSgWzBZMDQGCisGAQQBgjcCAR4wJgIDAQAABBAfzDtgWUsITrck0sYpfvNR
# AgEAAgEAAgEAAgEAAgEAMCEwCQYFKw4DAhoFAAQUvNNAAXNoBLC3MsYza8lY7BtC
# cdKgggMaMIIDFjCCAgKgAwIBAgIQliVLy3mu8q1LSkdDsNdvkzAJBgUrDgMCHQUA
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
# BgorBgEEAYI3AgELMQ4wDAYKKwYBBAGCNwIBFTAjBgkqhkiG9w0BCQQxFgQU8MCn
# jVZWJdvJPSudOwsTXNkpyWswDQYJKoZIhvcNAQEBBQAEggEAx5DP3HR49/Gdbo4H
# NG6uPYAW0Ahn2TrisZpaXgS7bqNb3XO+VpJC/iXg6XY2waBH1Mcz8cchM4roz04b
# txOGHUOMOGgAjesXJsdlThNYzNpl2eGInvN4cNtkf1N28ZfbrWsf5l9Ekem2/Ol7
# dX5aDHwtYZuLesRBb+ogWsq0eyvhTtt9imSmfpS7rvZw5nG8QvzbeRlgT04Z1cZb
# uD/ETsOnNUgOY065sgdmtg8NUFr1oV4TmFUtGSp8z679vrw2ZRk1lZEFNqlTbI89
# Hce9nwSYYiT0duWs3NPRP3T+IvcZMBpYGuOjrphaLE8YEnKq/f58AgTmlK1QA/AG
# z66m2w==
# SIG # End signature block
