#
# Name
#   Vagrant.ps1
#
# Description
#   This defines functions regarding 'Vagrant'.
#   （'Vagrant' に関するファンクションを定義しています。）
#
# Depends
#   .\Log.ps1
#   .\Folder.ps1
#   .\File.ps1
#   .\Execute.ps1
#   .\Env.ps1
#   .\Chocolatey.ps1
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
#   New-HomeVagrantfile
#
# DESCRIPTION（説明）
#   This function creates the 'vagrantfile' of Vagrant home directory.
#   （Vagrantホームディレクトリーの 'vagrantfile' を作製します。）
#
# SYNTAX（構文）
#   New-HomeVagrantfile
#
# PARAMETERS（パラメーター）
#       None
#       （なし）
#
# INPUTS（入力）
#       None
#       （なし）
#
function New-HomeVagrantfile
{
    [String]$vagrantfileContent =@"
# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  # Default machine settings
  # （デフォルトマシン設定）
  # Remarks: Please edit to suit the specifications of the host machine. (e.g. the support of hardware-assisted virtualization.)
  # （備考: 仮想化支援機能の有無等ホストマシンのスペックに合わせて編集してください。）
  config.vm.provider :virtualbox do |vb|
    vb.customize ['modifyvm', :id, '--memory', 3840]
    vb.customize ['modifyvm', :id, '--guestmemoryballoon', 3328] # 64bit OS only support
    vb.customize ['modifyvm', :id, '--cpus', 2]
    vb.customize ['modifyvm', :id, '--cpuexecutioncap', 100]
    vb.customize ['modifyvm', :id, '--hpet', 'on']
    vb.customize ['modifyvm', :id, '--hwvirtex', 'on']
    vb.customize ['modifyvm', :id, '--nestedpaging', 'on']
    vb.customize ['modifyvm', :id, '--largepages', 'on']
    vb.customize ['modifyvm', :id, '--vtxvpid', 'on']
    vb.customize ['modifyvm', :id, '--accelerate3d', 'off']
    vb.customize ['modifyvm', :id, '--accelerate2dvideo', 'off']
    vb.customize ['modifyvm', :id, '--nictype1', '82545EM']
    vb.customize ['modifyvm', :id, '--natdnsproxy1', 'off']
    vb.customize ['modifyvm', :id, '--natdnshostresolver1', 'off']
    vb.customize ['modifyvm', :id, '--nictype2', '82545EM']
    vb.customize ['modifyvm', :id, '--natdnsproxy2', 'off']
    vb.customize ['modifyvm', :id, '--natdnshostresolver2', 'off']
    vb.customize ['modifyvm', :id, '--nictype3', '82545EM']
    vb.customize ['modifyvm', :id, '--natdnsproxy3', 'off']
    vb.customize ['modifyvm', :id, '--natdnshostresolver3', 'off']
    vb.customize ['modifyvm', :id, '--nictype4', '82545EM']
    vb.customize ['modifyvm', :id, '--natdnsproxy4', 'off']
    vb.customize ['modifyvm', :id, '--natdnshostresolver4', 'off']
  end
end
"@

    if(!(Test-IsExistEnv -KeyName "VAGRANT_HOME"))
    {
        Error "The environment attribute named VAGRANT_HOME is not set.`n（環境変数 VAGRANT_HOME が設定されていません。）"
        return
    }

    New-File -Path "$env:VAGRANT_HOME\Vagrantfile" -Value "$vagrantfileContent"
}

#
#.SYNOPSIS
#   This function installs 'Vagrant'.
#   （'Vagrant'をインストールします。）
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
# Install-Vagrant
#
#.LINK
# Update-Vagrant
#
#.LINK
# Open-HomeVagrantfile
#
#.LINK
# New-VagrantBox
#
function Install-Vagrant
{
    if(!(Test-IsExistEnv -KeyName "POWERCHEF_HOME"))
    {
        Error "The environment attribute named POWERCHEF_HOME is not set.`n（環境変数 POWERCHEF_HOME が設定されていません。）"
        return
    }

    if(!(Test-CanExecute -Command "VirtualBox.exe"))
    {
        Error "You must install 'VirtualBox' before to install 'Vagrant'.`n（'Vagrant' をインストールする前に 'VirtualBox' をインストールする必要があります。）"
        return
    }

    Info "Installation of 'Vagrant' is starting.`n（'Vagrant' のインストールを開始します。）"
    Install-ChocolateyPackage -PackageName "Vagrant"

    if(!(Get-Content -Path "$PROFILE" | Select-String -Pattern "PATH.*Vagrant" -Quiet))
    {
        Add-Env -KeyName "PATH" -Value "`$env:SystemDrive\HashiCorp\Vagrant\bin\"
    }

    Install-ChocolateyPackage -PackageName "7Zip"

    if(!(Get-Content -Path "$PROFILE" | Select-String -Pattern "Path.*7-Zip" -Quiet))
    {
        Add-Env -KeyName "Path" -Value "`$env:SystemDrive\Program Files\7-Zip\"
    }

    Install-ChocolateyPackage -PackageName "cwRsync"

    if(!(Get-Content -Path "$PROFILE" | Select-String -Pattern "Path.*cwrsync" -Quiet))
    {
        Add-Env -KeyName "Path" -Value "`$env:SystemDrive\cwrsync\bin\"
    }

    New-Env -KeyName "VAGRANT_HOME" -Value "`$env:POWERCHEF_HOME\var\vagrant"
    New-Folder -Path "$env:VAGRANT_HOME\boxfiles"
    New-HomeVagrantfile
    Invoke-Execute "vagrant.exe" plugin install "vagrant-windows"
    Info "Installation of 'Vagrant' has finished.`n（'Vagrant'のインストールが完了しました。）"
    & "cver.bat" "Vagrant" -localonly
    & "vagrant.exe" plugin list
}

#
#.SYNOPSIS
#   This function updates 'Vagrant'.
#   （'Vagrant' をアップデートします。）
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
# Install-Vagrant
#
#.LINK
# Update-Vagrant
#
#.LINK
# Open-HomeVagrantfile
#
#.LINK
# New-VagrantBox
#
function Update-Vagrant
{
    Update-ChocolateyPackage -PackageName "Vagrant"
    Update-ChocolateyPackage -PackageName "7Zip"
    Update-ChocolateyPackage -PackageName "cwRsync"
    Invoke-Execute "vagrant.exe" plugin update "vagrant-windows"
}

#
#.SYNOPSIS
#   This function opens the 'Vagrantfile' of Vagrant home directory.
#   （Vagrant ホームディレクトリーの 'Vagrantfile' を開きます）
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
# Install-Vagrant
#
#.LINK
# Update-Vagrant
#
#.LINK
# Open-HomeVagrantfile
#
#.LINK
# New-VagrantBox
#
function Open-HomeVagrantfile
{
    if(!(Test-IsExistEnv -KeyName "VAGRANT_HOME"))
    {
        Error "The environment attribute named VAGRANT_HOME is not set.`n（環境変数 VAGRANT_HOME が設定されていません。）"
        return
    }

    if (!(Test-IsExistFile -Path "$env:VAGRANT_HOME\Vagrantfile"))
    {
        New-HomeVagrantfile
    }

    Open-File -Path "$env:VAGRANT_HOME\Vagrantfile"
}

#
#.SYNOPSIS
#   This function creates new Vagrant box from specifies VM.
#   （指定した仮想マシンをベースに Vagrant の Box を作製します。）
#
#.DESCRIPTION
#   None
#   （なし）
#
#.PARAMETER VMName
# Specifies the name of based VM. This parameter is required.
# （ベースとなる仮想マシンの名前を指定します。このパラメーターは必須です。）
#
#.PARAMETER Path
# Specifies the path of Vagrant box file. The default value is '$env:VAGRANT_HOME\boxfiles\$VMName.box'.
# （ Vagrant の Box ファイルのパスを指定します。デフォルト値は '$env:VAGRANT_HOME\boxfiles\$VMName.box' です。）
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
# Install-Vagrant
#
#.LINK
# Update-Vagrant
#
#.LINK
# Open-HomeVagrantfile
#
#.LINK
# New-VagrantBox
#
function New-VagrantBox
{
    Param
    (
        [Parameter(Mandatory = $true, Position = 0, ValueFromPipeline = $true)]
        [string]
        [ValidateNotNull()]
        $VMName,

        [Parameter(Mandatory = $false, Position = 1)]
        [string]
        [ValidateNotNull()]
        [ValidateScript({Test-Path -Path "$_" -IsValid})]
        $BoxFilePath = "$env:VAGRANT_HOME\boxes\$VMName.box"
    )

    [string]$macAddress = (& VBoxManage.exe showvminfo $VMName --machinereadable | Select-String -Pattern "macaddress1=")
    try
    {
        $macAddress = $macAddress.substring(12)
    }
    catch
    {
        Error "MAC address of The following virtual machine is not readable.`n（下記仮想マシンのMACアドレスが読み取れません。）`n`n$VMName`n`n$Error"
        return
    }
    [string]$vagrantfileContent = @"
Vagrant::Config.run do |config|
  # This Vagrantfile is auto-generated by 'vagrant package' to contain
  # the MAC address of the box. Custom configuration should be placed in
  # the actual 'Vagrantfile' in this box.
  config.vm.base_mac = $macAddress
end

# Load include vagrant file if it exists after the auto-generated
# so it can override any of the settings
include_vagrantfile = File.expand_path('../include/_Vagrantfile', __FILE__)
load include_vagrantfile if File.exist?(include_vagrantfile)
"@
    [string]$BoxFileParentFolderPath = Split-Path -Path "$BoxFilePath" -Parent
    [string]$BoxFileName = Split-Path -Path "$BoxFilePath" -Leaf

    if(Test-IsExistFile -Path "$BoxFilePath")
    {
        Warning "The following Vagrant box is already exist.`n（下記 Vagrant の Box は既に存在します。）`n`n$BoxFilePath"
        return
    }

    Info "Creation of the following box of Vagrant is starting.`n（下記 Vagrant の Box の作製を開始します。）`n`n$BoxFilePath"
    & "VBoxManage.exe" controlvm "$VMName" acpipowerbutton
    Start-Sleep -Seconds 60
    New-File -Path "$env:VAGRANT_HOME\tmp\$VMName\Vagrantfile" -Value "$vagrantfileContent"
    Invoke-Execute "VBoxManage.exe" "export" "$VMName" "--output" "$env:VAGRANT_HOME\tmp\$VMName\box.ovf"
    Invoke-Execute "7z.exe" a "-ttar" "$BoxFilePath" "$env:VAGRANT_HOME\tmp\$VMName\*"
    Push-Location
    Set-Location -Path "$BoxFileParentFolderPath"
    Invoke-Execute "vagrant.exe" box add "$VMName" "$BoxFileName"
    Pop-Location
    Info "Creation of the following box of Vagrant has finished.`n（下記 Vagrant の Box の作製が完了しました。）`n`n$BoxFilePath"
}

# SIG # Begin signature block
# MIIFcAYJKoZIhvcNAQcCoIIFYTCCBV0CAQExCzAJBgUrDgMCGgUAMGkGCisGAQQB
# gjcCAQSgWzBZMDQGCisGAQQBgjcCAR4wJgIDAQAABBAfzDtgWUsITrck0sYpfvNR
# AgEAAgEAAgEAAgEAAgEAMCEwCQYFKw4DAhoFAAQU65A8rur+w02Ix1fLCOVNTAV3
# FySgggMaMIIDFjCCAgKgAwIBAgIQliVLy3mu8q1LSkdDsNdvkzAJBgUrDgMCHQUA
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
# BgorBgEEAYI3AgELMQ4wDAYKKwYBBAGCNwIBFTAjBgkqhkiG9w0BCQQxFgQU+mik
# rhAqB3N/qqUvE6YqnUNGIqowDQYJKoZIhvcNAQEBBQAEggEAq51nyHzJ5zlGEH3x
# uZHhZugePmJxNxjyQ2ek0UJ1CylBYV70GxhFMoqlKRt5kl3Ovxvlpx3tdsEkvSBZ
# FlakThwlbtEV2kzz2Y+ZkTyGkhL/DcfmRRsaQun+mPVClcfgsbBQmZhVryBCh+UC
# g6/Ly0j/9GXjXuNjBn8I+F49Qi8VFy2pmFyPuY5eu+vP12uJVpOja+5Eu5eHNHqV
# fRr8ZfBZxPcfYqvX38plrJjdvwq1qKY1sqeqPlKbMpng6s+h1C6WiOWpEnzcXgjt
# VlWsl+A79eQiz58qZ5PsRuK/Zn5owyAup/N04UEtn2sEN/OBeZAqjBR6KLAnpuh0
# +BDwpw==
# SIG # End signature block
