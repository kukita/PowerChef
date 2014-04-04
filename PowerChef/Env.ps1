#
# Name
#   Env.ps1
#
# Description
#   This defines functions regarding environment variables.
#   （環境変数に関するファンクションを定義しています。）
#
# Depends
#   .\Log.ps1
#   .\File.ps1
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
#   Test-ExistsEnv
#
# DESCRIPTION（説明）
#   This function returns a bool value to confirm the presence the specified environment variables.
#   （指定した環境変数の有無を確認し bool 値を返します。）
#
# SYNTAX（構文）
#   Test-ExistsEnv [-KeyName] <string> [-Value <string>]
#
# PARAMETERS（パラメーター）
#   -KeyName <string>
#       Specifies the key name of environtment attributes. This parameter is required.
#       （環境変数のキー名を指定します。このパラメーターは必須です。）
#
#   -Value <Object>
#       Specifies the value of environtment attributes. The default value is ".".
#       （環境変数の値を指定します。デフォルト値は ”.” です。）
#
# INPUTS（入力）
#   String
#       This functions inputs the key name of environtment attributes from the incoming pipeline.
#       （パイプライン入力から環境変数のキー名を入力します。）
#
# OUTPUTS（出力）
#       None
#       （なし）
#
function Test-ExistsEnv
{
    Param
    (
        [Parameter(Mandatory = $true, Position = 0, ValueFromPipeline = $true)]
        [string]
        [ValidateNotNull()]
        $KeyName,

        [Parameter(Mandatory = $false, Position = 1)]
        [string]
        [ValidateNotNull()]
        $Value = "."
    )

    [bool]$existsEnv = $false

    try
    {
        $existsEnv = Get-Content -Path "$PROFILE" | Select-String -Pattern "$KeyName" | Select-String -Pattern "$Value" -Quiet
    }
    catch
    {
        Error "Check for the existence of the following environment attribute is failed.`n（下記環境変数の有無の確認に失敗しました。）`n`nKey name: $KeyName`nValue: $Value`n`n$Error"
        return
    }
    return $existsEnv
}

#
# NAME（名前）
#   New-Env
#
# DESCRIPTION（説明）
#   This function creates the specified value to the specified environment variables.
#   （指定した環境変数に指定した値を追加します。）
#
# SYNTAX（構文）
#   New-Env [-KeyName] <string> [-Value] <string>
#
# PARAMETERS（パラメーター）
#   -KeyName <string>
#       Specifies the key name of environtment attributes. This parameter is required.
#       （環境変数のキー名を指定します。このパラメーターは必須です。）
#
#   -Value <Object>
#       Specifies the value of environtment attributes. This parameter is required.
#       （環境変数の値を指定します。このパラメーターは必須です。）
#
# INPUTS（入力）
#   String
#       This functions inputs the key name of environtment attributes from the incoming pipeline.
#       （パイプライン入力から環境変数のキー名を入力します。）
#
# OUTPUTS（出力）
#       None
#       （なし）
#
function New-Env
{
    Param
    (
        [Parameter(Mandatory = $true, Position = 0, ValueFromPipeline = $true)]
        [string]
        [ValidateNotNull()]
        $KeyName,

        [Parameter(Mandatory = $true, Position = 1)]
        [string]
        [ValidateNotNull()]
        $Value
    )

    if(!(Test-ExistsFile -Path "$PROFILE"))
    {
        New-File -Path "$PROFILE" -Value "`$env:HOME = `$HOME"
        Add-Content -Path "$PROFILE" -Value "`n"
    }

	if((Get-Content -Path "$PROFILE" | Select-String -Pattern "$KeyName" -Quiet))
    {
        Warning "The following environment variables is already exist.`n（下記環境変数は既に存在します。)`n`nKey name: $KeyName`nValue: $Value"
        return
    }

    Info "Setting the following environment variables is starting.`n（下記環境変数の設定を開始します。）`n`nKey name: $KeyName`nValue: $Value"
    try
    {
        Add-Content -Path "$PROFILE" -Value "`n`$env:$KeyName = `"$Value`""
    }
    catch
    {
        Error "Setting the following environment variables is failed.`n（下記環境変数の設定に失敗しました。）`n`nKey name: $KeyName`nValue: $Value`n`n$Error"
        return
    }
    Info "Setting the following environment variables has finished successfully.`n（下記環境変数の設定が正常に完了しました。）`n`nKey name: $KeyName`nValue: $Value"

    Info "Reloading the environment variables is starting.`n（環境変数の再読み込みを開始します。）"
    try
    {
        . "$PROFILE"
    }
    catch
    {
        Error "Reloading the environment variables is failed.`n（環境変数の再読み込みに失敗しました。）`n$Error"
        return
    }
    Info "Reloading the environment variables has finished successfully.`n（環境変数の再読み込みが正常に完了しました。）"
}

#
# NAME（名前）
#   Add-Env
#
# DESCRIPTION（説明）
#   This function appends the specified value to the specified environment variables.
#   （指定した環境変数に指定した値を追加します。）
#
# SYNTAX（構文）
#   Add-Env [-KeyName] <string> [-Value] <string>
#
# PARAMETERS（パラメーター）
#   -KeyName <string>
#       Specifies the key name of environtment attributes. This parameter is required.
#       （環境変数のキー名を指定します。このパラメーターは必須です。）
#   -Value <Object>
#       Specifies the value of environtment attributes. This parameter is required.
#       （環境変数の値を指定します。このパラメーターは必須です。）
#
# INPUTS（入力）
#   String
#       This functions inputs the key name of environtment attributes from the incoming pipeline.
#       （パイプライン入力から環境変数のキー名を入力します。）
#
# OUTPUTS（出力）
#       None
#       （なし）
#
function Add-Env
{
    Param
    (
        [Parameter(Mandatory = $true, Position = 0, ValueFromPipeline = $true)]
        [string]
        [ValidateNotNull()]
        $KeyName,

        [Parameter(Mandatory = $true, Position = 1)]
        [string]
        [ValidateNotNull()]
        $Value
    )

    [bool]$existsEnvKeyName = $false

    if(!(Test-ExistsFile -Path "$PROFILE"))
    {
        New-File -Path "$PROFILE" -Value "`$env:HOME = `$HOME"
        Add-Content -Path "$PROFILE" -Value "`n"
    }

    switch(Test-Path -Path "Env:$KeyName")
    {
        $true
        {
            Info "Setting the following environment variables is starting.`n（下記環境変数の設定を開始します。）`n`nKey name: $KeyName`nValue: $Value"
            try
            {
                Add-Content -Path "$PROFILE" -Value "`n`$env:$KeyName `= `"$Value`" `+ `"`;`$env:$KeyName`""
            }
            catch
            {
                Error "Setting the following environment variables is failed.`n（下記環境変数の設定に失敗しました。）`n`nKey name: $KeyName`nValue: $Value`n`n$Error"
                return
            }
            Info "Setting the following environment variables has finished successfully.`n（下記環境変数の設定が正常に完了しました。）`n`nKey name: $KeyName`nValue: $Value"
        }
        $false
        {
            Info "Setting the following environment variables is starting.`n（下記環境変数の設定を開始します。）`n`nKey name: $KeyName`nValue: $Value"
            try
            {
                Add-Content -Path "$PROFILE" -Value "`n`$env:$KeyName = `"$Value`""
            }
            catch
            {
                Error "Setting the following environment variables is failed.`n（下記環境変数の設定に失敗しました。）`n`nKey name: $KeyName`nValue: $Value`n`n$Error"
                return
            }
            Info "Setting the following environment variables has finished successfully.`n（下記環境変数の設定が正常に完了しました。）`n`nKey name: $KeyName`nValue: $Value"
        }
    }

    Info "Reloading the environment variables is starting.`n（環境変数の再読み込みを開始します。）"
    try
    {
        . "$PROFILE"
    }
    catch
    {
        Error "Reloading the environment variables is failed.`n（環境変数の再読み込みに失敗しました。）`n$Error"
        return
    }
    Info "Reloading the environment variables has finished successfully.`n（環境変数の再読み込みが正常に完了しました。）"
}

# SIG # Begin signature block
# MIIFcAYJKoZIhvcNAQcCoIIFYTCCBV0CAQExCzAJBgUrDgMCGgUAMGkGCisGAQQB
# gjcCAQSgWzBZMDQGCisGAQQBgjcCAR4wJgIDAQAABBAfzDtgWUsITrck0sYpfvNR
# AgEAAgEAAgEAAgEAAgEAMCEwCQYFKw4DAhoFAAQU16/+7wvoI/7CChtLuEKySnYc
# gLmgggMaMIIDFjCCAgKgAwIBAgIQliVLy3mu8q1LSkdDsNdvkzAJBgUrDgMCHQUA
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
# BgorBgEEAYI3AgELMQ4wDAYKKwYBBAGCNwIBFTAjBgkqhkiG9w0BCQQxFgQUltJA
# /M7d4T3Ck48sLQc9+I43h10wDQYJKoZIhvcNAQEBBQAEggEAQJ1lhAKIBOosC2g9
# rHhh3XP0asMjIohAYIliAf+LcmUdfUmUm2XTK+NKhM0cV9L015CD6e6V4Ff4iNDE
# Qyf8CrAgE/OkX26XaWiCmFkKIJXpJAVf29/Qn4esgu0VPDxbkYA8ucS0j6E4nRx3
# u4r96GOeWlr/0ANaVXGGQJHDxjwblf0Jo0iDsZALAyKcDmcjTE5h8uNo2rhi1hmY
# jhrugTsCR7MFLgAnwvQC0Q/6BJ/oKMpl82VLakbeX9kAyVTN/SCSKyG3WzpUlee4
# RazpBWzrbuY9o8t8EFfJxbEgPX7pGgEMT6iEYbpVw75lkKWHxMr4zm6x5ZWuOL3k
# 53u6XQ==
# SIG # End signature block
