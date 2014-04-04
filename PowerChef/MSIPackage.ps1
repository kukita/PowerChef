#
# Name
#   MSIPackage.ps1
#
# Description
#   This defines functions regarding install to use MSI file.
#   （MSI ファイルを使ったインストールに関するファンクションを定義しています。）
#
# Depends
#   .\Log.ps1
#   .\File.ps1
#   .\Execute.ps1
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
#   Install-MSIPackage
#
# DESCRIPTION（説明）
#   This function installs the package using the specified MSI file.
#   （指定した MSI ファイルを使ってパッケージをインストールします。）
#
# SYNTAX（構文）
#   Install-MSIPackage [-Path] <string>
#
# PARAMETERS（パラメーター）
#   -Path <string>
#       Specifies the path of file. This parameter is required.
#       （ファイルのパスを指定します。このパラメーターは必須です。）
#
# INPUTS（入力）
#   String
#       This functions inputs the path of file from the incoming pipeline.
#       （パイプライン入力から（ファイルのパスを入力します。）
#
# OUTPUTS（出力）
#       None
#       （なし）
#
function Install-MSIPackage
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
        Error "The following file is not found.（下記ファイルが見つかりません。）`n`n$Path"
        return
    }

    Info "Installation is starting.`n（インストールを開始します。）`n`n$Path"
    try
    {
        Start-Process -FilePath "msiexec.exe" -ArgumentList "/package $Path /passive" -Verb "runas" -Wait
    }
    catch
    {
        Error "Installation is failed.`n（インストールに失敗しました。）`n`n$Path`n`n$Error"
        return
    }
    Info "Installation has finished successfully.`n（インストールが正常に完了しました。）`n`n$Path"
}

#
# NAME（名前）
#   Update-MSIPackage
#
# DESCRIPTION（説明）
#   This function updates the package using the specified MSI file.
#   （指定した MSI ファイルを使ってパッケージをアップデートをします。）
#
# SYNTAX（構文）
#   Update-MSIPackage [-Path] <string>
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
function Update-MSIPackage
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
        Error "The following file is not found.（下記ファイルが見つかりません。）`n`n$Path"
        return
    }

    Info "Update is starting.`n（アップデートを開始します。）`n`n$Path"
    try
    {
        Start-Process -FilePath "msiexec.exe" -ArgumentList "/update $Path /passive" -Verb "runas" -Wait
    }
    catch
    {
        Error "Update is failed.`n（アップデートに失敗しました。）`n`n$Path`n`n$Error"
        return
    }
    Info "Update has finished successfully.`n（アップデートが正常に完了しました。）`n`n$Path"
}

# SIG # Begin signature block
# MIIFcAYJKoZIhvcNAQcCoIIFYTCCBV0CAQExCzAJBgUrDgMCGgUAMGkGCisGAQQB
# gjcCAQSgWzBZMDQGCisGAQQBgjcCAR4wJgIDAQAABBAfzDtgWUsITrck0sYpfvNR
# AgEAAgEAAgEAAgEAAgEAMCEwCQYFKw4DAhoFAAQUMdzD9tOIg2Y6ax3He0IGmcHT
# erWgggMaMIIDFjCCAgKgAwIBAgIQliVLy3mu8q1LSkdDsNdvkzAJBgUrDgMCHQUA
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
# BgorBgEEAYI3AgELMQ4wDAYKKwYBBAGCNwIBFTAjBgkqhkiG9w0BCQQxFgQUS/Pq
# 0SijI1QswOtdNHFcvB/9mH4wDQYJKoZIhvcNAQEBBQAEggEAMTxFvtYnlrGTfNoR
# ZGLkMD9IYNl0kFzHWIzIcBZ6akOteUvnkd92NbW/VyepSVwuF9Cic6h/nM/dAcoa
# aGLUzO39rzLPPtW5CPqUeZijjSbUuGL0kmCH2VmyWCI2wQr7FF/V5KWCqBjKePt3
# hYKgjmKxGCbxO96B6phLCw7CS6SHQrUXDInOqJOSp+lW2WQhZlfzKn9DKfn2zUHc
# js7vkWF1xZN341oWwxk/iqE1TqvDlfCskcB/twNs0XPjfCpBCDLP6D9pATrWTQsf
# jZnJenTRg2dswsX1E6ut38b1gVVcmrlAwx8FThoLxQHuOXPgerU4+r3F/5zECwXg
# /+lpFw==
# SIG # End signature block
