#
# Name
#   Cookbook.ps1
#
# Description
#   This defines functions regarding Cookbooks of Chef.
#   （Chef の Cookbook に関するファンクションを定義しています。）
#
# Depends
#   .\Log.ps1
#   .\Folder.ps1
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
#   New-CookbookReadme
#
# DESCRIPTION（説明）
#   Specifies the name of cookbook. This parameter is required.
#   （クックブックの名前を指定します。このパラメーターは必須です。）
#
# SYNTAX（構文）
#   New-CookbookReadme
#
# PARAMETERS（パラメーター）
#   -CookbookName
#       Specifies the name of cookbook. This parameter is required.
#       （クックブックの名前を指定します。このパラメーターは必須です。）
#
#   -Maintainer
#       Specifies the maintainer of cookbook.
#       （クックブックの作成者の名前を指定します。）
#
#   -MaintainerEmail
#       Specifies the maintainer's e-mail address.
#       （クックブックの作成者の E-mail アドレスを指定します。）
#
# INPUTS（入力）
#   Object
#       This function inputs values from a property of the incoming pipeline object that has the same name as this parameter.
#       （パラメータと同じ名前を持つ、パイプライン入力オブジェクトのプロパティから値を入力します。）
#
# OUTPUTS（出力）
#       None
#       （なし）
#
function New-CookbookReadme
{
    Param
    (
        [Parameter(Mandatory = $true, Position = 0, ValueFromPipelineByPropertyName = $true)]
        [string]
        [ValidateNotNull()]
        $CookbookName,

        [Parameter(Mandatory = $false, Position = 1, ValueFromPipelineByPropertyName = $true)]
        [string]
        [ValidateNotNull()]
        $Maintainer = "xxxxxxx xxxxxx",

        [Parameter(Mandatory = $false, Position = 2, ValueFromPipelineByPropertyName = $true)]
        [string]
        [ValidateNotNull()]
        $MaintainerEmail = "xxxxxxxx@xxxxxx.xx"
    )

    [String]$ReadMeContent = @"
# $CookbookName cookbook

TODO: Enter the cookbook description here.

## Requirements

### Platform Requirements

TODO: List your supported platforms.

example

This cookbook maybe requires the following platform.

* Windows 7 SP1 （x86,x64)
* Windows 8 （x86,x64)
* Windows 8.1 （x86,x64)
* Windows Server 2012 RTC
* Windows Server 2012 R2

This cookbook has tested on the following platform.

* Windows 7 SP1 （x86)
* Windows 8.1 （x64)
* Windows Server 2012 R2

### Depended Cookbooks
This cookbook requires the following cookbooks.

* xxxxxx

## Attributes

<table>
  <tr>
    <th>Key</th>
    <th>Type</th>
    <th>Description</th>
    <th>Default</th>
  </tr>
  <tr>
    <td><tt>['$CookbookName']['xxxxx']</tt></td>
    <td>Boolean</td>
    <td>xxxxxxxx</td>
    <td><tt>true</tt></td>
  </tr>
</table>

## Recipes

* `default.rb`

TODO: Write the description about the recipe.

## Authors & License

* Author:: $Maintainer (<$MaintainerEmail>)

TODO: Write the description about license or rights.

"@

    if((Split-Path -Path "$PWD" -Leaf) -ne "chef-repo")
    {
        Error "Current directory is not 'chef-repo'.（カレントディレクトリが 'chef-repo' ではありません。）"
        return
    }

    if(!(Test-ExistsFolder -Path "$PWD\site-cookbooks\$CookbookName"))
    {
        Warning "Specifies name of cookbook is not found.`n（指定されたクックブックが見つかりません。）`n`n$CookbookName"
        return
    }

    New-File -Path "$PWD\site-cookbooks\$CookbookName\README.md" -Value "$ReadmeContent"
}

#
#.SYNOPSIS
#   This function creates the Cookbook template.
#   （クックブックのテンプレートを作製します。）
#
#.DESCRIPTION
#   None
#   （なし）
#
#.PARAMETER CookbookName
# Specifies the name of cookbook. This parameter is required.
# （クックブックの名前を指定します。このパラメーターは必須です。）
#
#.PARAMETER Maintainer
# Specifies the maintainer of cookbook. The default value is null character.
# （クックブックの作成者の名前を指定します。デフォルト値は空文字です。）
#
#.PARAMETER MaintainerEmail
# Specifies the maintainer's e-mail address. The default value is null character.
# （クックブックの作成者の E-mail アドレスを指定します。デフォルト値は空文字です。）
#
#.PARAMETER License
# Specifies license of cookbook.  Valid values ​​are "apachev2", "gplv2", "gplv3", "mit" and "reserved". The default value is "apachev2".
# （クックブックのライセンスを指定します。有効な値は "apachev2"、"gplv2"、"gplv3"、"mit"、reserved" です。デフォルト値は "apachev2" です。）
#
#.INPUTS
#   String
#       This functions inputs the name of cookbook from the incoming pipeline.
#       （パイプライン入力からクックブックの名前を入力します。）
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
# New-Cookbook
#
#.LINK
# Show-CookbookList
#
#.LINK
# Open-CookbookMetadata
#
#.LINK
# Open-CookbookReadme
#
#.LINK
# New-CookbookRecipe
#
#.LINK
# Open-CookbookRecipe
#
#.LINK
# Update-Cookbook
#
function New-Cookbook
{
    Param
    (
        [Parameter(Mandatory = $true, Position = 0, ValueFromPipeline = $true)]
        [string]
        [ValidateNotNull()]
        $CookbookName,

        [Parameter(Mandatory = $true, Position = 1)]
        [string]
        [ValidateNotNull()]
        $Maintainer = "",

        [Parameter(Mandatory = $true, Position = 2)]
        [string]
        [ValidateNotNull()]
        $MaintainerEmail = "",

        [Parameter(Mandatory = $false, Position = 3)]
        [string]
        [ValidateNotNull()]
        [ValidateSet("apachev2", "gplv2", "gplv3", "mit", "reserved") ]
        $License = "apachev2"
    )

    if((Split-Path -Path "$PWD" -Leaf) -ne "chef-repo")
    {
        Error "Current directory is not 'chef-repo'.（カレントディレクトリが 'chef-repo' ではありません。）"
        return
    }

    if(Test-ExistsFolder -Path "$PWD\site-cookbooks\$CookbookName")
    {
        Warning "Specifies name of cookbook already exists.`n（指定された名前のクックブックが既に存在します。）`n`n$CookbookName"
        return
    }

    Info "Creation of the cookbook template is starting.`n（クックブックのテンプレートの作製を開始します。）"
    Push-Location
    Set-Location -Path "$PWD\site-cookbooks"
    Invoke-Execute "berks" cookbook "$CookbookName" "--skip-vagrant" "--skip-git" "--skip-test-kitchen" "--license=$License" "--maintainer=$Maintainer" "--maintainer-email=$MaintainerEmail"
    Pop-Location
    Remove-Item -Path "$PWD\site-cookbooks\$CookbookName\README.md"
    New-CookbookReadme -CookbookName "$CookbookName" -Maintainer "$Maintainer" -MaintainerEmail "$MaintainerEmail"
    Write-Host  ""
    Write-Host  "Cookbook folder structure:"
    Write-Host  "--------------------------"
    & "tree.com " /f "$PWD\site-cookbooks\$CookbookName"
    Write-Host  ""
    Write-Host  "Cookbook metadata:"
    Write-Host  "------------------"
    Get-Content -Path "$PWD\site-cookbooks\$CookbookName\metadata.rb" -Raw
    Info "Creation of the cookbook template has finished.`n（クックブックのテンプレートの作製が完了しました。）"
}

#
#.SYNOPSIS
#   This function shows the list of Cookbooks.
#   （クックブックの一覧を表示します。）
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
# New-Cookbook
#
#.LINK
# Show-CookbookList
#
#.LINK
# Open-CookbookMetadata
#
#.LINK
# Open-CookbookReadme
#
#.LINK
# New-CookbookRecipe
#
#.LINK
# Open-CookbookRecipe
#
#.LINK
# Update-Cookbook
#
function Show-CookbookList
{
    if((Split-Path -Path "$PWD" -Leaf) -ne "chef-repo")
    {
        Error "Current directory is not 'chef-repo'.（カレントディレクトリが 'chef-repo' ではありません。）"
        return
    }

    Get-Item -Path "$PWD\*cookbooks\*" -Exclude "README.md" | Format-Table -Property Name,Parent,CreationTime,LastWriteTime,LastAccessTime -AutoSize
}

#
#.SYNOPSIS
#   This function opens metadata.rb of the cookbook.
#   （クックブックのmetadata.rbを開きます。）
#
#.DESCRIPTION
#   None
#   （なし）
#
#.PARAMETER CookbookName
# Specifies name of cookbook. This parameter is required.
# （クックブックの名前を指定します。このパラメーターは必須です。）
#
#.INPUTS
#   String
#       This functions inputs the name of cookbook from the incoming pipeline.
#       （パイプライン入力からクックブックの名前を入力します。）
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
# New-Cookbook
#
#.LINK
# Show-CookbookList
#
#.LINK
# Open-CookbookMetadata
#
#.LINK
# Open-CookbookReadme
#
#.LINK
# New-CookbookRecipe
#
#.LINK
# Open-CookbookRecipe
#
#.LINK
# Update-Cookbook
#
function Open-CookbookMetadata
{
    Param
    (
        [Parameter(Mandatory = $true, Position = 0, ValueFromPipeline = $true)]
        [string]
        [ValidateNotNull()]
        $CookbookName
    )

    if((Split-Path -Path "$PWD" -Leaf) -ne "chef-repo")
    {
        Error "Current directory is not 'chef-repo'.（カレントディレクトリが 'chef-repo' ではありません。）"
        return
    }

    if(!(Test-ExistsFolder -Path "$PWD\site-cookbooks\$CookbookName"))
    {
        Error "Specifies name of cookbook is not found.`n（指定されたクックブックが見つかりません。）`n`n$CookbookName"
        return
    }

    Open-File -Path "$PWD\site-cookbooks\$CookbookName\metadata.rb"
}

#
#.SYNOPSIS
#   This function opens the README.md of the cookbook.
#   （クックブックのREADME.mdを開きます。）
#
#.DESCRIPTION
#   None
#   （なし）
#
#.PARAMETER CookbookName
# Specifies name of cookbook. This parameter is required.
# （クックブックの名前を指定します。このパラメーターは必須です。）
#
#.INPUTS
#   String
#       This functions inputs the name of cookbook from the incoming pipeline.
#       （パイプライン入力からクックブックの名前を入力します。）
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
# New-Cookbook
#
#.LINK
# Show-CookbookList
#
#.LINK
# Open-CookbookMetadata
#
#.LINK
# Open-CookbookReadme
#
#.LINK
# New-CookbookRecipe
#
#.LINK
# Open-CookbookRecipe
#
#.LINK
# Update-Cookbook
#
function Open-CookbookReadme
{
    Param
    (
        [Parameter(Mandatory = $true, Position = 0, ValueFromPipeline = $true)]
        [string]
        [ValidateNotNull()]
        $CookbookName
    )

    if((Split-Path -Path "$PWD" -Leaf) -ne "chef-repo")
    {
        Error "Current directory is not 'chef-repo'.（カレントディレクトリが 'chef-repo' ではありません。）"
        return
    }

    if(!(Test-ExistsFolder -Path "$PWD\site-cookbooks\$CookbookName"))
    {
        Error "Specifies name of cookbook is not found.`n（指定されたクックブックが見つかりません。）`n`n$CookbookName"
        return
    }

    if(!(Test-ExistsFile -Path "$PWD\site-cookbooks\$CookbookName\README.md"))
    {
        New-CookbookReadme -CookbookName "$CookbookName"
    }

    Open-File -Path "$PWD\site-cookbooks\$CookbookName\README.md"
}

#
#.SYNOPSIS
#   This function creates the recipe of the cookbook.
#   （クックブックのレシピを作製します。）
#
#.DESCRIPTION
#   None
#   （なし）
#
#.PARAMETER CookbookName
# Specifies name of cookbook. This parameter is required.
# （クックブックの名前を指定します。このパラメーターは必須です。）
#
#.PARAMETER RecipeName
# Specifies name of recipe. The default value is "default".
# （レシピの名前を指定します。デフォルト値は”default”です。）
#
#.INPUTS
#   String
#       This functions inputs the name of cookbook from the incoming pipeline.
#       （パイプライン入力からクックブックの名前を入力します。）
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
# New-Cookbook
#
#.LINK
# Show-CookbookList
#
#.LINK
# Open-CookbookMetadata
#
#.LINK
# Open-CookbookReadme
#
#.LINK
# New-CookbookRecipe
#
#.LINK
# Open-CookbookRecipe
#
#.LINK
# Update-Cookbook
#
function New-CookbookRecipe
{
    Param
    (
        [Parameter(Mandatory = $true, Position = 0, ValueFromPipeline = $true)]
        [string]
        [ValidateNotNull()]
        $CookbookName,

        [Parameter(Mandatory = $false, Position = 1)]
        [string]
        [ValidateNotNull()]
        [ValidatePattern("^.*\.rb$")]
        $RecipeName = "default.rb"
    )

    [String]$RecipeContent = @"
#
# Cookbook Name:: $CookbookName
# Recipe:: $RecipeName
#
# Copyright (C)
#
"@

    if((Split-Path -Path "$PWD" -Leaf) -ne "chef-repo")
    {
        Error "Current directory is not 'chef-repo'.（カレントディレクトリが 'chef-repo' ではありません。）"
        return
    }

    if(!(Test-ExistsFolder -Path "$PWD\site-cookbooks\$CookbookName"))
    {
        Error "Specifies name of cookbook is not found.`n（指定されたクックブックが見つかりません。）`n`n$CookbookName"
        return
    }

    New-File -Path "$PWD\site-cookbooks\$CookbookName\recipes\$RecipeName" -Value "$RecipeContent"
}

#
#.SYNOPSIS
#   This function opens the recipe of the cookbook.
#   （クックブックのレシピを開きます。）
#
#.DESCRIPTION
#   None
#   （なし）
#
#.PARAMETER CookbookName
# Specifies name of cookbook. This parameter is required.
# （クックブックの名前を指定します。このパラメーターは必須です。）
#
#.PARAMETER RecipeName
# Specifies name of recipe. The default value is "default".
# （レシピの名前を指定します。デフォルト値は”default”です。）
#
#.INPUTS
#   String
#       This functions inputs the name of cookbook from the incoming pipeline.
#       （パイプライン入力からクックブックの名前を入力します。）
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
# New-Cookbook
#
#.LINK
# Show-CookbookList
#
#.LINK
# Open-CookbookMetadata
#
#.LINK
# Open-CookbookReadme
#
#.LINK
# New-CookbookRecipe
#
#.LINK
# Open-CookbookRecipe
#
#.LINK
# Update-Cookbook
#
function Open-CookbookRecipe
{
    Param
    (
        [Parameter(Mandatory = $true, Position = 0, ValueFromPipeline = $true)]
        [string]
        [ValidateNotNull()]
        $CookbookName,

        [Parameter(Mandatory = $false, Position = 1)]
        [string]
        [ValidateNotNull()]
        [ValidatePattern("^.*\.rb$")]
        $RecipeName = "default.rb"
    )

    if((Split-Path -Path "$PWD" -Leaf) -ne "chef-repo")
    {
        Error "Current directory is not 'chef-repo'.（カレントディレクトリが 'chef-repo' ではありません。）"
        return
    }

    if(!(Test-ExistsFolder -Path "$PWD\site-cookbooks\$CookbookName"))
    {
        Error "Specifies name of cookbook is not found.`n（指定されたクックブックが見つかりません。）`n`n$CookbookName"
        return
    }

    Open-File -Path "$PWD\site-cookbooks\$CookbookName\recipes\$RecipeName"
}

#
#.SYNOPSIS
#   This function upload  the cookbook to Chef Server.
#   （クックブックを Chef Server にアップロードします）
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
# New-Cookbook
#
#.LINK
# Show-CookbookList
#
#.LINK
# Open-CookbookMetadata
#
#.LINK
# Open-CookbookReadme
#
#.LINK
# New-CookbookRecipe
#
#.LINK
# Open-CookbookRecipe
#
#.LINK
# Update-Cookbook
#
function Update-Cookbook
{
    Param
    (
        [Parameter(Mandatory = $true, Position = 0, ValueFromPipeline = $true)]
        [string]
        [ValidateNotNull()]
        $CookbookName
    )

    if((Split-Path -Path "$PWD" -Leaf) -ne "chef-repo")
    {
        Error "Current directory is not 'chef-repo'.（カレントディレクトリが 'chef-repo' ではありません。）"
        return
    }

    if(!(Test-ExistsFolder -Path "$PWD\site-cookbooks\$CookbookName"))
    {
        Error "Specifies name of cookbook is not found.`n（指定されたクックブックが見つかりません。）`n`n$CookbookName"
        return
    }

    Info "Uploading of the cookbook is starting.`n（クックブックのアップロードを開始します。）"
    Invoke-Execute "berks" install "--berksfile=site-cookbooks/$CookbookName/Berksfile"
    Invoke-Execute "berks" upload "--berksfile=site-cookbooks/$CookbookName/Berksfile" "--no-freeze"
    Info "Uploading of the cookbook has finished.`n（クックブックのアップロードが完了しました。）"
    & "knife" cookbook list
}

Set-Alias -Name "Upload-Cookbook" -Value "Update-Cookbook"

# SIG # Begin signature block
# MIIFcAYJKoZIhvcNAQcCoIIFYTCCBV0CAQExCzAJBgUrDgMCGgUAMGkGCisGAQQB
# gjcCAQSgWzBZMDQGCisGAQQBgjcCAR4wJgIDAQAABBAfzDtgWUsITrck0sYpfvNR
# AgEAAgEAAgEAAgEAAgEAMCEwCQYFKw4DAhoFAAQU+EgprqiLoGUvc0OaaF4ApzuM
# cOqgggMaMIIDFjCCAgKgAwIBAgIQliVLy3mu8q1LSkdDsNdvkzAJBgUrDgMCHQUA
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
# BgorBgEEAYI3AgELMQ4wDAYKKwYBBAGCNwIBFTAjBgkqhkiG9w0BCQQxFgQU38xu
# 0g2Vz8oG9rEQbLCnmEID+8YwDQYJKoZIhvcNAQEBBQAEggEAiULRYuLjR75VmDd2
# ccXRMAwphWFjioSDSrpzoZId18a1pGd2eB5XAW5FguUN7XcJ8lpb6tgxipUALwfk
# ECGLhQ63vbAZwy9yHg2VNDI4P629fQlYZiTbDgwDG7yPkJKBZlRNAWRaUT5fStEq
# HqODjLQhVPOjrvbe8xjtV73YNgiraZEKdweVlnyz2QJ1KRFwZE6cu3vJhmRbCmrj
# VX/i8oAlLIG56DClGkRQ69ylxjaIdSrqXXaAZ4GOX/RBg1xbIc5XePGjvqlMBCm6
# LBJxvzU7IAsaY1L34DqXVJhuVI+rEz6eLjQti5Y7HjKnvPtf+F6DpH1c1LWYW68K
# 2XuScA==
# SIG # End signature block
