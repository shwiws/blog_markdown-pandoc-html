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