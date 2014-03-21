# PowerChef 利用ガイド

PowerChef の基本的なファンクションとその使い方について、チュートリアル形式で説明します。

[1: PowerChef モジュールのインストール](#section1)

[2: WorkStation 環境のセットアップ](#section2)

[3: Box の作成](#section3)

[4: クックブックの作成](#section4)

[5: クックブックのアップロード](#section5)

[6: Node 環境のセットアップ](#section6)

[7: クックブックの適用](#section7)

[8: その他](#section8)

## <a name="section1">1: PowerChef モジュールのインストール

PowerChef モジュールをローカルマシンにダウンロードします。

### 手順 1-1: スタートメニューから 'Windows PowerShell' を起動します

### 手順 1-2: PowerShellスクリプトの実行セキュリティ・ポリシーを RemoteSigned に変更します

    PS> Set-ExecutionPolicy RemoteSigned
    PS> Get-ExecutionPolicy
    RemoteSigned

→ RemoteSigned と表示されることを確かめます。

### 手順 1-3: インストールスクリプト（`install.ps1`）を使って、GitHub上からモジュールをダウンロードします

    PS> Invoke-Expression (New-Object System.Net.WebClient).DownloadString("https://raw.github.com/kukita/PowerChef/master/install.ps1")

→ Installation of 'PowerChef' has finished successfully. と表示されれば成功です。

## <a name="section2">2: WorkStation 環境のセットアップ

ローカルマシンを Chef の WorkStation 環境としてセットアップします。

### 手順 2-1: PowerChef モジュールをインポートします

    PS> Import-Module "PowerChef"
    PS> Get-Module
    ModuleType Version    Name
    ---------- -------    ----
    Manifest   3.1.0.0    Microsoft.PowerShell.Management
    Manifest   3.1.0.0    Microsoft.PowerShell.Utility
    Manifest   0.1.0      PowerChef

→ PowerChef が表示されていることを確かめます。

### 手順 2-2: `SetUp-ChefWorkstation` ファンクションを使って、ローカルマシンを WorkStation 環境としてセットアップします

    PS> SetUp-ChefWorkstation -PowerChefHomePath "D:\PowerChef"
	※30分くらいかかります。最後にWinRMのセキュリティ設定に関して聞かれるので [Y]Yes を選択します。

次のソフトウェアがインストールされます。

* Chocolatey [[https://chocolatey.org/]](https://chocolatey.org/)
* Oracle VM VitrualBox [[https://www.virtualbox.org/]](https://www.virtualbox.org/)
* Git for Windows [[http://msysgit.github.io/]](http://msysgit.github.io/)
* posh-git [[https://github.com/dahlbyk/posh-git]](https://github.com/dahlbyk/posh-git)
* Chef [[http://www.getchef.com/chef/]](http://www.getchef.com/chef/)
* serverspec [[http://serverspec.org/]](http://serverspec.org/)
* Bento [[https://github.com/opscode/bento]](https://github.com/opscode/bento)
* em-winrm [[https://github.com/opscode/em-winrm]](https://github.com/opscode/em-winrm)
* Oracle Java Runtime [[http://java.com/en/download/]](http://java.com/en/download/)
* Vagrant [[http://www.vagrantup.com/]](http://www.vagrantup.com/)
* vagrant-windows [[https://github.com/WinRb/vagrant-windows]](https://github.com/WinRb/vagrant-windows)
* 7-Zip [[http://www.7-zip.org/]](http://www.7-zip.org/)
* CwRsync [[https://www.itefix.no/i2/cwrsync]](https://www.itefix.no/i2/cwrsync)
* Berkshelf [[http://berkshelf.com/]] (http://berkshelf.com/)

### 手順 2-3: `Open-HomeVagrantfile` ファンクションを使って、Vagrant ホームディレクトリの `Vagrantfile` を編集します

    PS> Open-HomeVagrantfile

→ 仮想化支援機能の有無等ホストマシンのスペックに合わせてファイルを編集しファイルを閉じます。

### 手順 2-4: `Update-ChefWorkstation` ファンクションを使って、インストールしたソフトウェアのアップデートを行うこともできます

    PS> Update-ChefWorkstation

## <a name="section3">3: Box の作成

Vagrant の Box を作成します。

### 手順 3-1: スタートメニューから 'Oracle VM VirtualBox' を起動します

### 手順 3-2: `Show-VeeweeDefinitionVboxList` ファンクションを使って、Bento(Veewee) で定義済みの OS の一覧を表示します

    PS> Show-VeeweeDefinitionVboxList
    windows-2008r2-standard
    windows-2012-standard
    windows-2012r2-standard
    windows-7-enterprise
    windows-8-enterprise

### 手順 3-3: `Invoke-VeeweeVboxBuild` ファンクションを使って、Bento(Veewee) を使って仮想マシン（VirtualBox のゲストOS）を作製します

    PS> Invoke-VeeweeVboxBuild "windows-2012r2-standard"

→ コンソール画面が立ち上がり Windows のインストールがはじまれば成功です。
※ISOイメージのダウンロードで失敗する場合は、手動でダウンロードを行った後、仮想マシンを削除してから再度コマンドを実行してください。

### 手順 3-4: `New-VagrantBox` ファンクションを使って、作成した VirtualBox のゲストOS をベースに Vagrant の Box を作製します

    PS> New-VagrantBox "windows-2012r2-standard"
    PS> & vagrant.exe box list
    windows-2012r2-standard (virtualbox)

→ windows-2012r2-standard が表示されれば成功です。このファンクションは任意のゲストOSをBox化することができます。必要がなければ、ベースとして作成した仮想マシンは削除してください。

## <a name="section4">4: クックブックの作成

コミュニティに公開されているクックブック `iis` と `chef-client` をラップしただけの簡単なクックブック `role-as-webserver` を作成します。

### 手順 4-1: `New-ChefRepo` ファンクションを使って、"SampleRepo" という名前のリポジトリを作成します

    PS> New-ChefRepo "SampleRepo"
    PS> Show-ChefRepoList
    Name        CreationTime        LastWriteTime       LastAccessTime
    ----        ------------        --------------      -------------
    SampleRepo  2014/XX/XX XX:XX:XX 2014/XX/XX XX:XX:XX 2014/XX/XX XX:XX:XX

→ SampleRepo が表示されることを確かめます。

### 手順 4-2: `Get-ChefRepoPath` ファンクションを使って、作成した chef-repo のパスを取得しカレントディレクトリを移動します

    PS> Get-ChefRepoPath "SampleRepo" | Set-Location
    PS> pwd
    Path
    ----
    D:\PowerChef\chef-repositories\SampleRepo\chef-repo

→ D:\PowerChef\chef-repositories\SampleRepo\chef-repo と表示されることを確かめます。

### 手順 4-3: `New-Cookbook` ファンクションを使って、"role-as-webserver" という名前のクックブックを作成します

    PS> New-Cookbook "role-as-webserver"
    Maintainer: xxxxxxx xxxxxx ←作成者（メンテナー）の名前を入力します。
    MainteinerEmail: xxxxxxxx@xxxxxx.xx ←作成者（メンテナー）のメールアドレスを入力します。
    PS> Show-CookbookList
    Name              Parent         CreationTime        LastWriteTime       LastAccessTime
    ----              ------         ------------        --------------      -------------
    role-as-webserver site-cookbooks 2014/xx/xx xx:xx:xx 2014/xx/xx xx:xx:xx 2014/xx/xx xx:xx:xx

→ role-as-webserver が表示されることを確かめます。

### 手順 4-4: `Open-CookbookMetadata` ファンクションを使って、クックブックのメタデータ（`metadata.rb`）を編集します

    PS> Open-CookbookMetadata "role-as-webserver"

次のように編集しファイルを閉じます。

    name             'role-as-webserver'
    maintainer       'xxxxxxx xxxxxx'
    maintainer_email 'xxxxxxxx@xxxxxx.xx'
    license          'Apache 2.0'
    description      'This is a cookbook　of the role as web server.' ←編集
    long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
    version          '0.1.0'
    depends          'iis'         ←追記
    depends          'chef-client' ←追記

### 手順 4-5: `Open-CookbookReadme` ファンクションを使って、クックブックのREADME(`README.md`）を編集します

    PS> Open-CookbookReadme "role-as-webserver"

→ ここでは、`README.md` が作成されていることを確認し、そのままファイルを閉じます。

### 手順 4-6: `Open-CookbookRecipe` ファンクションを使って、クックブックのデフォルトレシピ(`default.rb`）を編集します

    PS> Open-CookbookRecipe "role-as-webserver"

行末に次の2行を追記しファイルを閉じます。

    include_recipe "iis::default"         ←追記
    include_recipe "chef-client::default" ←追記

※`-RecipeName` パラメーターを使って任意の名前のレシピを編集することができます。レシピを新規に作成する場合は、`New-CookbookRecipe` ファンクションを使います。

## <a name="section5">5: クックブックのアップロード

Chef Zero（インメモリー版軽量 Chef Server）を起動し、作成したクックブックをアップロードします。

### 手順 5-1: `Start-ChefZero` ファンクションを使って、ローカルマシン上にChef Zero（インメモリー版軽量 Chef Server）を起動します。

    PS> Start-ChefZero
    PS> & NETSTAT.EXE -anb | Select-String "8889"
    
→ ポート 8889 番の状態が LISTENING であることを確かめます。

### 手順 5-2: `New-ChefZeroACL` ファンクションを使って、Windows ファイアウォールの設定を行います（Windows 8、Windows 2012 以降の環境のみ）

    PS> New-ChefZeroACL

### 手順 5-3: `Update-Cookbook` ファンクションを使って、依存関係のあるクックブックをダウンロードし Chef Zero にアップロードします

    PS> Update-Cookbook "role-as-webserver"
    PS> & knife.bat cookbook list
    
→ クックブックの一覧が表示されれば成功です。

## <a name="section6">6: Node 環境のセットアップ

Chef の Node 環境を作成します。

### 手順 6-1: `New-ChefNode` ファンクションを使って、Node環境の定義ファイルを作成します

    PS> New-ChefNode -BoxName "windows-2012r2-standard" -OSType "Windows" -VMNumber 10 -NodeNamePrefix "WebServer"
    PS> Show-ChefNodeList
    ※VMNumber は 2～254までの数字のいずれかを入力します。
	
→ "WebServer-192-168-56-10" という名前の Node が作成されたことを確かめます。

### 手順 6-2: `Open-ChefNodeVagrantfile` ファンクションを使って、`Vagrantfile` を編集します

    PS> Open-ChefNodeVagrantfile "WebServer-192-168-56-10"
    
→ ここでは、`Vagrantfile` が作成されていることを確認し、そのままファイルを閉じます。

### 手順 6-3: `Open-ChefNodeSpecfile` ファンクションを使って、serverspec の spec ファイル（`default_spec.rb`）を編集します

    PS> Open-ChefNodeSpecfile "WebServer-192-168-56-10"
    
→ ここでは、`default_spec.rb` が作成されていることを確認し、そのままファイルを閉じます。

### 手順 6-4: `Create-ChefNode` ファンクションを使って、仮想マシン（VirtualBox のゲスト OS）を作成します

    PS> Create-ChefNode "WebServer-192-168-56-10"
    PS> Show-ChefNodeStatus "WebServer-192-168-56-10"

### 手順 6-5: `SetUp-ChefNode` ファンクションを使って、作成した仮想マシンを Node 環境としてセットアップします

    PS> SetUp-ChefNode "WebServer-192-168-56-10"

→ パスワード欄に vagrant と入力し [OK] ボタンをクリックします。

### 手順 6-6: knife コマンドを使って、Chef Zero サーバー上に Node として登録されたことを確認します

    PS> & knife.bat node list
    WebServer-192-168-56-10

→ WebServer-192-168-56-10 が表示されれば成功です。

## <a name="section7">7: クックブックの適用

作成したクックブックを Node 環境に適用します。

### 手順 7-1: knife コマンドを使って run_list に作成したクックブックを追加します

    PS> & knife.bat node run_list add "WebServer-192-168-56-10" "role-as-webserver::default"
    PS> & knife.bat node show "WebServer-192-168-56-10"

### 手順 7-2: knife コマンドを使って、"development" という名前の Environment を作成し環境変数（attributes）を設定します

    PS> & knife.bat environment create "development" -e "notepad.exe"

次のように編集してファイルを閉じます。

    {
      "name": "development",
      "description": "",
      "cookbook_versions": {
      },
      "json_class": "Chef::Environment",
      "chef_type": "environment",
      "default_attributes": {
        "iis": {              ← 追記
	      "accept_eula": true ← 追記
	    }                     ← 追記
      },
      "override_attributes": {
      }
    }

### 手順 7-3: `Converge-ChefNode` ファンクションを使って、クックブックを Node に適用します（Node 上で chef-client を実行します）

    PS> Converge-ChefNode "WebServer-192-168-56-10"

→ パスワード欄に vagrant と入力し [OK] ボタンをクリックします。Node 上で chef-client が実行されエラーが出力されなければ成功です。

## <a name="section8">8: その他

### 手順 8-1: `Test-ChefNode` ファンクションを使って、作成した Node を serverspec でテストすることができます

    PS> Test-ChefNode "WebServer-192-168-56-10"

### 手順 8-2: `Stop-ChefNode` ファンクションを使って、作成した Node を停止することができます

    PS> Stop-ChefNode "WebServer-192-168-56-10"
    PS> Show-ChefNodeStatus "WebServer-192-168-56-10"

### 手順 8-3: `Start-ChefNode` ファンクションを使って、停止した Node を起動することができます

    PS> Start-ChefNode "WebServer-192-168-56-10"
    PS> Show-ChefNodeStatus "WebServer-192-168-56-10"

---

その他の全てのファンクションの一覧は `Get-Command -Module "PowerChef"` で確認できます。

また、ファンクション個別の詳細については、`Get-Help`コマンドレットで確認してください。