if (-not (Get-Command winget -ErrorAction Ignore)) {
    # �X�g�A�̃A�v�� �C���X�g�[���[(winget)�̃y�[�W���J������C���X�g�[�����ĂˁA�ƃo�b�`��Ń��b�Z�[�W���o��
    [System.Diagnostics.Process]::Start('ms-windows-store://pdp/?productId=9NBLGGH4NNS1')
    Pause
    # ��U�I������winget���C���X�g�[�����Ă��炤
    exit
}


if (-not (Get-Command pandoc -ErrorAction Ignore)) {
    winget install JohnMacFarlane.Pandoc
}

# pandoc�̃e���v���[�g�����[�J���Ƀ_�E�����[�h����B
$template = '.\.pandoc_template.html'
Invoke-WebRequest `
    -Uri https://raw.githubusercontent.com/ryangrose/easy-pandoc-templates/master/html/elegant_bootstrap_menu.html `
    -OutFile "$template"