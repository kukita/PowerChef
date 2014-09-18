#
# Name
#   Berkshelf.ps1
#
# Description
#   This defines functions regarding 'Berkshelf'.
#   （'Berkshelf' に関するファンクションを定義しています。）
#
# Depends
#   .\Log.ps1
#   .\Folder.ps1
#   .\Execute.ps1
#   .\Env.ps1
#   .\Chef.ps1
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
#   This function installs 'Berkshelf'.
#   （'Berkshelf' をインストールします。）
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
# Install-Berkshelf
#
#.LINK
# Update-Berkshelf
#
function Install-Berkshelf
{
    if(!(Test-CanExecute -Command "gem.bat"))
    {
        Error "You must run `Install-Chef` before to install 'Berkshelf'.`n（'$Berkshelf' をインストールする前に `Install-Chef` を実行する必要があります。）"
        return
    }

    if(Test-IsInstalledChefGemPackage -PackageName "berkshelf")
    {
        Warning "The following package is already installed.`n（下記パッケージは既にインストールされています。）`n`nBerkshelf"
        return
    }

    Info "Installation of the following package is starting.`n（下記パッケージのインストールを開始します。）`n`nBerkshelf"
    & "$env:SystemDrive\opscode\chef\embedded\bin\gem.bat" install "buff-extensions" -v "0.5.0" --no-ri --no-rdoc
    & "$env:SystemDrive\opscode\chef\embedded\bin\gem.bat" install "varia_model" -v "0.3.2" --no-ri --no-rdoc
    & "$env:SystemDrive\opscode\chef\embedded\bin\gem.bat" install "berkshelf" -v "2.0.16" --no-ri --no-rdoc
    if($LASTEXITCODE -ne 0)
    {
        Error "Installation of the following package is faild.`n（下記パッケージのインストールに失敗しました。）`n`nBerkshelfe`n`nExit code: $LASTEXITCODE"
        return
    }
    Info "Installation of the following package has finished successfully.`n（下記パッケージのインストールが正常に完了しました。）`nBerkshelf"
}

#
#.SYNOPSIS
# This function updates 'Berkshelf'.
# （'Berkshelf' をアップデートします。）
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
# Install-Berkshelf
#
#.LINK
# Update-Berkshelf
#
function Update-Berkshelf
{
    Install-Berkshelf
}

# SIG # Begin signature block
# MIIFcAYJKoZIhvcNAQcCoIIFYTCCBV0CAQExCzAJBgUrDgMCGgUAMGkGCisGAQQB
# gjcCAQSgWzBZMDQGCisGAQQBgjcCAR4wJgIDAQAABBAfzDtgWUsITrck0sYpfvNR
# AgEAAgEAAgEAAgEAAgEAMCEwCQYFKw4DAhoFAAQUaqkpukQ1lOxa+Mt709vtQgP7
# S66gggMaMIIDFjCCAgKgAwIBAgIQliVLy3mu8q1LSkdDsNdvkzAJBgUrDgMCHQUA
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
# BgorBgEEAYI3AgELMQ4wDAYKKwYBBAGCNwIBFTAjBgkqhkiG9w0BCQQxFgQUD7vu
# +8vKzJCainivSMguqWwyC5kwDQYJKoZIhvcNAQEBBQAEggEApYQvI1o2VBSLF6JM
# M7lKxmGWEyBbgL4Ma54WM5l27oDmatDabRx48qXIrWf42zaEei7QhFW6PKrOh526
# Q0o1y33+MvLZ/lpvZNGaXTOytkKcCmeixrCRu214bTvrwjfCxVmLiIrGapiUnoj/
# 9NOSJ8w2alWPDdLkB/AdlX1wY10m2ETj/FxNFxCt9U+UjtUlKHiYhnNUNFiyl2T8
# AAFxylFoEqqHSzdPFYa7DBRq89PEYhqH9oT3e8cv1WoBf2ObqodkDyLbOqIW2AO8
# jLQ4hrF5KulGz+7LwZBuGoD6X0llyKtevQJwI2Iaj5cnNk7XtXfZzNvQEOexcyqP
# WaSSgQ==
# SIG # End signature block
