# 環境

- Windows 10 Pro 64bit
- PowerShell 5.1

# やりたいこと

- 環境設定スクリプト
- html出力スクリプト

# 環境設定スクリプト

## 実現したい環境

pandocでmarkdownを変換できる環境



## pandoc…の前にwinget

「ググって普通にインストールしてくれ」で済めばいいんですが、野良の変なインストーラーをつかんでセキュリティインシデントになっても困るので方法を統一する上で **winget** を利用します。

[https://learn.microsoft.com/ja-jp/windows/package-manager/winget/:embed:cite]

これはMicrosoft Storeで配布されているので、誰でも間違いなくインストールできます。
しかしこれもストア内検索で変なアプリを入れてしまうリスクを避けるために環境設定スクリプトに含めちゃいます。

```ps1
# ストアのアプリ インストーラー(winget)のページを開くからインストールしてね、とスクリプト上でメッセージを出す
[System.Diagnostics.Process]::Start('ms-windows-store://pdp/?productId=9NBLGGH4NNS1')
```

何度も表示しないよう、**pandoc**がインストール済か、[*Get-Command*](https://learn.microsoft.com/ja-jp/powershell/module/microsoft.powershell.core/get-command?view=powershell-7.2)で確認します。

それを加味すると以下のようになります。

```ps1
if (-not (Get-Command winget -ErrorAction Ignore)) {
    # ストアのアプリ インストーラー(winget)のページを開くからインストールしてね、とスクリプト上でメッセージを出す
    [System.Diagnostics.Process]::Start('ms-windows-store://pdp/?productId=9NBLGGH4NNS1')
    pause
    exit
}
```

これでwingetのインストール部分は完成

## pandoc

wingetがインストールできたので次はpandocのインストールです。
インストール済みである場合を考慮して以下のようにします。

Get-Command でチェックしてインストールする方法

```ps1
if (-not (Get-Command pandoc -ErrorAction Ignore)) {
    winget install JohnMacFarlane.Pandoc
}
```

wingetを生かして```winget list pandoc```でも確認できます。
その場合は ```$LASTEXITCODE```が```0```の時がインストール済です。

## pandoc用のテンプレート導入

html出力しただけではドキュメント読者には辛いと思うのでシンプルできれいなテンプレートを利用します。

ryangrose/easy-pandoc-templates
[https://github.com/ryangrose/easy-pandoc-templates:embed:cite]


```ps1
$template = '.\.pandoc_template.html'
Invoke-WebRequest `
    -Uri https://raw.githubusercontent.com/ryangrose/easy-pandoc-templates/master/html/elegant_bootstrap_menu.html `
    -OutFile "$template"
```
## まとめ(setup_documentation_env.ps1)

以上の内容をまとめて以下のように実装しました。

```ps1
if (-not (Get-Command winget -ErrorAction Ignore)) {
    # ストアのアプリ インストーラー(winget)のページを開くからインストールしてね、とバッチ上でメッセージを出す
    [System.Diagnostics.Process]::Start('ms-windows-store://pdp/?productId=9NBLGGH4NNS1')
    Pause
    # 一旦終了してwingetをインストールしてもらう
    exit
}


if (-not (Get-Command pandoc -ErrorAction Ignore)) {
    winget install JohnMacFarlane.Pandoc
}

# pandocのテンプレートをローカルにダウンロードする。
$template = '.\.pandoc_template.html'
Invoke-WebRequest `
    -Uri https://raw.githubusercontent.com/ryangrose/easy-pandoc-templates/master/html/elegant_bootstrap_menu.html `
    -OutFile "$template"
```

# html出力スクリプト

ここまでで環境設定が完了したのでhtmlに出力するスクリプトを実装します。

ベースとなるフォルダの中に **documents** というフォルダがあることを前提として、そのフォルダ内でmdファイルをhtmlファイルに変換していくという処理のスクリプトです。

```ps1
Set-Location $PSScriptRoot

Get-ChildItem -Path .\documents -Filter *.md | ForEach-Object {
    $command = "pandoc -s --table-of-contents --template=.pandoc_template.html $($_.FullName) -o $($_.FullName -replace '\.md$','.html')"
    Invoke-Expression $command
}

```
