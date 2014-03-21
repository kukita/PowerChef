#
# Name
#   Execute.ps1
#
# Description
#   This defines functions regarding executing command.
#   （コマンドの実行に関するファンクションを定義しています。）
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
#   Test-CanExecute
#
# DESCRIPTION（説明）
#   This function returns a bool value to confirm the presence of the capable to execute with the specified command.
#   （指定した名前の実行コマンドの有無を確認し bool 値を返します。）
#
# SYNTAX（構文）
#   Test-CanExecute [-Command] <string>
#
# PARAMETERS（パラメーター）
#   -Command <string>
#       Specifies the command. This parameter is required.
#       （コマンドを指定します。このパラメーターは必須です。）
#
# INPUTS（入力）
#   String
#       This functions inputs the command from the incoming pipeline.
#       （パイプライン入力からコマンドを入力します。）
#
# OUTPUTS（出力）
#   bool
#       This function returns a bool value to confirm the capable to execute with the specified command.
#       （指定したコマンドの有無を確認し bool 値で返します。）
#
function Test-CanExecute
{
    Param
    (
        [Parameter(Mandatory = $true, Position = 0, ValueFromPipelineByPropertyName = $true)]
        [string]
        [ValidateNotNull()]
        $Command
    )

    [bool]$canExecute = $false

    & "where.exe" "$Command" | Out-Null
    if($LASTEXITCODE -eq 0)
    {
       $canExecute = $true
    }
    return $canExecute
}

#
# NAME（名前）
#   Invoke-Execute
#
# DESCRIPTION（説明）
#   This function execute the specified command.
#   （指定したコマンドを実行します。）
#
# SYNTAX（構文）
#   Invoke-Execute [-Command] <string> [-Argument1 <string>] [-Argument2 <string>] [-Argument3 <string>] [-Argument4 <string>]
#
# PARAMETERS（パラメーター）
#   -Command <string>
#       Specifies the command. This parameter is required.
#       （コマンドを指定します。このパラメーターは必須です。）
#
#   -Argument1 - Argument8 <string>
#       Specifies the arguments of command. The default value is empty charactor.
#       （コマンドの引数を指定します。デフォルト値は空文字です。）
#
# INPUTS（入力）
#       None
#       （なし）
#
# OUTPUTS（出力）
#       None
#       （なし）
#
function Invoke-Execute
{
    Param
    (
        [Parameter(Mandatory = $true, Position = 0, ValueFromPipeline = $true)]
        [string]
        [ValidateNotNull()]
        $Command,

        [Parameter(Mandatory = $false, Position = 1)]
        [string]
        [ValidateNotNull()]
        $Argument1 = "",

        [Parameter(Mandatory = $false, Position = 2)]
        [string]
        [ValidateNotNull()]
        $Argument2 = "",

        [Parameter(Mandatory = $false, Position = 3)]
        [string]
        [ValidateNotNull()]
        $Argument3 = "",

        [Parameter(Mandatory = $false, Position = 4)]
        [string]
        [ValidateNotNull()]
        $Argument4 = "",

        [Parameter(Mandatory = $false, Position = 5)]
        [string]
        [ValidateNotNull()]
        $Argument5 = "",

        [Parameter(Mandatory = $false, Position = 6)]
        [string]
        [ValidateNotNull()]
        $Argument6 = "",

        [Parameter(Mandatory = $false, Position = 7)]
        [string]
        [ValidateNotNull()]
        $Argument7 = "",

        [Parameter(Mandatory = $false, Position = 8)]
        [string]
        [ValidateNotNull()]
        $Argument8 = "",

        [Parameter(Mandatory = $false, Position = 9)]
        [string]
        [ValidateNotNull()]
        $Argument9 = "",

        [Parameter(Mandatory = $false, Position = 10)]
        [string]
        [ValidateNotNull()]
        $Argument10 = ""
    )

    if(!(Test-CanExecute -Command "$Command"))
    {
        Error "The following command is not found.`n（下記コマンドが見つかりません。）`n`n$Command"
        return
    }

    Info "Execution of the following command is starting.`n（下記コマンドを実行します。）`n`n$Command $Argument1 $Argument2 $Argument3 $Argument4 $Argument5 $Argument6 $Argument7 $Argument8 $Argument9 $Argument10"
    & "$Command" $Argument1 $Argument2 $Argument3 $Argument4 $Argument5 $Argument6 $Argument7 $Argument8 $Argument9 $Argument10
    if($LASTEXITCODE -ne 0)
    {
        Error "Execution of the following command is failed.`n（下記コマンドの実行に失敗しました。）`n`n$Command $Argument1 $Argument2 $Argument3 $Argument4 $Argument5 $Argument6 $Argument7 $Argument8 $Argument9 $Argument10`n`nExit Code:$LASTEXITCODE"
        return
    }
    Info "Execution of the following command has finished successfully.`n（下記コマンドの実行が正常に完了しました。）`n`n$Command $Argument1 $Argument2 $Argument3 $Argument4 $Argument5 $Argument6 $Argument7 $Argument8 $Argument9 $Argument10"
}

# SIG # Begin signature block
# MIIFcAYJKoZIhvcNAQcCoIIFYTCCBV0CAQExCzAJBgUrDgMCGgUAMGkGCisGAQQB
# gjcCAQSgWzBZMDQGCisGAQQBgjcCAR4wJgIDAQAABBAfzDtgWUsITrck0sYpfvNR
# AgEAAgEAAgEAAgEAAgEAMCEwCQYFKw4DAhoFAAQUdgTTgKV3vZnsvfpaWePpv/Xa
# lICgggMaMIIDFjCCAgKgAwIBAgIQliVLy3mu8q1LSkdDsNdvkzAJBgUrDgMCHQUA
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
# BgorBgEEAYI3AgELMQ4wDAYKKwYBBAGCNwIBFTAjBgkqhkiG9w0BCQQxFgQUoKi5
# 4Ln3GtF3YHNkVM+pqHz817cwDQYJKoZIhvcNAQEBBQAEggEAdDK96bs3tmpMtXsl
# yhA/0u0TRxi5qJIIyBm90JKRmP5lzBZeyciavLqF+Qp92nrfRIBAxs+dlo0x+fvy
# f67ij4cX8sUWCwPok2YIWTKHGUkHHTxshqwC2lPn/Oan4buXEB6o/QEVwrRnim0v
# /tndIsIo3qFKvr/VTv2fEeoWQ4WuyNkJc8v+Z5D/qtx7KzsYfhU3hcWbyu59ViAd
# CbyzaBo5A/6Wg2IUFbh5qWk3vC0/xFB24KnJfTzD6+bjASU2eLYc1hWNWrvr+X1W
# NoXppblQ1ujl1MkAC6YGGX3VhDTDrJv3d1PEKaNDHNT3gelI0nTjWvdL+jJ3RzmS
# ywCCmw==
# SIG # End signature block
