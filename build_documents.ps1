Set-Location $PSScriptRoot

Get-ChildItem -Path .\documents -Filter *.md | ForEach-Object {
    $command = "pandoc -s --table-of-contents --template=.pandoc_template.html $($_.FullName) -o $($_.FullName -replace '\.md$','.html')"
    Invoke-Expression $command
}
