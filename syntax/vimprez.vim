" basically like vimprezmd, but conceal more
runtime! syntax/vimprezmd.vim

setlocal concealcursor=nvic

syntax match lhsBirdTrack "^>" contained conceal
syntax match lhsFakeTrack "^!" contained conceal

syntax region VPmdSpecial matchgroup=Ignore start=/°/ end=/°/ concealends oneline contains=VPmdSpecialWhiteSpace

syntax match markdownHeadingRule "[=-]" contained containedin=markdownH1,markdownH2 conceal cchar=—

syntax match Ignore "^\%(duration\|title\)=\S.*$" conceal

highlight clear Folded
