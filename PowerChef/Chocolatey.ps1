#
# Name
#   Chocolatey.ps1
#
# Description
#   This defines functions regarding 'Chocolatey'.
#   （'Chocolatey' に関するファンクションを定義しています。）
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
#.SYNOPSIS
#   This function installs 'Chocolatey'.
#   （'Chocolatey' をインストールします。）
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
# Install-Chocolatey
#
#.LINK
# Update-Chocolatey
#
function Install-Chocolatey
{
    if(!(Get-Content -Path "$PROFILE" | Select-String -Pattern "PATH.*Chocolatey" -Quiet))
    {
        Add-Env -KeyName "PATH" -Value "`$env:ProgramData\Chocolatey\bin"
    }

    if(Test-CanExecute -Command "chocolatey")
    {
        Warning "'Chocolatey' is already installed.`n（'Chocolatey' は既にインストールされています。）"
        & "cver" "Chocolatey" -localonly
        return
    }

    Info "Installation of 'Chocolatey' is starting.`n（'Chocolatey' のインストールを開始します。）"
    Download-File -SourceURL "https://chocolatey.org/install.ps1" -DistinationFilePath "$env:TEMP\ChocolateyInstall.ps1"
    & "$env:TEMP\ChocolateyInstall.ps1"
    Remove-File -Path "$env:TEMP\ChocolateyInstall.ps1"
    Info "The installation of 'Chocolatey' has finished.`n（'Chocolatey' のインストールが完了しました。）"
    & "cver" "Chocolatey" -localonly
}

#
#.SYNOPSIS
#   This function updates 'Chocolatey'.
#   （'Chocolatey' をアップデートします。）
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
# Install-Chocolatey
#
#.LINK
# Update-Chocolatey
#
function Update-Chocolatey
{
    if(!(Test-CanExecute -Command "cup"))
    {
        Error "'Chocolatey' is not installed.`n（'Chocolatey' がインストールされていません。）"
        return
    }

    Update-ChocolateyPackage -PackageName "Chocolatey"
}

#
# NAME（名前）
#   Test-IsInstalledChocolateyPackage
#
# DESCRIPTION（説明）
#   This function returns a bool value to confirm the presence the specified Chocolatey package in local.
#   （指定した 'Chocolatey' のパッケージの有無を確認し bool 値を返します。）
#
# SYNTAX（構文）
#   Test-IsInstalledChocolateyPackage [-PackageName] <string>
#
# PARAMETERS（パラメーター）
#   -PackageName <switch>
#       Specifies the name of package. This parameter is required.
#       （パッケージの名前を指定します。このパラメーターは必須です。）
#
# INPUTS（入力）
#   String
#       This functions inputs the name of package from the incoming pipeline.
#       （パイプライン入力からパッケージの名前を入力します。）
#
# OUTPUTS（出力）
#       None
#       （なし）
#
function Test-IsInstalledChocolateyPackage
{
    Param
    (
        [Parameter(Mandatory = $true, Position = 0, ValueFromPipeline = $true)]
        [string]
        [ValidateNotNull()]
        $PackageName
    )

    [bool]$isNotInstalledChocolateyPackage = $false

    try
    {
        $isNotInstalledChocolateyPackage = (& "cver" "$PackageName" -localonly | Select-String -Pattern "no version" -Quiet)
    }
    catch
    {
        Error "Check for the existence of the following package is failed.`n（下記パッケージ有無の確認に失敗しました。）`n`n$PackageName`n`n$Error"
        return
    }

    switch($isNotInstalledChocolateyPackage)
    {
        $true
        {
            return $false
        }
        $false
        {
            return $true
        }
    }
}

#
# NAME（名前）
#   Install-ChocolateyPackage
#
# DESCRIPTION（説明）
#   This function installs the package of Chocolatey.
#   （'Chocolatey' のパッケージをインストールします。）
#
# SYNTAX（構文）
#   Install-ChocolateyPackage [-PackageName] <string>
#
# PARAMETERS（パラメーター）
#   -PackageName <switch>
#       Specifies the name of package. This parameter is required.
#       （パッケージの名前を指定します。このパラメーターは必須です。）
#
# INPUTS（入力）
#   String
#       This functions inputs the name of package from the incoming pipeline.
#       （パイプライン入力からパッケージの名前を入力します。）
#
# OUTPUTS（出力）
#       None
#       （なし）
#
function Install-ChocolateyPackage
{
    Param
    (
        [Parameter(Mandatory = $true, Position = 0, ValueFromPipeline = $true)]
        [string]
        [ValidateNotNull()]
        $PackageName
    )

    if(!(Test-CanExecute -Command "cinst"))
    {
        Error "You must run `Install-Chocolatey` before to install '$PackageName'.`n（'$PackageName' をインストールする前に `Install-Chocolatey` を実行する必要があります。）"
        return
    }

    if(Test-IsInstalledChocolateyPackage -PackageName "$PackageName")
    {
        Warning "The following package is already installed.`n（下記パッケージは既にインストールされています。）`n`n$PackageName"
        & "cver" "$PackageName" -localonly
        return
    }

    Info "Installation of the following package is starting.`n（下記パッケージのインストールを開始します。）`n`n$PackageName"
    Invoke-Execute "cinst" "$PackageName"
    Info "Installation of the following package has finished.`n（下記パッケージのインストールが完了しました。）`n`n$PackageName"
    & "cver" "$PackageName" -localonly
}

#
# NAME（名前）
#   Update-ChocolateyPackage
#
# DESCRIPTION（説明）
#   This function updates the package of Chocolatey.
#   （'Chocolatey' のパッケージをアップデートします。）
#
# SYNTAX（構文）
#   Update-ChocolateyPackage [-PackageName] <string>
#
# PARAMETERS（パラメーター）
#   -PackageName <switch>
#       Specifies the name of package. This parameter is required.
#       （パッケージの名前を指定します。このパラメーターは必須です。）
#
# INPUTS（入力）
#       None
#       （なし）
#
# OUTPUTS（出力）
#       None
#       （なし）
#
function Update-ChocolateyPackage
{
    Param
    (
        [Parameter(Mandatory = $true, Position = 0)]
        [string]
        [ValidateNotNull()]
        $PackageName
    )

    if(!(Test-CanExecute -Command "cup"))
    {
        Error "You must run `Install-Chocolatey` before to update '$PackageName'.`n（'$PackageName' をアップデートする前に `Install-Chocolatey` を実行する必要があります。）"
        return
    }

    if(!(Test-IsInstalledChocolateyPackage -PackageName "$PackageName"))
    {
        Error "The following package is not installed.`n（下記パッケージがインストールされていません。）`n`n$PackageName"
        return
    }

    Info "Update of the following package is starting.`n（下記パッケージのアップデートを開始します。）`n`n$PackageName"
    Invoke-Execute "cup" "$PackageName"
    Info "Update of the following package has finished.`n（下記パッケージのアップデートが完了しました。）`n`n$PackageName"
    & "cver" "$PackageName" -localonly
}

# SIG # Begin signature block
# MIIFcAYJKoZIhvcNAQcCoIIFYTCCBV0CAQExCzAJBgUrDgMCGgUAMGkGCisGAQQB
# gjcCAQSgWzBZMDQGCisGAQQBgjcCAR4wJgIDAQAABBAfzDtgWUsITrck0sYpfvNR
# AgEAAgEAAgEAAgEAAgEAMCEwCQYFKw4DAhoFAAQUqeNbXToUFp+aOzLB7DZJiR+G
# 63agggMaMIIDFjCCAgKgAwIBAgIQliVLy3mu8q1LSkdDsNdvkzAJBgUrDgMCHQUA
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
# BgorBgEEAYI3AgELMQ4wDAYKKwYBBAGCNwIBFTAjBgkqhkiG9w0BCQQxFgQU1zle
# ziAedg/qUG9VD9OtIpHa7YMwDQYJKoZIhvcNAQEBBQAEggEAP/Lg4Fzc9Nu4kKZB
# Rtof75N4LCyQ1QJYWKyylozr16+IfP3y6IezQBgFR2VFOf3K6W/WvEARIysGlfrH
# sUQU7yiSmFrcdeoUHLpLwJd+cZKEb1Ig8osPSQyAJ8NIDh1YIYzE11xSu3/e1r1v
# XQ60X2/gNp85yhCg17xKNpVqIdX9wQDpsMUUEy2JZP2gjd6HL8Zm3CmH8wTxKZ3/
# 3HCcp5kA1Kh7aWclvdH3SQXsc5shZRYNi8KdBdiE+SI7oHAZOoi1QU/gcLPDDZ3B
# Rn4I/4zAzgFvYVTFNkC9aan52Sv1BNqZSc/IvYiYLtoY+EZb0S4GpiMbuLi2Ewmm
# vfISgw==
# SIG # End signature block
