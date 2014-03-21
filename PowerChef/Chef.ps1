#
# Name
#   Chef.ps1
#
# Description
#   This defines functions regarding 'Chef'.
#   （'Chef' に関するファンクションを定義しています。）
#
# Depends
#   .\Log.ps1
#   .\File.ps1
#   .\Execute.ps1
#   .\Env.ps1
#   .\MSIPackage.ps1
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
#   This function installs 'Chef'.
#   （'Chef' をインストールします。）
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
# Install-Chef
#
#.LINK
# Update-Chef
#
#.LINK
# New-ChefZeroACL
#
#.LINK
# Start-ChefZero
#
function Install-Chef
{
    if(!(Get-Content -Path "$PROFILE" | Select-String -Pattern "PATH.*opscode" -Quiet))
    {
        Add-Env -KeyName "PATH" -Value "$env:SystemDrive\opscode\chef\bin"
        Add-Env -KeyName "PATH" -Value "$env:SystemDrive\opscode\chef\embedded\bin"
    }

    if(Test-CanExecute -Command "knife.bat")
    {
        Warning "'Chef' is already installed.`n（'Chef' は既にインストールされています。）"
        & "knife.bat" --version
        return
    }

    Info "Installation of 'Chef' is starting.`n（'Chef' のインストールを開始します。）"
	Download-File -SourceURL "https://www.opscode.com/chef/install.msi" -DistinationFilePath "$env:TEMP\Chef.msi"
	Install-MSIPackage -Path "$env:TEMP\Chef.msi"
	Remove-File "$env:TEMP\Chef.msi"
    Info "Installation of 'Chef' has finished.`n（'Chef' のインストールが完了しました。）"
    & "knife.bat" --version
}

#
#.SYNOPSIS
#   This function (re)installs the latest version 'Chef'.
#   （'Chef' をアップデートします。）
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
# Install-Chef
#
#.LINK
# Update-Chef
#
#.LINK
# New-ChefZeroACL
#
#.LINK
# Start-ChefZero
#
function Update-Chef
{
    if(!(Test-CanExecute -Command "knife"))
    {
        Error "'Chef' is not installed.`n（'Chef' がインストールされていません。）"
        return
    }

    Info "Update of 'Chef' is starting.`n（'Chef' のアップデートを開始します。）"
	Download-File -SourceURL "https://www.opscode.com/chef/install.msi" -DistinationFilePath "$env:TEMP\Chef.msi"
	Update-MSIPackage -Path "$env:TEMP\Chef.msi"
	Remove-File -Path "$env:TEMP\Chef.msi"
    Info "Update of 'Chef' has finished.`n（'Chef' のアップデートが完了しました。）"
    & "knife.bat" --version
}

#
# NAME（名前）
#   Test-IsInstalledChefGemPackage
#
# DESCRIPTION（説明）
#   This function returns a bool value to confirm the presence the specified Gems package in local.
#   （指定した Gems のパッケージの有無を確認し bool 値を返します。）
#
# SYNTAX（構文）
#   Test-IsInstalledChefGemPackage [-PackageName] <string>
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
function Test-IsInstalledChefGemPackage
{
    Param
    (
        [Parameter(Mandatory = $true, Position = 0, ValueFromPipeline = $true)]
        [string]
        [ValidateNotNull()]
        $PackageName
    )

    [bool]$isInstalledChefGemPackage = $false

    try
    {
        $isInstalledChefGemPackage = (& "$env:SystemDrive\opscode\chef\embedded\bin\gem.bat" list --local | Select-String -Pattern "^$PackageName " -Quiet)
    }
    catch
    {
        Error "Check for the existence of the following package is failed.`n（下記パッケージ有無の確認に失敗しました。）`n`n$PackageName`n`n$Error"
        return
    }
    return $isInstalledChefGemPackage
}

#
# NAME（名前）
#   Install-ChefGemPackage
#
# DESCRIPTION（説明）
#   This function installs the package of Gems.
#   （Gems のパッケージをインストールします。）
#
# SYNTAX（構文）
#   Install-ChefGemPackage [-PackageName] <string>
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
function Install-ChefGemPackage
{
    Param
    (
        [Parameter(Mandatory = $true, Position = 0, ValueFromPipeline = $true)]
        [string]
        [ValidateNotNull()]
        $PackageName
    )

    if(!(Test-CanExecute -Command "gem.bat"))
    {
        Error "You must run `Install-Chef` before to install '$PackageName'.`n（'$PackageName' をインストールする前に `Install-Chef` を実行する必要があります。）"
        return
    }

    if(Test-IsInstalledChefGemPackage -PackageName "$PackageName")
    {
        Warning "The following package is already installed.`n（下記パッケージは既にインストールされています。）`n`n$PackageName"
        return
    }

    Info "Installation of the following package is starting.`n（下記パッケージのインストールを開始します。）`n`n$PackageName"
    & "$env:SystemDrive\opscode\chef\embedded\bin\gem.bat" install "$PackageName" --no-ri --no-rdoc
    if($LASTEXITCODE -ne 0)
    {
        Error "Installation of the following package is faild.`n（下記パッケージのインストールに失敗しました。）`n`n$PackageName`n`nExit code: $LASTEXITCODE"
        return
    }
    Info "Installation of the following package has finished successfully.`n（下記パッケージのインストールが正常に完了しました。）`n$PackageName"
}

#
# NAME（名前）
#   Update-ChefGemPackage
#
# DESCRIPTION（説明）
#   This function updates the package of Gems.
#   （Gems のパッケージをアップデートします。）
#
# SYNTAX（構文）
#   Update-ChefGemPackage [-PackageName] <string>
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
function Update-ChefGemPackage
{
    Param
    (
        [Parameter(Mandatory = $true, Position = 0, ValueFromPipeline = $true)]
        [string]
        [ValidateNotNull()]
        $PackageName
    )

    if(!(Test-CanExecute -Command "gem.bat"))
    {
        Error "You must run `Install-Chef` before to update '$PackageName'.`n（'$PackageName' をアップデートする前に `Install-Chef` を実行する必要があります。）"
        return
    }

    if(!(Test-IsInstalledChefGemPackage -PackageName "$PackageName"))
    {
        Error "The following package is not installed.`n（下記パッケージがインストールされていません。）`n`n$PacakgeName"
        return
    }

    Info "Update of the following package is starting.`n（下記パッケージのアップデートを開始します。）`n`n$PackageName"
    & "$env:SystemDrive\opscode\chef\embedded\bin\gem.bat" update "$PackageName" --no-ri --no-rdoc
    if($LASTEXITCODE -ne 0)
    {
        Error "Update of the following package is faild.`n（下記パッケージのアップデートに失敗しました。）`n`n$PackageName`n`nExit code: $LASTEXITCODE"
        return
    }
    Info "Update of the following package has finished successfully.`n（下記パッケージのアップデートが正常に完了しました。）`n`n$PackageName"
}

#
#.SYNOPSIS
#   This function creates 'Windows Firewall Rule' to allow inboud connection regarding 'Chef Zero'.
#   （'Chef Zero' に関する接続を許可するための 'Windows ファイアウォールルール' を作成します。）
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
# Install-Chef
#
#.LINK
# Update-Chef
#
#.LINK
# New-ChefZeroACL
#
#.LINK
# Start-ChefZero
#
function New-ChefZeroACL
{
    Info "Execution of the following command is starting.`n（下記コマンドを実行します。）`n`nNew-NetFirewallRule -DisplayName 'Allow inbound connection regarding Chef Zero' -Name 'ChefZero-In-TCP' -Direction 'inbound' -Protocol 'TCP' -LocalPort 8889 -RemoteAddress '192.168.56.0/24' -Action 'Allow'"
    try
    {
        New-NetFirewallRule -DisplayName 'Allow inbound connection regarding Chef Zero' -Name 'ChefZero-In-TCP' -Direction 'inbound' -Protocol 'TCP' -LocalPort 8889 -RemoteAddress '192.168.56.0/24' -Action 'Allow'
    }
    catch
    {
        Error "Execution of the following command is failed.`n（下記コマンドの実行に失敗しました。）`n`nNew-NetFirewallRule -DisplayName 'Allow inbound connection regarding Chef Zero' -Name 'ChefZero-In-TCP' -Direction 'inbound' -Protocol 'TCP' -LocalPort 8889 -RemoteAddress '192.168.56.0/24' -Action 'Allow'`n`n$Error"
        return
    }
    Info "Execution of the following command has finished successfully.`n（下記コマンドの実行が正常に完了しました。）`n`nNew-NetFirewallRule -DisplayName 'Allow inbound connection regarding Chef Zero' -Name 'ChefZero-In-TCP' -Direction 'inbound' -Protocol 'TCP' -LocalPort 8889 -RemoteAddress '192.168.56.0/24' -Action 'Allow'"
}

#
#.SYNOPSIS
#   This function runs the 'Chef Zero'.
#   （'Chef Zero' を起動します。）
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
# Install-Chef
#
#.LINK
# Update-Chef
#
#.LINK
# New-ChefZeroACL
#
#.LINK
# Start-ChefZero
#
function Start-ChefZero
{
    if(!(Test-IsExistFile -Path "$env:SystemDrive\chef\validation.pem"))
    {
        New-Folder -Path "$env:SystemDrive\chef"
        Invoke-Execute "ssh-keygen.exe" "-t" "rsa" "-N" '""' "-f" "$env:SystemDrive\chef\validation.pem"
    }

    Info "Running of 'Chef Zero' is starting.`n（'Chef Zero' の起動を開始します。）"
    try
    {
        Start-Process -FilePath "$env:SystemDrive\opscode\chef\bin\chef-zero.bat" -ArgumentList "-H 0.0.0.0 -p 8889" -Verb "runas" -WindowStyle "Minimized"
    }
    catch
    {
        Error "Running of 'Chef Zero' is failed.`n（'Chef Zero' の起動に失敗しました。）`n`n$Error"
        return
    }
    Info "Running of 'Chef Zero' has finished successfully.`n（'Chef Zero' の起動が正常に完了しました。）"
}

# SIG # Begin signature block
# MIIFcAYJKoZIhvcNAQcCoIIFYTCCBV0CAQExCzAJBgUrDgMCGgUAMGkGCisGAQQB
# gjcCAQSgWzBZMDQGCisGAQQBgjcCAR4wJgIDAQAABBAfzDtgWUsITrck0sYpfvNR
# AgEAAgEAAgEAAgEAAgEAMCEwCQYFKw4DAhoFAAQUqz1WSWM4BSVeuYcA8c1TFtd/
# JaWgggMaMIIDFjCCAgKgAwIBAgIQliVLy3mu8q1LSkdDsNdvkzAJBgUrDgMCHQUA
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
# BgorBgEEAYI3AgELMQ4wDAYKKwYBBAGCNwIBFTAjBgkqhkiG9w0BCQQxFgQU4Q/i
# GXFZANAHafvrmj0YoPPz0FswDQYJKoZIhvcNAQEBBQAEggEAWYygc4ahLRoziyBI
# oFt8+RDC4TGeBvVFcOCEdjH5r4O0TzBVK+fRgZmh6Ke5Nn4RujXqDZq5vVo+J9Dw
# Fd9Avy/MKZ+2i8yptXGELr+gIzmRMuFKHjXrWuOB5RZBh0lAxlnDeAsqJaJnw/vA
# JMIhArjGZWrdmT18cAR6uj6zb84QYNjSQTA/0ulpDNl7Ziyeh6isC5MbKkzqMbcb
# sQTZ+7MYob+h2uh25bQI+GGAA14usTZttNnu9e8kKofyAyqMNJsWOUANCUHzckG2
# hkbJazj2pEaj9ILZcpFMsIE02ULsmxhccK0FB5v0AG408/Cca0dHCqOqftTyGdoI
# gkLshg==
# SIG # End signature block
