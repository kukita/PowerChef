#
# Name
#   ChefNode.ps1
#
# Description
#   This defines functions regarding 'Chef node'.
#   （'Chef Node' に関するファンクションを定義しています。）
#
# Depends
#   .\Serverspec.ps1
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
#   This function creates the spec file of serverspec.
#   （serverspec の spec ファイルを作製します。）
#.DESCRIPTION
#   None
#   （なし）
#
#.PARAMETER NodeName
# Specifies the name of the node.This parameter is required.
# （ノード名を指定します。このパラメーターは必須です。）
#
#.PARAMETER IPAddress
# Specifies the IP address. This parameter is required.
# （IPアドレスを指定します。このパラメーターは必須です。）
#
#.PARAMETER Environment
# Specifies the name of the environment. Valid values ​​are "development", "test" and "production". The default value is "development".
# （環境名を指定します。有効な値は "development"、"test"、"production" です。デフォルト値は "development" です。）
#
#.PARAMETER SpecFileName
# Specifies the name of the spec file. The default value is "default_spec.rb".
# （specファイル名を指定します。デフォルト値は "default_spec.rb" です。）
#
#.INPUTS
#   string
#       This functions inputs the name of the of node from the incoming pipeline.
#       （パイプライン入力からノード名を入力します。）
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
# New-ChefNodeSpecFile
#
#.LINK
# New-ChefNode
#
#.LINK
# Show-ChefNodeList
#
#.LINK
# Open-ChefNodeVagrantfile
#
#.LINK
# Open-ChefNodeSpecFile
#
#.LINK
# Create-ChefNode
#
#.LINK
# Show-ChefNodeStatus
#
#.LINK
# Install-ChefNode
#
#.LINK
# SetUp-ChefNode
#
#.LINK
# Update-ChefNode
#
#.LINK
# Converge-ChefNode
#
#.LINK
# Test-ChefNode
#
#.LINK
# Verify-ChefNode
#
#.LINK
# Start-ChefNode
#
#.LINK
# Stop-ChefNode
#
#.LINK
# Remove-ChefNode
#
function New-ChefNodeSpecFile
{
    Param
    (
        [Parameter(Mandatory = $true, Position = 0, ValueFromPipeline = $true)]
        [string]
        [ValidateNotNull()]
        $NodeName,

        [Parameter(Mandatory = $true, Position = 1)]
        [string]
        [ValidateNotNull()]
        $IPAddress,

        [Parameter(Mandatory = $false, Position = 2)]
        [string]
        [ValidateNotNull()]
        [ValidateSet("development", "test", "production") ]
        $Environment = "development",

        [Parameter(Mandatory = $false, Position = 3)]
        [string]
        [ValidateNotNull()]
        [ValidatePattern("^.*_spec.rb$")]
        $SpecFileName = "default_spec.rb"
    )

    [string]$nodeFolderPath = "$PWD\nodes\$Environment\$NodeName"
    [string]$specFileContent = @"
require 'serverspec'
require 'winrm'

include Serverspec::Helper::WinRM
include Serverspec::Helper::Windows

RSpec.configure do |c|
  user = 'vagrant'
  pass = 'vagrant'
  endpoint = 'http://$IPAddress:5985/wsman'

  c.winrm = ::WinRM::WinRMWebService.new(endpoint, :ssl, :user => user, :pass => pass, :basic_auth_only => true)
  c.winrm.set_timeout 300 # 5 minutes max timeout for any operation
end

# # Testing for user groups.
# describe group('xxxxxx') do
#   it { should exist }
# end

# # Testing for users.
# describe user('xxxxxx') do
#   it { should exist }
#   it { should belong_to_group 'xxxxxx' }
#   it { should_not belong_to_group 'xxxxxx' }
# end

# # Testing for directories.
# describe file('C:\xxxxxx\xxxxxx') do
#   it { should be_directory }
# end

# # Testing for files.
# describe file('C:\xxxxxx\xxxxxx') do
#   it { should be_file }
#   it { should contain /^xxxxxx/ }
#   it { should be_readable.by('owner') }
#   it { should be_readable.by_user('xxxxxx') }
#   it { should_not be_readable.by('others') }
#   it { should_not be_readable.by_user('xxxxxx') }
#   it { should be_writable.by('owner') }
#   it { should be_writable.by_user('xxxxxx') }
#   it { should_not be_writable.by('others') }
#   it { should_not be_writable.by_user('xxxxxx') }
#   it { should be_executable.by('owner') }
#   it { should be_executable.by_user('xxxxxx') }
#   it { should_not be_executable.by('others') }
#   it { should_not be_executable.by_user('xxxxxx') }
# end

# # Testing for enabled services.
# describe service('xxxxxx') do
#   it { should be_enabled }
#   it { should be_running }
# end

# # Testing for disabled services.
# describe service('xxxxxx') do
#   it { should_not be_enabled }
#   it { should_not be_running }
# end

# # Testing for open ports.
# describe port(port_number) do
#   it { should be_listening.with('tcp') }
#   it { should be_listening.with('udp') }Pow
# end

# # Testing for close ports.
# describe port(port_number) do
#   it { should_not be_listening }
# end

# # Testing for command returns.
# describe command('xxxxxx') do
#   it { should return_stdout /^xxxxxx/ }
#   it { should return_exit_status 0 }
# end
"@

    if((Split-Path -Path "$PWD" -Leaf) -ne "chef-repo")
    {
        Error "Current directory is not 'chef-repo'.`n（カレントディレクトリが 'chef-repo' ではありません。）"
        return
    }

    if(!(Test-ExistsFile -Path "$nodeFolderPath\Vagrantfile"))
    {
        Error "The following 'Chef Node' is not found.`n（下記 'Chef Node' が見つかりません。）`n`nEnvironment: $Environment`nNode name: $NodeName`nVagrantfile path: $nodeFolderPath\Vagrantfile"
        return
    }

    if(Test-ExistsFile -Path "$nodeFolderPath\spec\lib\$SpecFileName")
    {
        Warning "The following spec file is already exist.`n（下記 spec ファイルは既に存在します。）`n`n$nodeFolderPath\spec\lib\$SpecFileName"
        return
    }

    New-File -Path "$nodeFolderPath\spec\lib\$SpecFileName" -Value "$specFileContent"
}

#
#.SYNOPSIS
#   This function creates a new definition of 'Chef Node'.
#   （'Chef Node' の定義を作製します。）
#
#.DESCRIPTION
#   None
#   （なし）
#
#
#.PARAMETER BoxName
# Specifies the name of the Vagrant box. This parameter is required.
# （Vagrant の Box 名を指定します。このパラメーターは必須です。）
#
#.PARAMETER OSType
# Specifies the type of OS. This parameter is required. Valid value ​​is only "Windows".
# （OS の種類を指定します。このパラメーターは必須です。有効な値は "Windows” のみです。）
#
#.PARAMETER VMNumber
# Specifies the number of VM. This parameter is required. Valid values ​​are 2-254.
# （VM番号を指定します。このパラメーターは必須です。有効な値は 2-254 です。）
#
#.PARAMETER NodeNamePrefix
# Specifies the prefix of node name. The default value is "ip".
# （ノード名の接頭文字列を指定します。デフォルト値は "ip" です。）
#
#.PARAMETER Environment
# Specifies the name of the environment. Valid values ​​are "development", "test" and "production". The default value is "development".
# （環境名を指定します。有効な値は "development"、"test"、"production" です。デフォルト値は "development" です。）
#
#.INPUTS
#   string
#       This functions inputs the name of the Vagrant box from the incoming pipeline.
#       （パイプライン入力からVagrant の Box 名を入力します。）
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
# New-ChefNodeSpecFile
#
#.LINK
# New-ChefNode
#
#.LINK
# Show-ChefNodeList
#
#.LINK
# Open-ChefNodeVagrantfile
#
#.LINK
# Open-ChefNodeSpecFile
#
#.LINK
# Create-ChefNode
#
#.LINK
# Show-ChefNodeStatus
#
#.LINK
# Install-ChefNode
#
#.LINK
# SetUp-ChefNode
#
#.LINK
# Update-ChefNode
#
#.LINK
# Converge-ChefNode
#
#.LINK
# Test-ChefNode
#
#.LINK
# Verify-ChefNode
#
#.LINK
# Start-ChefNode
#
#.LINK
# Stop-ChefNode
#
#.LINK
# Remove-ChefNode
#
function New-ChefNode
{
    Param
    (
        [Parameter(Mandatory = $true, Position = 0, ValueFromPipeline = $true)]
        [string]
        [ValidateNotNull()]
        $BoxName,

        [Parameter(Mandatory = $true, Position = 1)]
        [string]
        [ValidateNotNull()]
        [ValidateSet("Windows", "Linux") ]
        $OSType,

        [Parameter(Mandatory = $true, Position = 2)]
        [int]
        [ValidateNotNull()]
        [ValidateRange(2, 254)]
        $VMNumber,

        [Parameter(Mandatory = $false, Position = 3)]
        [string]
        [ValidateNotNull()]
        $NodeNamePrefix = "ip",

        [Parameter(Mandatory = $false, Position = 4)]
        [string]
        [ValidateNotNull()]
        [ValidateSet("development", "test", "production") ]
        $Environment = "development"
    )

    if((Split-Path -Path "$PWD" -Leaf) -ne "chef-repo")
    {
        Error "Current directory is not 'chef-repo'.`n（カレントディレクトリが 'chef-repo' ではありません。）"
        return
    }

    [string]$NodeName =  "$NodeNamePrefix-192-168-56-$VMnumber"
    [string]$nodeFolderPath = "$PWD\nodes\$Environment\$NodeName"
    [string]$vagrantfileContentForWindows = @"
# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure('2') do |config|
  config.vm.define '$NodeName' do |node|
    node.vm.box = '$BoxName'
    node.vm.guest = :windows
    node.vm.network 'private_network', ip: '192.168.56.$VMNumber'
    node.vm.provider :virtualbox do |vb|
      vb.name = '$NodeName'
      vb.gui = true
    end
  end
  config.vm.network :forwarded_port, guest: 5985, host: $($VMNumber + 50000), id: "winrm", auto_correct: true
end
"@
    [string]$vagrantfileContentforLinux = @"
# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure('2') do |config|
  config.vm.define '$NodeName' do |node|
    node.vm.box = '$BoxName'
    node.vm.network 'private_network', ip: '192.168.56.$VMNumber'
    node.vm.provider :virtualbox do |vb|
      vb.name = '$NodeName'
    end
  end
end
"@
    [string]$RakefileContent =@"
require 'rake'
require 'rspec/core/rake_task'

RSpec::Core::RakeTask.new(:spec) do |t|
  t.pattern = 'spec/*/*_spec.rb'
end
"@

    Info "Creation of the 'Chef Node' definition is starting.`n（'Chef Node'　の定義の作製を開始します。）"
    switch($OSType)
    {
        "Windows"
        {
            New-File -Path "$nodeFolderPath\Vagrantfile" -Value "$vagrantfileContentForWindows"
        }
        "Linux"
        {
            New-File -Path "$nodeFolderPath\Vagrantfile" -Value "$vagrantfileContentForLinux"
        }
    }
    New-File -Path "$nodeFolderPath\Rakefile" -Value "$RakefileContent"
    New-ChefNodeSpecFile -NodeName "$NodeName" -IPAddress "192.168.56.$VMNumber" -Environment "$Environment" -SpecFileName "default_spec.rb"
    & "tree.com " /f "$nodeFolderPath"
    Info "Creation of the 'Chef Node' definition has finished.`n（'Chef Node' の定義の作製が完了しました。）"
}

#
#.SYNOPSIS
#   This function shows the list of 'Chef Node'.
#   （'Chef Node'　の一覧を表示します。）
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
# New-ChefNodeSpecFile
#
#.LINK
# New-ChefNode
#
#.LINK
# Show-ChefNodeList
#
#.LINK
# Open-ChefNodeVagrantfile
#
#.LINK
# Open-ChefNodeSpecFile
#
#.LINK
# Create-ChefNode
#
#.LINK
# Show-ChefNodeStatus
#
#.LINK
# Install-ChefNode
#
#.LINK
# SetUp-ChefNode
#
#.LINK
# Update-ChefNode
#
#.LINK
# Converge-ChefNode
#
#.LINK
# Test-ChefNode
#
#.LINK
# Verify-ChefNode
#
#.LINK
# Start-ChefNode
#
#.LINK
# Stop-ChefNode
#
#.LINK
# Remove-ChefNode
#
function Show-ChefNodeList
{
    if((Split-Path -Path "$PWD" -Leaf) -ne "chef-repo")
    {
        Error "Current directory is not 'chef-repo'.`n（カレントディレクトリが　'chef-repo'　ではありません。）"
        return
    }

    Get-Item -Path "$PWD\nodes\*\*" -Exclude "README.md" |  Format-Table -Property Name,Parent,CreationTime,LastWriteTime,LastAccessTime -AutoSize
}

#
#.SYNOPSIS
#   This function opens Vagrantfile of the 'Chef Node'.
#   （'Chef Node'　の　Vagrantfile　を開きます。）
#
#.DESCRIPTION
#   None
#   （なし）
#
#.PARAMETER NodeName
# Specifies the name of the node.This parameter is required.
# （ノード名を指定します。このパラメーターは必須です。）
#
#.PARAMETER Environment
# Specifies the name of the environment. Valid values ​​are "development", "test" and "production". The default value is "development".
# （環境名を指定します。有効な値は　"development"、"test"、"production"　です。デフォルト値は　"development"　です。）
#
#.INPUTS
#   string
#       This functions inputs the name of the of node from the incoming pipeline.
#       （パイプライン入力からノード名を入力します。）
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
# New-ChefNodeSpecFile
#
#.LINK
# New-ChefNode
#
#.LINK
# Show-ChefNodeList
#
#.LINK
# Open-ChefNodeVagrantfile
#
#.LINK
# Open-ChefNodeSpecFile
#
#.LINK
# Create-ChefNode
#
#.LINK
# Show-ChefNodeStatus
#
#.LINK
# Install-ChefNode
#
#.LINK
# SetUp-ChefNode
#
#.LINK
# Update-ChefNode
#
#.LINK
# Converge-ChefNode
#
#.LINK
# Test-ChefNode
#
#.LINK
# Verify-ChefNode
#
#.LINK
# Start-ChefNode
#
#.LINK
# Stop-ChefNode
#
#.LINK
# Remove-ChefNode
#
function Open-ChefNodeVagrantfile
{
    Param
    (
        [Parameter(Mandatory = $true, Position = 0, ValueFromPipeline = $true)]
        [string]
        [ValidateNotNull()]
        $NodeName,

        [Parameter(Mandatory = $false, Position = 1)]
        [string]
        [ValidateNotNull()]
        [ValidateSet("development", "test", "production") ]
        $Environment = "development"
    )

    [string]$nodeFolderPath = "$PWD\nodes\$Environment\$NodeName"

    if((Split-Path -Path "$PWD" -Leaf) -ne "chef-repo")
    {
        Error "Current directory is not 'chef-repo'.`n（カレントディレクトリが　'chef-repo'　ではありません。）"
        return
    }

    if(!(Test-ExistsFile -Path "$nodeFolderPath\Vagrantfile"))
    {
        Error "The following 'Chef Node' is not found.`n（下記　'Chef Node'　が見つかりません。）`n`nEnvironment: $Environment`nNode name: $NodeName`nVagrantfile path: $nodeFolderPath\Vagrantfile"
        return
    }

    Open-File -Path "$nodeFolderPath\Vagrantfile"
}

#
#.SYNOPSIS
#   This function opens the spec file of serverspec.
#   （serverspec　の　spec　ファイルを開きます。）
#
#.DESCRIPTION
#   None
#   （なし）
#
#.PARAMETER NodeName
# Specifies the name of the node.This parameter is required.
# （ノード名を指定します。このパラメーターは必須です。）
#
#.PARAMETER IPAddress
# Specifies the ip address.
# （IPアドレスを指定します。）
#
#.PARAMETER Environment
# Specifies the name of the environment. Valid values ​​are "development", "test" and "production". The default value is "development".
# （環境名を指定します。有効な値は　"development"、"test"、"production"　です。デフォルト値は　"development"　です。）
#
#.PARAMETER SpecFileName
# Specifies the name of the spec file. The default value is "default_spec.rb".
# （specファイル名を指定します。デフォルト値は　"default_spec.rb"　です。）
#
#.INPUTS
#   string
#       This functions inputs the name of the of node from the incoming pipeline.
#       （パイプライン入力からノード名を入力します。）
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
# New-ChefNodeSpecFile
#
#.LINK
# New-ChefNode
#
#.LINK
# Show-ChefNodeList
#
#.LINK
# Open-ChefNodeVagrantfile
#
#.LINK
# Open-ChefNodeSpecFile
#
#.LINK
# Create-ChefNode
#
#.LINK
# Show-ChefNodeStatus
#
#.LINK
# Install-ChefNode
#
#.LINK
# SetUp-ChefNode
#
#.LINK
# Update-ChefNode
#
#.LINK
# Converge-ChefNode
#
#.LINK
# Test-ChefNode
#
#.LINK
# Verify-ChefNode
#
#.LINK
# Start-ChefNode
#
#.LINK
# Stop-ChefNode
#
#.LINK
# Remove-ChefNode
#
function Open-ChefNodeSpecFile
{
    Param
    (
        [Parameter(Mandatory = $true, Position = 0, ValueFromPipeline = $true)]
        [string]
        [ValidateNotNull()]
        $NodeName,

        [Parameter(Mandatory = $false, Position = 1)]
        [string]
        [ValidateNotNull()]
        [ValidateSet("development", "test", "production") ]
        $Environment = "development",

        [Parameter(Mandatory = $false, Position = 2)]
        [string]
        [ValidateNotNull()]
        [ValidatePattern("^.*_spec.rb$")]
        $SpecFileName = "default_spec.rb"
    )

    [string]$nodeFolderPath = "$PWD\nodes\$Environment\$NodeName"

    if((Split-Path -Path "$PWD" -Leaf) -ne "chef-repo")
    {
        Error "Current directory is not 'chef-repo'.`n（カレントディレクトリが　'chef-repo'　ではありません。）"
        return
    }

    if(!(Test-ExistsFile -Path "$nodeFolderPath\Vagrantfile"))
    {
        Error "The following 'Chef Node' is not found.`n（下記　'Chef Node'　が見つかりません。）`n`nEnvironment: $Environment`nNode name: $NodeName`nVagrantfile path: $nodeFolderPath\Vagrantfile"
        return
    }

    Open-File -Path "$nodeFolderPath\spec\lib\$SpecFileName"
}

#
#.SYNOPSIS
#   This function starts up the 'Chef Node'.
#   （'Chef Node'　の起動をします。）
#
#.DESCRIPTION
#   None
#   （なし）
#
#.PARAMETER NodeName
# Specifies the name of the node.This parameter is required.
# （ノード名を指定します。このパラメーターは必須です。）
#
#.PARAMETER Environment
# Specifies the name of the environment. Valid values ​​are "development", "test" and "production". The default value is "development".
# （環境名を指定します。有効な値は　"development"、"test"、"production"　です。デフォルト値は　"development"　です。）
#
#.INPUTS
#   string
#       This functions inputs the name of the of node from the incoming pipeline.
#       （パイプライン入力からノード名を入力します。）
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
# New-ChefNodeSpecFile
#
#.LINK
# New-ChefNode
#
#.LINK
# Show-ChefNodeList
#
#.LINK
# Open-ChefNodeVagrantfile
#
#.LINK
# Open-ChefNodeSpecFile
#
#.LINK
# Create-ChefNode
#
#.LINK
# Show-ChefNodeStatus
#
#.LINK
# Install-ChefNode
#
#.LINK
# SetUp-ChefNode
#
#.LINK
# Update-ChefNode
#
#.LINK
# Converge-ChefNode
#
#.LINK
# Test-ChefNode
#
#.LINK
# Verify-ChefNode
#
#.LINK
# Start-ChefNode
#
#.LINK
# Stop-ChefNode
#
#.LINK
# Remove-ChefNode
#
function Start-ChefNode
{
    Param
    (
        [Parameter(Mandatory = $true, Position = 0, ValueFromPipeline = $true)]
        [string]
        [ValidateNotNull()]
        $NodeName,

        [Parameter(Mandatory = $false, Position = 1)]
        [string]
        [ValidateNotNull()]
        [ValidateSet("development", "test", "production") ]
        $Environment = "development"
    )

    [string]$nodeFolderPath = "$PWD\nodes\$Environment\$NodeName"

    if((Split-Path -Path "$PWD" -Leaf) -ne "chef-repo")
    {
        Error "Current directory is not 'chef-repo'.`n（カレントディレクトリが　'chef-repo'　ではありません。）"
        return
    }

    if(!(Test-ExistsFile -Path "$nodeFolderPath\Vagrantfile"))
    {
        Error "The following 'Chef Node' is not found.`n（下記　'Chef Node'　が見つかりません。）`n`nEnvironment: $Environment`nNode name: $NodeName`nVagrantfile path: $nodeFolderPath\Vagrantfile"
        return
    }

    Push-Location
    Set-Location -Path "$nodeFolderPath"
    Invoke-Execute "vagrant.exe" up
    Pop-Location
}

Set-Alias -Name "Create-ChefNode" -Value "Start-ChefNode"

#
#.SYNOPSIS
#   This function shows status of the 'Chef Node'.
#   （'Chef Node'　を状態を表示します。）
#
#.DESCRIPTION
#   None
#   （なし）
#
#.PARAMETER NodeName
# Specifies the name of the node.This parameter is required.
# （ノード名を指定します。このパラメーターは必須です。）
#
#.PARAMETER Environment
# Specifies the name of the environment. Valid values ​​are "development", "test" and "production". The default value is "development".
# （環境名を指定します。有効な値は　"development"、"test"、"production"　です。デフォルト値は　"development"　です。）
#
#.INPUTS
#   string
#       This functions inputs the name of the of node from the incoming pipeline.
#       （パイプライン入力からノード名を入力します。）
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
# New-ChefNodeSpecFile
#
#.LINK
# New-ChefNode
#
#.LINK
# Show-ChefNodeList
#
#.LINK
# Open-ChefNodeVagrantfile
#
#.LINK
# Open-ChefNodeSpecFile
#
#.LINK
# Create-ChefNode
#
#.LINK
# Show-ChefNodeStatus
#
#.LINK
# Install-ChefNode
#
#.LINK
# SetUp-ChefNode
#
#.LINK
# Update-ChefNode
#
#.LINK
# Converge-ChefNode
#
#.LINK
# Test-ChefNode
#
#.LINK
# Verify-ChefNode
#
#.LINK
# Start-ChefNode
#
#.LINK
# Stop-ChefNode
#
#.LINK
# Remove-ChefNode
#
function Show-ChefNodeStatus
{
    Param
    (
        [Parameter(Mandatory = $true, Position = 0, ValueFromPipeline = $true)]
        [string]
        [ValidateNotNull()]
        $NodeName,

        [Parameter(Mandatory = $false, Position = 1)]
        [string]
        [ValidateNotNull()]
        [ValidateSet("development", "test", "production") ]
        $Environment = "development"
    )

    [string]$nodeFolderPath = "$PWD\nodes\$Environment\$NodeName"

    if((Split-Path -Path "$PWD" -Leaf) -ne "chef-repo")
    {
        Error "Current directory is not 'chef-repo'.`n（カレントディレクトリが　'chef-repo'　ではありません。）"
        return
    }

    if(!(Test-ExistsFile -Path "$nodeFolderPath\Vagrantfile"))
    {
        Error "The following 'Chef Node' is not found.`n（下記　'Chef Node'　が見つかりません。）`n`nEnvironment: $Environment`nNode name: $NodeName`nVagrantfile path: $nodeFolderPath\Vagrantfile"
        return
    }

    Push-Location
    Set-Location -Path "$nodeFolderPath"
    & "vagrant.exe" status
    Pop-Location
}

#
#.SYNOPSIS
#   This function sets up as 'Chef Node' to the specified node.
#   （指定したノードを　'Chef Node'　としてセットアップします。）
#
#.DESCRIPTION
#   None
#   （なし）
#
#.PARAMETER NodeName
# Specifies the name of the node. This parameter is required.
# （ノード名を指定します。このパラメーターは必須です。）
#
#.PARAMETER Environment
# Specifies the name of the environment. Valid values ​​are "development", "test" and "production". The default value is "development".
# （環境名を指定します。有効な値は　"development"、"test"、"production"　です。デフォルト値は　"development"　です。）
#
#.INPUTS
#   string
#       This functions inputs the name of the of node from the incoming pipeline.
#       （パイプライン入力からノード名を入力します。）
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
# New-ChefNodeSpecFile
#
#.LINK
# New-ChefNode
#
#.LINK
# Show-ChefNodeList
#
#.LINK
# Open-ChefNodeVagrantfile
#
#.LINK
# Open-ChefNodeSpecFile
#
#.LINK
# Create-ChefNode
#
#.LINK
# Show-ChefNodeStatus
#
#.LINK
# Install-ChefNode
#
#.LINK
# SetUp-ChefNode
#
#.LINK
# Update-ChefNode
#
#.LINK
# Converge-ChefNode
#
#.LINK
# Test-ChefNode
#
#.LINK
# Verify-ChefNode
#
#.LINK
# Start-ChefNode
#
#.LINK
# Stop-ChefNode
#
#.LINK
# Remove-ChefNode
#
function Install-ChefNode
{
    Param
    (
        [Parameter(Mandatory = $true, Position = 0, ValueFromPipeline = $true)]
        [string]
        [ValidateNotNull()]
        $NodeName,

        [Parameter(Mandatory = $false, Position = 1)]
        [string]
        [ValidateNotNull()]
        [ValidateSet("development", "test", "production") ]
        $Environment = "development"
    )

    [string]$nodeFolderPath = "$PWD\nodes\$Environment\$NodeName"

    if((Split-Path -Path "$PWD" -Leaf) -ne "chef-repo")
    {
        Error "Current directory is not 'chef-repo'.`n（カレントディレクトリが　'chef-repo'　ではありません。）"
        return
    }

    if(!(Test-ExistsFile -Path "$nodeFolderPath\Vagrantfile"))
    {
        Error "The following 'Chef Node' is not found.`n（下記　'Chef Node'　が見つかりません。）`n`nEnvironment: $Environment`nNode name: $NodeName`nVagrantfile path: $nodeFolderPath\Vagrantfile"
        return
    }

    [string]$IPAddress = Get-Content -Path "$nodeFolderPath\Vagrantfile" | Select-String -Pattern "private_network"
    $IPAddress = $IPAddress.substring(43).trim("`'")
    [string]$pemContent = Get-Content -Path "$env:SystemDrive\chef\validation.pem" -Raw
    [string]$clientRbContent = @"
chef_server_url 'http://192.168.56.1:8889'
node_name '$NodeName'

environment '$Environment'
"@

    Info "Connection to the following machine is starting.`n（下記マシンとの接続を開始します。）`n`nNode name: $NodeName`nIP address: $IPAddress"
    try
    {
        $PSSession = New-PSSession -ComputerName "$IPAddress" -Credential "vagrant"
    }
    catch
    {
        Error "Connection to the following machine is failed.`n（下記マシンとの接続に失敗しました。）`n`nNode name: $NodeName`nIP address: $IPAddress`n`n$Error"
    }
    Info "Connection to the following machine has finished successfully.`n（下記マシンとの接続が正常に完了しました。）`n`nNode name: $NodeName`nIP address: $IPAddress"

    Info "Downloading a installer of 'Chef' on the following machine.`n（下記マシン上で　'Chef'　のインストーラーをダウンロードしています。）`n`nNode name: $NodeName`nIP address: $IPAddress"
    Invoke-Command -Session $PSSession -ScriptBlock {(New-Object System.Net.WebClient).DownloadFile("https://www.opscode.com/chef/install.msi", "$env:TEMP\Chef.msi")}

    Info "Installing 'Chef' on the following machine.`n（下記マシン上で　'Chef'　をインストールしています。）`n`nNode name: $NodeName`nIP address: $IPAddress"
    Invoke-Command -Session $PSSession -ScriptBlock {Start-Process -FilePath "msiexec.exe" -ArgumentList "/package $env:TEMP\Chef.msi /passive" -Verb "runas" -Wait}
    Invoke-Command -Session $PSSession -ScriptBlock {$env:Path = "C:\opscode\chef\bin;$env:Path"}

    Info "Creating 'C:\chef\client.rb' on the following machine.`n（下記マシン上で　'C:\chef\client.rb' を作成しています。）`n`nNode name: $NodeName`nIP address: $IPAddress"
    Invoke-Command -Session $PSSession -ScriptBlock {& knife.bat configure client -s "http://192.168.56.1:8889" "C:\chef\"}
    Invoke-Command -Session $PSSession -ScriptBlock {Add-Content -Path "C:\chef\client.rb" -Value "node_name '$args'"} -ArgumentList "$NodeName"
    Invoke-Command -Session $PSSession -ScriptBlock {Add-Content -Path "C:\chef\client.rb" -Value "environment '$args'"} -ArgumentList "$Environment"

    Info "Creating 'C:\chef\validation.pem' on the following machine.`n（下記マシン上で　'C:\chef\validation.pem' を作成しています。）`n`nNode name: $NodeName`nIP address: $IPAddress"
    Invoke-Command -Session $PSSession -ScriptBlock {Remove-Item -Path "C:\chef\validation.pem" -Force}
    Invoke-Command -Session $PSSession -ScriptBlock {New-Item -Path "C:\chef\validation.pem" -ItemType "File" -Value "$args"} -ArgumentList "$pemContent"

    Info "Registering as 'Chef Node' on the following machine.`n（下記マシン上で　'Chef Node'　の登録を行っています。）`n`nNode name: $NodeName`nIP address: $IPAddress"
    Invoke-Command -Session $PSSession -ScriptBlock {& chef-client.bat -c "C:\chef\client.rb"}

    Info "Disconnection to the following machine is starting.`n（下記マシンとの切断を開始します。）`n`nNode name: $NodeName`nIP address: $IPAddress"
    try
    {
        Remove-PSSession -Session $PSSession
    }
    catch
    {
        Error "Disconnection to the following machine is failed.`n（下記マシンとの切断に失敗しました。）`n`nNode name: $NodeName`nIP address: $IPAddress`n`n$Error"
    }
    Info "Disconnection to the following machine has finished successfully.`n（下記マシンとの切断が正常に完了しました。）`n`nNode name: $NodeName`nIP address: $IPAddress"
}

Set-Alias -Name "SetUp-ChefNode" -Value "Install-ChefNode"

#
#.SYNOPSIS
#   This function runs Chef Client.
#   （Chef Client　を実行します。）
#
#.DESCRIPTION
#   None
#   （なし）
#
#.PARAMETER NodeName
# Specifies the name of the node. This parameter is required.
# （ノード名を指定します。このパラメーターは必須です。）
#
#.PARAMETER Environment
# Specifies the name of the environment. Valid values ​​are "development", "test" and "production". The default value is "development".
# （環境名を指定します。有効な値は　"development"、"test"、"production"　です。デフォルト値は　"development"　です。）
#
#.INPUTS
#   string
#       This functions inputs the name of the of node from the incoming pipeline.
#       （パイプライン入力からノード名を入力します。）
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
# New-ChefNodeSpecFile
#
#.LINK
# New-ChefNode
#
#.LINK
# Show-ChefNodeList
#
#.LINK
# Open-ChefNodeVagrantfile
#
#.LINK
# Open-ChefNodeSpecFile
#
#.LINK
# Create-ChefNode
#
#.LINK
# Show-ChefNodeStatus
#
#.LINK
# Install-ChefNode
#
#.LINK
# SetUp-ChefNode
#
#.LINK
# Update-ChefNode
#
#.LINK
# Converge-ChefNode
#
#.LINK
# Test-ChefNode
#
#.LINK
# Verify-ChefNode
#
#.LINK
# Start-ChefNode
#
#.LINK
# Stop-ChefNode
#
#.LINK
# Remove-ChefNode
#
function Update-ChefNode
{
    Param
    (
        [Parameter(Mandatory = $true, Position = 0, ValueFromPipeline = $true)]
        [string]
        [ValidateNotNull()]
        $NodeName,

        [Parameter(Mandatory = $false, Position = 1)]
        [string]
        [ValidateNotNull()]
        [ValidateSet("development", "test", "production") ]
        $Environment = "development"
    )

    [string]$nodeFolderPath = "$PWD\nodes\$Environment\$NodeName"

    if((Split-Path -Path "$PWD" -Leaf) -ne "chef-repo")
    {
        Error "Current directory is not 'chef-repo'.`n（カレントディレクトリが　'chef-repo'　ではありません。）"
        return
    }

    if(!(Test-ExistsFile -Path "$nodeFolderPath\Vagrantfile"))
    {
        Error "The following 'Chef Node' is not found.`n（下記　'Chef Node'　が見つかりません。）`n`nEnvironment: $Environment`nNode name: $NodeName`nVagrantfile path: $nodeFolderPath\Vagrantfile"
        return
    }

    [string]$IPAddress = Get-Content -Path "$nodeFolderPath\Vagrantfile" | Select-String -Pattern "private_network"
    $IPAddress = $IPAddress.substring(43).trim("`'")
    $PSSession = New-PSSession -ComputerName "$IPAddress" -Credential "vagrant"

    Invoke-Command -Session $PSSession -ScriptBlock {C:\opscode\chef\bin\chef-client.bat -c "C:\chef\client.rb"}
    Remove-PSSession -Session $PSSession
}

Set-Alias -Name "Converge-ChefNode" -Value "Update-ChefNode"

#
#.SYNOPSIS
#   This function uses 'serverspec' and verifies the specified 'Chef Node'.
#   （'serverspec'を使って　'Chef Node'　を検証します。）
#
#.DESCRIPTION
#   None
#   （なし）
#
#.PARAMETER NodeName
# Specifies the name of the node.This parameter is required.
# （ノード名を指定します。このパラメーターは必須です。）
#
#.PARAMETER Environment
# Specifies the name of the environment. Valid values ​​are "development", "test" and "production". The default value is "development".
# （環境名を指定します。有効な値は "development"、"test"、"production" です。デフォルト値は "development" です。）
#
#.INPUTS
#   string
#       This functions inputs the name of the of node from the incoming pipeline.
#       （パイプライン入力からノード名を入力します。）
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
# New-ChefNodeSpecFile
#
#.LINK
# New-ChefNode
#
#.LINK
# Show-ChefNodeList
#
#.LINK
# Open-ChefNodeVagrantfile
#
#.LINK
# Open-ChefNodeSpecFile
#
#.LINK
# Create-ChefNode
#
#.LINK
# Show-ChefNodeStatus
#
#.LINK
# Install-ChefNode
#
#.LINK
# SetUp-ChefNode
#
#.LINK
# Update-ChefNode
#
#.LINK
# Converge-ChefNode
#
#.LINK
# Test-ChefNode
#
#.LINK
# Verify-ChefNode
#
#.LINK
# Start-ChefNode
#
#.LINK
# Stop-ChefNode
#
#.LINK
# Remove-ChefNode
#
function Test-ChefNode
{
    Param
    (
        [Parameter(Mandatory = $true, Position = 0, ValueFromPipeline = $true)]
        [string]
        [ValidateNotNull()]
        $NodeName,

        [Parameter(Mandatory = $false, Position = 1)]
        [string]
        [ValidateNotNull()]
        [ValidateSet("development", "test", "production") ]
        $Environment = "development"
    )

    [string]$nodeFolderPath = "$PWD\nodes\$Environment\$NodeName"

    if((Split-Path -Path "$PWD" -Leaf) -ne "chef-repo")
    {
        Error "Current directory is not 'chef-repo'.`n（カレントディレクトリが 'chef-repo' ではありません。）"
        return
    }

    if(!(Test-ExistsFile -Path "$nodeFolderPath\Vagrantfile"))
    {
        Error "The following 'Chef Node' is not found.`n（下記 'Chef Node' が見つかりません。）`n`nEnvironment: $Environment`nNode name: $NodeName`nVagrantfile path: $nodeFolderPath\Vagrantfile"
        return
    }

    Push-Location
    Set-Location -Path "$nodeFolderPath"
    Invoke-Execute "rake.bat" spec
    Pop-Location
}

Set-Alias -Name "Verify-ChefNode" -Value "Test-ChefNode"

#
#.SYNOPSIS
#   This function shuts down the Chef node.
#   （Chef の Node を停止します。）
#
#.DESCRIPTION
#   None
#   （なし）
#
#.PARAMETER NodeName
# Specifies the name of the node.This parameter is required.
# （ノード名を指定します。このパラメーターは必須です。）
#
#.PARAMETER Environment
# Specifies the name of the environment. Valid values ​​are "development", "test" and "production". The default value is "development".
# （環境名を指定します。有効な値は "development"、"test"、"production" です。デフォルト値は "development" です。）
#
#.INPUTS
#   string
#       This functions inputs the name of the of node from the incoming pipeline.
#       （パイプライン入力からノード名を入力します。）
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
# New-ChefNodeSpecFile
#
#.LINK
# New-ChefNode
#
#.LINK
# Show-ChefNodeList
#
#.LINK
# Open-ChefNodeVagrantfile
#
#.LINK
# Open-ChefNodeSpecFile
#
#.LINK
# Create-ChefNode
#
#.LINK
# Show-ChefNodeStatus
#
#.LINK
# Install-ChefNode
#
#.LINK
# SetUp-ChefNode
#
#.LINK
# Update-ChefNode
#
#.LINK
# Converge-ChefNode
#
#.LINK
# Test-ChefNode
#
#.LINK
# Verify-ChefNode
#
#.LINK
# Start-ChefNode
#
#.LINK
# Stop-ChefNode
#
#.LINK
# Remove-ChefNode
#
function Stop-ChefNode
{
    Param
    (
        [Parameter(Mandatory = $true, Position = 0, ValueFromPipeline = $true)]
        [string]
        [ValidateNotNull()]
        $NodeName,

        [Parameter(Mandatory = $false, Position = 1)]
        [string]
        [ValidateNotNull()]
        [ValidateSet("development", "test", "production") ]
        $Environment = "development"
    )

    [string]$nodeFolderPath = "$PWD\nodes\$Environment\$NodeName"

    if((Split-Path -Path "$PWD" -Leaf) -ne "chef-repo")
    {
        Error "Current directory is not 'chef-repo'.`n（カレントディレクトリが'chef-repo'ではありません。）"
        return
    }

    if(!(Test-ExistsFile -Path "$nodeFolderPath\Vagrantfile"))
    {
        Error "The following 'Chef Node' is not found.`n（下記'Chef Node'が見つかりません。）`n`nEnvironment: $Environment`nNode name: $NodeName`nVagrantfile path: $nodeFolderPath\Vagrantfile"
        return
    }

    Push-Location
    Set-Location -Path "$nodeFolderPath"
    Invoke-Execute "vagrant.exe" halt
    Pop-Location
}

#
#.SYNOPSIS
#   This function delates the Chef node.
#   （Chef の Node を削除します。）
#
#.DESCRIPTION
#   None
#   （なし）
#
#.PARAMETER NodeName
# Specifies the name of the node.This parameter is required.
# （ノード名を指定します。このパラメーターは必須です。））
#
#.PARAMETER Environment
# Specifies the name of the environment. Valid values ​​are "development", "test" and "production". The default value is "development".
# （環境名を指定します。有効な値は "development"、"test"、"production" です。デフォルト値は "development" です。）
#
#.INPUTS
#   string
#       This functions inputs the name of the of node from the incoming pipeline.
#       （パイプライン入力からノード名を入力します。）
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
# New-ChefNodeSpecFile
#
#.LINK
# New-ChefNode
#
#.LINK
# Show-ChefNodeList
#
#.LINK
# Open-ChefNodeVagrantfile
#
#.LINK
# Open-ChefNodeSpecFile
#
#.LINK
# Create-ChefNode
#
#.LINK
# Show-ChefNodeStatus
#
#.LINK
# Install-ChefNode
#
#.LINK
# SetUp-ChefNode
#
#.LINK
# Update-ChefNode
#
#.LINK
# Converge-ChefNode
#
#.LINK
# Test-ChefNode
#
#.LINK
# Verify-ChefNode
#
#.LINK
# Start-ChefNode
#
#.LINK
# Stop-ChefNode
#
#.LINK
# Remove-ChefNode
#
function Remove-ChefNode
{
    Param
    (
        [Parameter(Mandatory = $true, Position = 0, ValueFromPipeline = $true)]
        [string]
        [ValidateNotNull()]
        $NodeName,

        [Parameter(Mandatory = $false, Position = 1)]
        [string]
        [ValidateNotNull()]
        [ValidateSet("development", "test", "production") ]
        $Environment = "development"
    )

    [string]$nodeFolderPath = "$PWD\nodes\$Environment\$NodeName"

    if((Split-Path -Path "$PWD" -Leaf) -ne "chef-repo")
    {
        Error "Current directory is not 'chef-repo'.`n（カレントディレクトリが 'chef-repo' ではありません。）"
        return
    }

    if(!(Test-ExistsFile -Path "$nodeFolderPath\Vagrantfile"))
    {
        Error "The following 'Chef Node' is not found.`n（下記 'Chef Node' が見つかりません。）`n`nEnvironment: $Environment`nNode name: $NodeName`nVagrantfile path: $nodeFolderPath\Vagrantfile"
        return
    }

    Set-Location -Path "$nodeFolderPath"
    Invoke-Execute "vagrant.exe" destroy "--force"
    Set-Location -Path ".."
    Remove-Folder -Path "$nodeFolderPath"
    Pop-Location
}

# SIG # Begin signature block
# MIIFcAYJKoZIhvcNAQcCoIIFYTCCBV0CAQExCzAJBgUrDgMCGgUAMGkGCisGAQQB
# gjcCAQSgWzBZMDQGCisGAQQBgjcCAR4wJgIDAQAABBAfzDtgWUsITrck0sYpfvNR
# AgEAAgEAAgEAAgEAAgEAMCEwCQYFKw4DAhoFAAQUHzMCocmWJuoZeXmmiT34iLBG
# FL6gggMaMIIDFjCCAgKgAwIBAgIQliVLy3mu8q1LSkdDsNdvkzAJBgUrDgMCHQUA
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
# BgorBgEEAYI3AgELMQ4wDAYKKwYBBAGCNwIBFTAjBgkqhkiG9w0BCQQxFgQUIcm7
# 6uhDBJh1KvVIdjr/3pP+a4owDQYJKoZIhvcNAQEBBQAEggEAi2n/pBC44Xj6CfaS
# IppM3DIKv5MNqJh2WJLMe0fOJ12+F2faDPyt64cBRdf3jbBqSRidMQ8s0IunBajU
# g98y8KJ1fdHSegIDNlPzI+LY2gkrQ0+hDbHYIGWxc2orN/JMcChIAzJH0LQYmOmz
# j2IhfQv/7op1OrnZwIUr1zj5UbQEu/sIQuuGw8bBuHI9LZtduPAlJGCrLPQ2X6E4
# sz42M2YAerWiULEaI/HjOvW/f0+cl6VgApVbpmOWM/bv+82r191wgFxTfii3ruEV
# O+JM5szvqIPRk1K+zdcAnmNo0qNCXMIaZ6qbv5S4mfEBN0Kr1hFn1tdM+dB0U83K
# CMszVg==
# SIG # End signature block
