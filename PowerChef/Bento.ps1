#
# Name
#   Bento.ps1
#
# Description
#   This defines functions regarding Bento.
#   （Bento に関するファンクションを定義しています。）
#
# Depends
#   .\Log.ps1
#   .\Folder.ps1
#   .\Execute.ps1
#   .\Chef.ps1
#   .\Git.ps1
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
#   This function installs 'Bento'.
#   （'Bento' をインストールします。）
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
# Install-Bento
#
#.LINK
# Update-Bento
#
#.LINK
# Show-VeeweeDefinitionVboxList
#
#.LINK
# Invoke-VeeweeVboxBuild
#
function Install-Bento
{
    if(!(Test-IsExistEnv -KeyName "POWERCHEF_HOME"))
    {
        Error "The environment attribute named POWERCHEF_HOME is not set.`n（環境変数 POWERCHEF_HOME が設定されていません。）"
        return
    }

    if(!(Test-CanExecute -Command "git.exe"))
    {
        Error "You must install Chocolatery before to install 'Bento'.`n（'Bento' をインストールする前に Git をインストールする必要があります。）"
        return
    }

    Info "Installation of 'Bento' is starting.`n（'Bento' のインストールを開始します。）"
    if(!(Test-IsExistFolder -Path "$env:POWERCHEF_HOME\bento"))
    {
        Sync-GitRepository -RepositoryURL "git://github.com/opscode/bento.git" -DistinationFolderPath "$env:POWERCHEF_HOME\"
    }
    Push-Location
    Set-Location -Path "$env:POWERCHEF_HOME\bento"
    & "bundle.bat" install "--path" "vendor/bundle" "--binstubs"
    Pop-Location
    Install-ChefGemPackage -PackageName "em-winrm"
    Install-ChocolateyPackage -PackageName "JavaRuntime"
    Info "Installation of 'Bento' has finished.`n（'Bento' のインストールが完了しました。）"
 }

#
#.SYNOPSIS
#   This function updates 'Bento'.
#   （'Bento' をアップデートします。）
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
# Install-Bento
#
#.LINK
# Update-Bento
#
#.LINK
# Show-VeeweeDefinitionVboxList
#
#.LINK
# Invoke-VeeweeVboxBuild
#
function Update-Bento
{
    if(!(Test-IsExistEnv -KeyName "POWERCHEF_HOME"))
    {
        Error "The environment attribute named POWERCHEF_HOME is not set.`n（環境変数 POWERCHEF_HOME が設定されていません。）"
        return
    }

    if(!(Test-IsExistFolder -Path "$env:POWERCHEF_HOME\bento"))
    {
        Error "'Bento' is not installed.`n（'Bento' がインストールされていません。）"
        return
    }

    Info "Update of 'Bento' is starting.`n（'Bento' のアップデートを開始します。）"
    Push-Location
    Set-Location -Path "$env:POWERCHEF_HOME\bento"
    Invoke-Execute "bundle.bat" update
    Pop-Location
    Update-ChefGemPackage -PackageName "em-winrm"
    Update-ChocolateyPackage -PackageName "JavaRuntime"
    Info "Update of 'Bento' has finished.`n（'Bento' のアップデートを完了しました。）"
 }

#
#.SYNOPSIS
#   This function show the definited templates of 'Veewee'.
#   （'Veewee' で定義済みのテンプレートを表示します。）
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
# Install-Bento
#
#.LINK
# Update-Bento
#
#.LINK
# Show-VeeweeDefinitionVboxList
#
#.LINK
# Invoke-VeeweeVboxBuild
#
function Show-VeeweeDefinitionVboxList
{
    Get-ChildItem -Path "$env:POWERCHEF_HOME\bento\definitions" | Select-String -Pattern "windows-"
}

#
#.SYNOPSIS
#   This function creates new virtual machine from definited template.
#   （定義済みテンプレートから仮想マシンを作製します。）
#
#.DESCRIPTION
#   None
#   （なし）
#
#.PARAMETER Name
# Specifies the name of definited template. This parameter is required.
# （定義済みテンプレートの名前を指定します。このパラメーターは必須です。）
#
#.INPUTS
#   String
#       This functions inputs the name of definited template from the incoming pipeline.
#       （パイプライン入力から定義済みテンプレートの名前を入力します。）
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
# Install-Bento
#
#.LINK
# Update-Bento
#
#.LINK
# Show-VeeweeDefinitionVboxList
#
#.LINK
# Invoke-VeeweeVboxBuild
#
function Invoke-VeeweeVboxBuild
{
    Param
    (
        [Parameter(Mandatory = $true, Position = 0, ValueFromPipeline = $true)]
        [string]
        [ValidateNotNull()]
        $Name
    )

    if(!(Test-IsExistFolder -Path "$env:POWERCHEF_HOME\bento\definitions\$BoxName"))
    {
        Error "The following definition of virtual machine is not found.`n（下記仮想マシンの定義が見つかりません。）`n`n$Name"
        Show-VeeweeDefinitionVboxList
        return
    }

    Info "Creation of the following virtual machine is starting.`n（下記仮想マシンの作製を開始します。）`n`n$Name"
    try
    {
        Push-Location
        Set-Location -Path "$env:POWERCHEF_HOME\bento"
        Invoke-Execute "bundle.bat" exec veewee vbox build "$Name"
        Pop-Location
    }
    catch
    {
        Error "Creation of the following virtual machine is failed.`n（下記仮想マシンの作製に失敗しました。）`n`n$Name`n`n$Error"
    }
    Info "Creation of the following virtual machine has finished successfully.`n（下記仮想マシンの作製が正常に完了しました。）`n`n$Name"
}

# SIG # Begin signature block
# MIIFcAYJKoZIhvcNAQcCoIIFYTCCBV0CAQExCzAJBgUrDgMCGgUAMGkGCisGAQQB
# gjcCAQSgWzBZMDQGCisGAQQBgjcCAR4wJgIDAQAABBAfzDtgWUsITrck0sYpfvNR
# AgEAAgEAAgEAAgEAAgEAMCEwCQYFKw4DAhoFAAQUHLbx/krF6K//zdQmf+cuOMp+
# tMOgggMaMIIDFjCCAgKgAwIBAgIQliVLy3mu8q1LSkdDsNdvkzAJBgUrDgMCHQUA
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
# BgorBgEEAYI3AgELMQ4wDAYKKwYBBAGCNwIBFTAjBgkqhkiG9w0BCQQxFgQUNvwk
# SNMGbphURfEOBmudRdGzk8IwDQYJKoZIhvcNAQEBBQAEggEAbCzSnm/peU2ikOj8
# CrdR5H5CdVhKH1EUTIVqJ47EP7EIQJQQg6mJwtd10br2FpuhLJLDFYq0MxVH6zs0
# qjYKu1U+KBed4F9acNkNuCrkBSqJvZVKWs/YjM8pAzphNmyp2cTshOWWBC6btZv8
# weqqaJIy50egonYIk/r5NcdaTDVPpmfDPyGV7T0+QVwJ+KTka56kMC/HMhnrgkvy
# FxRiP6qdz2CCygkkTJhtVpmYjQUHqRAO1mudBwDa+epRbdHr1kn0pS0Kn6KGNazO
# TK/cAES/0GtGHEDOKEpwAJsKJsKLEZ62d3m7Sq7TllclJveEB5pZlI0m05OmkVBS
# c8C0ww==
# SIG # End signature block
