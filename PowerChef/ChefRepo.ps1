#
# Name
#   ChefRepo.ps1
#
# Description
#   This defines functions regarding chef-repo.
#   （chef-repo に関するファンクションを定義しています。）
#
# Depends
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
#   This function shows the list of chef-repo.
#   （chef-repo の一覧を表示します。）
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
# Show-ChefRepoList
#
#.LINK
# New-ChefRepo
#
#.LINK
# Get-ChefRepoPath
#
function Show-ChefRepoList
{
    Get-Item -Path "$env:POWERCHEF_HOME\chef-repositories\*" | `
            Format-Table -Property Name,CreationTime,LastWriteTime,LastAccessTime -AutoSize
}

#
#.SYNOPSIS
#   This function creates a new chef-repo.
#   （chef-repo を作製します。）
#
#.DESCRIPTION
#   None
#   （なし）
#
#.PARAMETER SystemName
# Specifies name of system. This parameter is required.
# （システムの名前を指定します。このパラメーターは必須です。）
#
#.INPUTS
#   String
#       This functions inputs the name of system from the incoming pipeline.
#       （パイプライン入力からシステムの名前を入力します。）
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
# Show-ChefRepoList
#
#.LINK
# New-ChefRepo
#
#.LINK
# Get-ChefRepoPath
#
function New-ChefRepo
{
    Param
    (
        [Parameter(Mandatory = $false, Position = 0)]
        [string]
        [ValidateNotNull()]
        $SystemName
    )

    [string]$kniferbContent = @"
current_dir = File.dirname(__FILE__)
chef_server_url 'http://192.168.56.1:8889'
node_name '$env:COMPUTERNAME'
client_key '$env:SystemDrive\chef\validation.pem'
cookbook_path [
  '#{current_dir}\..\cookbooks',
  '#{current_dir}\..\site-cookbooks'
]
knife[:berkshelf_path] = '$env:BERKSHELF_PATH'
"@

    if(!(Test-IsExistEnv -KeyName "POWERCHEF_HOME"))
    {
        Error "The environment attribute named POWERCHEF_HOME is not set.`n（環境変数POWERCHEF_HOMEが設定されていません。）"
        return
    }

    if(Test-IsExistFolder -Path "$env:POWERCHEF_HOME\chef-repositories\$SystemName\chef-repo")
    {
        Warning "The following repository is already exist.`n（下記リポジトリは既に存在します。）`n`n$SystemName\chef-repo"
        Get-ChefRepoPath -SystemName "$SystemName"
        return
    }

    Info "Creation of the following repository is starting.`n（下記リポジトリの作製を開始します。）`n`n$SystemName\chef-repo"
    New-Folder -Path "$env:POWERCHEF_HOME\chef-repositories\$SystemName"
    Sync-GitRepository -RepositoryURL "git://github.com/opscode/chef-repo.git" -DistinationFolderPath "$env:POWERCHEF_HOME\chef-repositories\$SystemName\"
    Remove-Item -Path "$env:POWERCHEF_HOME\chef-repositories\$SystemName\chef-repo\.git" -Recurse -Force
    Remove-Item -Path "$env:POWERCHEF_HOME\chef-repositories\$SystemName\chef-repo\.gitignore"
    New-Folder -Path "$env:POWERCHEF_HOME\chef-repositories\$SystemName\chef-repo\site-cookbooks"
    New-Folder -Path "$env:POWERCHEF_HOME\chef-repositories\$SystemName\chef-repo\nodes"
    New-Folder -Path "$env:POWERCHEF_HOME\chef-repositories\$SystemName\chef-repo\.chef"
    New-File -Path "$env:POWERCHEF_HOME\chef-repositories\$SystemName\chef-repo\.chef\knife.rb" -Value "$kniferbContent"
    Info "Creation of the following repository has finished.`n（下記リポジトリの作製が完了しました。）`n`n$SystemName\chef-repo"
}

#
#.SYNOPSIS
#   This function returnss the path of chef-repo.
#   （chef-repo のパスを返します。）
#
#.DESCRIPTION
#   None
#   （なし）
#
#.PARAMETER SystemName
# Specifies the name of system. This parameter is required.
# （システム名を指定します。このパラメーターは必須です。）
#
#.INPUTS
#   String
#       This functions inputs the name of system from the incoming pipeline.
#       （パイプライン入力からシステムの名前を入力します。）
#
#.OUTPUTS
#   String
#       This function returnss the path of chef-repo.
#       （chef-repo のパスを返します。）
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
# Show-ChefRepoList
#
#.LINK
# New-ChefRepo
#
#.LINK
# Get-ChefRepoPath
#
function Get-ChefRepoPath
{
    Param
    (
        [Parameter(Mandatory = $true, Position = 0, ValueFromPipeline = $true)]
        [string]
        [ValidateNotNull()]
        $SystemName
    )

    if(!(Test-IsExistFolder -Path "$env:POWERCHEF_HOME\chef-repositories\$SystemName\chef-repo"))
    {
        Error "The following repository  is not found.`n（下記レポジトリが見つかりません。）`n`n$SystemName\chef-repo"
        return
    }

    return "$env:POWERCHEF_HOME\chef-repositories\$SystemName\chef-repo"
}

# SIG # Begin signature block
# MIIFcAYJKoZIhvcNAQcCoIIFYTCCBV0CAQExCzAJBgUrDgMCGgUAMGkGCisGAQQB
# gjcCAQSgWzBZMDQGCisGAQQBgjcCAR4wJgIDAQAABBAfzDtgWUsITrck0sYpfvNR
# AgEAAgEAAgEAAgEAAgEAMCEwCQYFKw4DAhoFAAQUpLkd+55x+XPge1LCTP7IvgmY
# htqgggMaMIIDFjCCAgKgAwIBAgIQliVLy3mu8q1LSkdDsNdvkzAJBgUrDgMCHQUA
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
# BgorBgEEAYI3AgELMQ4wDAYKKwYBBAGCNwIBFTAjBgkqhkiG9w0BCQQxFgQUSeic
# wSLDKX5kIIxK0a6Fm03/tewwDQYJKoZIhvcNAQEBBQAEggEAAETxConfI4q+MOAs
# VQawZouLo52qPfGOTjINI3f3davSBDz4VeXVab5ioiELRX0Hh7+02C++Vy/jE/oy
# Mjm5d2gjorwAnxdLxtuyj1DqMoyTHOpjkKtf2jcK/siOhHJyR86zfCkxX0vxV4AG
# dJcn2/bi2RLpndbk/cQVw88x57QefYdZeE5WXO/cORpBmOsJhldHjIWfQYPlqzOl
# eQHXxsQ8IA+jX+3lrZcH9txUuXKmsuDZsPPipri22cF9kpcW5ptab82uZ1IFmePY
# UxzFLJnjQhwpUA5OGGhHh9KDi99ZSiZrNRZDzC6+P9X1Um+GGV7M8oHaYOw6q0M0
# fe85cA==
# SIG # End signature block
