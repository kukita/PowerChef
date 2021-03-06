## 0.5.2 (September 18, 2014)

BUG FIXES:

  - Removed the extension ".bat".（拡張子 ".bat" を除去。）

## 0.5.1 (July 10, 2014)

BUG FIXES:

  - Change the PATH due to specification changes 'Chocolatey'.（'Chocolatey' の仕様変更に伴い PATH を変更。）

## 0.5.0 (June 23, 2014)

FEATURES:

  - Support for "Vagrant 1.6".（"Vagrant 1.6" をサポート。）

IMPROVEMENTS:

  - `SetUp-ChefNode` function installs 'Chef' using 'Chocolatery'.（`SetUp-ChefNode` ファンクションにおいて 'Chocolatey' を使って 'Chef' をインストールするように変更。）

  - `Show-ChefNodeStatus` function supports running with no parameters.（`Show-ChefNodeStatus` ファンクションにおいてパラメータなしでの実行をサポート。）

BUG FIXES:

  - Fix fail to install Berkshelf 2.0.16.（Berkshelf 2.0.16 のインストールに失敗する問題を修正。）

## 0.4.2 (May 18, 2014)

BUG FIXES:

  - Fix fail to install when the drive of 'My Documents' is not the system drive'.（'My Documents' がシステムドライブでない場合にインストールに失敗する問題を修正。）

## 0.4.1 (May 18, 2014)

BUG FIXES:

  - Fix to ver.2.0.16 the version of Berkshelf.（Berkshelf のバージョンを ver.2.0.16 に固定。）

## 0.4.0 (April 19, 2014)

FEATURES:

  - Support for "Linux" as a guest OS.（ゲストOS として "Linux" をサポート。）

IMPROVEMENTS:

  - `SetUp-ChefNode` function supports "Linux" as a guest OS.（`SetUp-ChefNode` ファンクションがゲストOS として "Linux" をサポート。）

  - `Converge-ChefNode` function supports "Linux" as a guest OS.（`Converge-ChefNode` ファンクションがゲストOS として "Linux" をサポート。）

## 0.3.2 (April 13, 2014)

IMPROVEMENTS:

  - `Install-Chef` function and `Install-Chef` function change to install the 'chef-client' using 'Chocolatey'.（`Install-Chef` ファンクションと`Update-Chef` ファンクションが 'Chocolatey' を使って 'chef-client' を使ってインストールするように変更。）

## 0.3.1 (April 8, 2014)

BUG FIXES:

  - `New-ChefNodeSpecfile` function: Fixed a problem that the output file is not reflected the IP address.（出力ファイルに IP アドレスが反映されない問題を修正。）

## 0.3.0 (April 5, 2014)

FEATURES:

  - `SetUp-ChefNode` function supports `-ChefServerURL` parameter.（`SetUp-ChefNode` ファンクションが `-ChefServerURL` パラメーターをサポート。）

  - `SetUp-ChefNode` function supports `-UserName` parameter.（`SetUp-ChefNode` ファンクションが `-UserName` パラメーターをサポート。）

  - `Converge-ChefNode` function supports `-UserName` parameter.（`Converge-ChefNode` ファンクションが `-UserName` パラメーターをサポート。）

IMPROVEMENTS:

  - `New-ChefNodeSpecfile` function supports "Linux" as a guest OS.（`New-ChefNodeSpecfile` ファンクションがゲストOS として "Linux" をサポート。）

  - `New-ChefNode` function supports "Linux" as a guest OS.（`New-ChefNode` ファンクションがゲストOS として "Linux" をサポート。）

  - Changed the name of the private functions and private variables.（プライベート関数とプライベート変数の名前を変更。）

  - Fixes grammar error in the log message.（ログメッセージ上の文法誤りを修正。）

## 0.2.0 (April 5, 2014)

FEATURES:

  - `install.ps1` supports `-Branch` parameter.（`install.ps1` が `-Branch` パラメーターをサポート。）

## 0.1.0 (March 21, 2014)

  - Initial release.（初期リリース。）

  - Support for only "Windows" as a guest OS.（ゲストOS として "Windows" のみをサポート。）