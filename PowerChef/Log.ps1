﻿#
# Name
#   Log.ps1
#
# Description
#   This defines functions regarding logging.
#   （ロギングに関するファンクションを定義しています。）
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
#   New-EventLogSource
#
# DESCRIPTION（説明）
#   This function creates the source of event log with the specified name.
#   （指定した名前のイベントログのソースを作製します。）
#
# SYNTAX（構文）
#   New-EventLogSource [-Name] <string>
#
# PARAMETERS（パラメーター）
#   -Name <string>
#       Specifies the source name of event log. This parameter is required.
#       （イベントログのソース名を指定します。このパラメーターは必須です。）
#
# INPUTS（入力））
#   string
#       This functions inputs the source name of event log from the incoming pipeline.
#       （パイプライン入力からイベントログのソース名を入力します。）
#
# OUTPUTS（出力）
#       None
#       （なし）
#
function New-EventLogSource
{
    Param
    (
        [Parameter(Mandatory = $true, Position = 0, ValueFromPipeline = $true)]
        [string]
        [ValidateNotNull()]
        $Name
    )

    if(!([System.Diagnostics.EventLog]::SourceExists($Name)))
    {
        Write-Host -Object "[$(Get-Date -Format "yyyy/MM/dd HH:mm:ss")]`n[Information]`nCreation of the following event source is starting.`n（下記イベントソースの作成を開始します。）`n`n$Name" `
                -Backgroundcolor "Blue" `
                -ForegroundColor "White"
        try
        {
            New-Eventlog -Source "$Name" -LogName "Application"
        }
        catch
        {
            Write-Error -Message "[$(Get-Date -Format "yyyy/MM/dd HH:mm:ss")]`n[Error]`nCreation of the following event source is failed.`n（下記イベントソースの作成に失敗しました。）`n`n$Name`n`n$Error"
        }
        Info "The following event source named is created.`n（下記イベントソースを作製しました。）`n`n$Name" -EventID 10000
    }
}

#
# NAME（名前）
#   Info
#
# DESCRIPTION（説明）
#   This function outputs information message to console and to event log.
#   （情報メッセージをコンソールとイベントログに出力します。）
#
# SYNTAX（構文）
#   Info [-Message] <string> [-EventID <int>]
#
# PARAMETERS（パラメーター）
#   -Message <string>
#       Specifies the output message. This parameter is required.
#       （出力するメッセージを指定します。このパラメーターは必須です。）
#
#   -EventID <int>
#       Specifies the event ID. The valid values range from 10000 to 19999. The default is 10000.
#       （イベントIDを指定します。有効な値は 10000 ～ 19999 です。規定値は 10000 です。）
#
# INPUTS（入力）
#   String
#       This functions the output message values from the incoming pipeline.
#       （パイプライン入力から出力するメッセージを入力します。）
#
# OUTPUTS(出力)
#       None
#       （なし）
#
function Info
{
    Param
    (
        [Parameter(Mandatory = $true, Position = 0, ValueFromPipeline = $true)]
        [string]
        [ValidateNotNull()]
        $Message,

        [Parameter()]
        [int]
        [ValidateNotNull()]
        [ValidateRange(10000, 19999)]
        $EventID = 10000
    )

    [string]$line = "[$(Get-Date -Format "yyyy/MM/dd HH:mm:ss")]`n[Information]`n$Message"

    Write-Host -Object "$line" -Backgroundcolor "Blue" -ForegroundColor "White"
    Write-Host -Object ""
    Write-EventLog -LogName "Application" `
            -Source "$script:moduleName" `
            -EventId $EventID `
            -Message "$Message" `
            -EntryType "Information"
}

#
# NAME（名前）
#   Warning
#
# DESCRIPTION（説明）
#   This function outputs warning message to console and to event log.
#   （警告メッセージをコンソールとイベントログに出力します。）
#
# SYNTAX（構文）
#   Warning [-Message] <string> [-EventID <int>]
#
# PARAMETERS（パラメーター）
#   -Message <string>
#       Specifies the output message. This parameter is required.
#       （出力するメッセージを指定します。このパラメーターは必須です。）
#
#   -EventID <int>
#       Specifies the event ID. The valid values range from 20000 to 29999. The default is 20000.
#       （イベントIDを指定します。有効な値は 20000 ～ 29999 です。規定値は 20000 です。）
#
# INPUTS（入力）
#   String
#       This functions the output message values from the incoming pipeline.
#       （パイプライン入力から出力するメッセージを入力します。）
#
# OUTPUTS(出力)
#       None
#       （なし）
#
function Warning
{
    Param
    (
        [Parameter(Mandatory = $true, Position = 0, ValueFromPipeline = $true)]
        [string]
        [ValidateNotNull()]
        $Message,

        [Parameter()]
        [int]
        [ValidateNotNull()]
        [ValidateRange(20000, 29999)]
        $EventID = 20000
    )

    [string]$line = "[$(Get-Date -Format "yyyy/MM/dd HH:mm:ss")]`n[Warning]`n$Message"

    Write-Host -Object "$line" -Backgroundcolor "Yellow" -ForegroundColor "Black"
    Write-Host -Object ""
    Write-EventLog -LogName "Application" `
            -Source "$script:moduleName" `
            -EventId $EventID `
            -Message "$Message" `
            -EntryType "Warning"
}

#
# NAME（名前）
#   Error
#
# DESCRIPTION（説明）
#   This function exits program after this outputs error message to the console and to the event log.
#   （エラーメッセージをコンソールとイベントログに出力し、プログラムを終了します。）
#
# SYNTAX（構文）
#   Error [-Message] <string> [-EventID <int>]
#
# PARAMETERS（パラメーター）
#   -Message <string>
#       Specifies the output message. This parameter is required.
#       （出力するメッセージを指定します。このパラメーターは必須です。）
#
#   -EventID <int>
#       Specifies the event ID. The valid values range from 30000 to 39999. The default is 30000.
#       （イベントIDを指定します。有効な値は 3000 ～ 3999 です。規定値は 3000 です。）
#
# INPUTS（入力）
#   String
#       This functions the output message values from the incoming pipeline.
#       （パイプライン入力から出力するメッセージを入力します。）
#
# OUTPUTS(出力)
#   None
#   （なし）
#
function Error
{
    Param
    (
        [Parameter(Mandatory = $true, Position = 0, ValueFromPipeline = $true)]
        [string]
        [ValidateNotNull()]
        $Message,

        [Parameter()]
        [int]
        [ValidateNotNull()]
        [ValidateRange(30000, 39999)]
        $EventID = 30000
    )

    [string]$line = "[$(Get-Date -Format "yyyy/MM/dd HH:mm:ss")]`n[Error]`n$Message"

    Write-Host -Object "$line" -Backgroundcolor "Red" -ForegroundColor "White"
    Write-Host -Object ""
    Write-EventLog -LogName "Application" `
            -Source "$script:moduleName" `
            -EventId $EventID `
            -Message "$Message" `
            -EntryType "Error"
}

# SIG # Begin signature block
# MIIFcAYJKoZIhvcNAQcCoIIFYTCCBV0CAQExCzAJBgUrDgMCGgUAMGkGCisGAQQB
# gjcCAQSgWzBZMDQGCisGAQQBgjcCAR4wJgIDAQAABBAfzDtgWUsITrck0sYpfvNR
# AgEAAgEAAgEAAgEAAgEAMCEwCQYFKw4DAhoFAAQUvjjEzQeej05KFmbdJ1MGAavo
# Z/6gggMaMIIDFjCCAgKgAwIBAgIQliVLy3mu8q1LSkdDsNdvkzAJBgUrDgMCHQUA
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
# BgorBgEEAYI3AgELMQ4wDAYKKwYBBAGCNwIBFTAjBgkqhkiG9w0BCQQxFgQU41Rj
# oLn74Kc4PcbOn5zamvwFjRUwDQYJKoZIhvcNAQEBBQAEggEAL8vGRI4QjDoyJSJN
# r2qLSf2SlouPoWr1mh4jsgqPZDDKQwwLi2hn31Jejl1EWzL32aM5isL5YwQKmw6n
# N6niRbsF7vO0wwI/XYizXyfF9kGINdIOBeoSjzR03IhXXSpLFQYA2G3RzJMm5mu+
# s0/tejg6dvmtx/WTRLtuUO5OntVsV20Au393FXBWOIf1tNYRNGO8M+qdDwyy5S10
# MtH09oPExbomQN/1eI0ot0z8W8f7MIRFWKgeZ+w/zegRJfyHmqBMiI19e1VBP9w7
# xdvZxMPY9dkJlwh1M7oEwyxYhR+Syr1YCtaQ8jb7r+7k5I6lrNpTDkt8n58CO+7l
# q8SrPA==
# SIG # End signature block
