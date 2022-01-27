setlocal conceallevel=2
setlocal concealcursor=nc

" we want markdown syntax highlighting on the top level
" and haskell highlighting after > and !
runtime! syntax/markdown.vim
syntax case match " set to ignore by markdown.vim ...
syntax clear markdownCodeBlock " our code is bird style, interfers with formatting
unlet b:current_syntax
syntax include @haskellTop syntax/haskell.vim
let b:current_syntax = "lhaskell"

syntax region lhsHaskellBirdTrack start="^>" end="$" contains=@haskellTop,lhsBirdTrack
syntax region lhsHaskellFakeTrack start="^!" end="$" contains=@haskellTop,lhsFakeTrack
syntax match lhsBirdTrack "^>" contained
syntax match lhsFakeTrack "^!" contained
highlight link lhsBirdTrack Comment
highlight link lhsFakeTrack Comment

" extra markdown goodies
syntax region VPmdStrikethrough matchgroup=VPmdStrikethroughDelimiter start="\S\@<=\~\|\~\S\@=" end="\S\@<=\~\|\~\S\@=" skip="\\\*" contains=@Spell concealends oneline
syntax region VPmdUnderline matchgroup=VPmdUnderlineDelimiter start="\w\@<!__\S\@=" end="\S\@<=__\w\@!" skip="\\_" contains=markdownLineStart,markdownItalic,@Spell concealends oneline
syntax region VPmdString matchgroup=VPmdStringDelimiter start="\S\@<=\~\~\|\~\~\S\@=" end="\S\@<=\~\~\|\~\~\S\@=" skip="\\\*" contains=@Spell concealends oneline
syntax region VPmdType matchgroup=VPmdTypeDelimiter start="`" end="`" concealends keepend contains=markdownLineStart oneline
syntax region VPmdSpecial matchgroup=VPmdSpecialDelimiter start=/°/ end=/°/ concealends oneline contains=VPmdSpecialWhitespace

syntax match VPmdSpecialWhitespace "\s" conceal cchar=— contained
syntax match VPmdConclusion "^\s*[=-]>"

highlight VPmdStrikethrough gui=strikethrough
highlight VPmdUnderline gui=underline
highlight default link VPmdString String
highlight default link VPmdType Type
highlight default link VPmdSpecial Special

" bringing the VPmdSpecial color into the structural components
highlight link markdownH1 VPmdSpecial
highlight link markdownH2 markdownH1
highlight! link Conceal VPmdSpecial
highlight! link htmlTagName VPmdSpecial
highlight link VPmdSpecialWhitespace VPmdSpecial
highlight link VPmdConclusion VPmdSpecial

" presentation specific
syntax match VPmdPreProc "^\~\~\~\+$"
syntax match VPmdPreProc "=pause"
syntax match VPmdPreProc "^\%(duration\|title\)=\S.*$"

highlight link VPmdPreProc PreProc
