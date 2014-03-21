#
# Name
#   Serverspec.ps1
#
# Description
#   This defines functions regarding 'serverspec'.
#   （'serverspec' に関するファンクションを定義しています。）
#
# Depends
#   .\Log.ps1
#   .\Execute.ps1
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
#   This function installs 'serverspec'.
#   （'serverspec' をインストールします。）
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
# Install-Serverspec
#
#.LINKG
# Update-Serverspec
#
function Install-Serverspec
{
    Install-ChefGemPackage -PackageName "serverspec"
	Invoke-Execute "gem.bat" uninstall "rspec-core" "-aIx" 
	Invoke-Execute "gem.bat" install "rspec-core" "-v" "2.14.7" "--no-rdoc" "--no-ri"
}

#
#.SYNOPSIS
#   This function updates Serverspec.
#   （Serverspecをアップデートします。）
#
#.DESCRIPTION
#   None
#   （なし）
#
#.PARAMETER PowerChefHomePath
# Specifies the key path of POWERCHEF_USER_HOME folder. Default value is $HOME.
# （POWERCHEF_HOMEフォルダーのパス指定します。デフォルト値は$HOMEです。）
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
# Install-Serverspec
#
#.LINKG
# Update-Serverspec
#
function Update-Serverspec
{
    Update-ChefGemPackage -PackageName "serverspec"
	Invoke-Execute "gem.bat" uninstall "rspec-core" "-aIx" 
	Invoke-Execute "gem.bat" install "rspec-core" "-v" "2.14.7" "--no-rdoc" "--no-ri"
}

# SIG # Begin signature block
# MIIFcAYJKoZIhvcNAQcCoIIFYTCCBV0CAQExCzAJBgUrDgMCGgUAMGkGCisGAQQB
# gjcCAQSgWzBZMDQGCisGAQQBgjcCAR4wJgIDAQAABBAfzDtgWUsITrck0sYpfvNR
# AgEAAgEAAgEAAgEAAgEAMCEwCQYFKw4DAhoFAAQU1jWO4y4nlnuznX/lUnwAY8nW
# nfegggMaMIIDFjCCAgKgAwIBAgIQliVLy3mu8q1LSkdDsNdvkzAJBgUrDgMCHQUA
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
# BgorBgEEAYI3AgELMQ4wDAYKKwYBBAGCNwIBFTAjBgkqhkiG9w0BCQQxFgQUxYOw
# 8mwoRFoqI5HcBsFF0iX3hrowDQYJKoZIhvcNAQEBBQAEggEAUsRQhPgUU1i0l1p6
# Iq2LiES79oCrsptFs2jlkgbeR7+d6bBaMknd4ig6qsxu4OsTSzC4Xv4QAlQHBbDa
# 7d8OWtaDqmW/SkOnrFeh2OdS4wcx00dYLvDVuOydOu+udgP3bhaamwn3sda4xgb7
# 54l83gaWvFtxpggA/lycv63K1EDqmeLGRkp+COTRhRr+rQk7a9LuYepWl4gLetw8
# 8s3QDWCEx2+9Yl7hrmBxXlezZSkaa7CPjMHp+2DPNlp4X+AFHAU3ENtSf1UwE7h6
# YTMSVFadFvZLH8CWyfef8UCa1cuCJsUSDPBKNdhHQWZMY28jT1D5vybh1Yvb1x6t
# zz0O7A==
# SIG # End signature block
