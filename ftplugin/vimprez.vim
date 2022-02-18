if exists('b:loaded_vimprezzive') | finish | endif
let b:loaded_vimprezzive = 1

setlocal scrolloff=0
setlocal nowrap
setlocal nocursorline
setlocal nocursorcolumn
setlocal laststatus=2
setlocal statusline=%!get(b:,'vimP_title',expand('%'))
setlocal noshowcmd
setlocal signcolumn=no
setlocal foldcolumn=0
setlocal foldtext=''
setlocal fillchars+=fold:\ 
setlocal formatoptions+=ro
setlocal comments+=:!

syntax on

nnoremap <silent> <right> :NextFrame<CR>
nnoremap <silent> <left>  :PrevFrame<CR>
nnoremap q zE:nunmap q<CR>

command NextFrame call s:NextFrame()
command PrevFrame call s:PrevFrame()
command Resume call s:Resume()
command Restart call s:Run()

" use folds to hide everything except the current frame
function s:GoTo(frame)
  nnoremap q zE:nunmap q<CR>
  if a:frame < s:virtualslides-1 || a:frame > s:numslides+s:virtualslides-2 | return | endif
  let linecount=1
  let framecount=0
  let framestart=1
  let frameend=1
  let foundstart=0
  for line in getbufline(bufnr(),1,"$")
    if line =~ '^\~\~\~\+'
      let framecount+=1
      if framecount == a:frame
        if foundstart
          let foundstart=0
          let frameend=linecount
          break
        else
          let foundstart=1
          let framestart=linecount
          let framecount-=1
        endif
      endif
    endif
    let linecount+=1
  endfor
  normal! zE
  execute "1," . eval(framestart) . "fold"
  execute eval(frameend) . ",$" . "fold"
  execute "normal! 1ztgg".&scroll."jk"
  let s:frame=a:frame
endfunction

" display elapsed time and progress in slides graphically
" if less than 2 min remaining or time is ahead of slide progress,
" this is drawn in VPmdString color, otherwise VPmdSpecial
function s:PrintTimer()
  let elapsed = localtime() - s:timerStart
  let goal = get(b:, 'vimP_duration', 0) * 60
  let slidepos = min([v:echospace, ((s:frame-s:virtualslides+2) * v:echospace) / s:numslides])
  let elapsedpos = goal ? min([v:echospace, (elapsed * v:echospace) / goal]) : 0
  let indicator = printf("%-*s", v:echospace, repeat('=', slidepos))
  let indicator = substitute(indicator, '\%'.slidepos.'c.', '>', "")
  let indicator = substitute(indicator, '\%1c.', '[', "")
  let indicator = substitute(indicator, '\%'.v:echospace.'c.', ']', "")
  let indicator = substitute(indicator, '\%'.elapsedpos.'c.', 'O', "")

  if !(slidepos == v:echospace) && ((goal && goal-elapsed < 2) || elapsedpos > slidepos)
      echohl VPmdString
  else
      echohl VPmdSpecial
  endif

  echo indicator
endfunction

function s:NextFrame()
  call s:GoTo(s:frame+1)
  call s:PrintTimer()
endfunction

function s:PrevFrame()
  call s:GoTo(s:frame-1)
  call s:PrintTimer()
endfunction

function s:Resume()
  call s:GoTo(s:frame)
endfunction

let s:addedVirtSlides=0
function s:Run()
  let s:timerStart=localtime()
  let s:numslides=-1 " not first and last slide
  let s:virtualslides=2 " first and last slide
  " find the =title, =duration options and wrap them in their own slides
  " to hide them, these slides count as inaccessible
  for l in range(1,line('$'))
    let line=getline(l+s:virtualslides-2) " need to accound for added ~~~
    if line =~ '^\~\~\~\+'
      let s:numslides+=1
    elseif line =~ '^\%(title\|duration\)=\S.*$'
      execute "let b:vimP_".line
      if !s:addedVirtSlides
        call append(l+s:virtualslides-2,'~~~')
      endif
      let s:virtualslides+=1
    endif
  endfor
  let s:addedVirtSlides=1
  augroup Vimprez
      autocmd!
      autocmd CursorHold *.vimprez.lhs call s:PrintTimer()
      autocmd CursorMoved *.vimprez.lhs call s:PrintTimer()
  augroup END
  let s:frame=s:virtualslides-1
  silent call s:GoTo(s:frame)
endfunction

call s:Run()

" HTML conversion

command ConvertHTML call s:ConvertHTML()

let s:jspath=expand('<sfile>:p:h') . "/converthtml.js"
" using TOhtml
function s:ConvertHTML()
  call s:FoldAll()

  let g:html_number_lines=0
  let g:html_no_foldcolumn=1
  let g:html_dynamic_folds=1
  silent TOhtml
  
  " remove the ~~~
  %substitute/^<span class="PreProc">\zs\~\~\~*\ze<\/span>$//e
  " Conceal = VPmdSpecial is somehow not respected
  %substitute/.Conceal { .*//e
  /.VPmdSpecial
  normal! yyp0wciwConceal
  " include js script for navigation
  normal! G
  execute "read" . s:jspath
  wq
  call s:Resume()
endfunction

" wrap every slide into a fold to be used in the html file by js
function s:FoldAll()
  normal! zE
  let linecount=1
  let framestart=0
  let frameend=1
  for line in getbufline(bufnr(),1,"$")
    if line =~ '^\~\~\~\+'
      let frameend=linecount
      execute eval(framestart+1) . "," . eval(frameend) . "fold"
      execute eval(framestart+1) . "," . eval(frameend) . "foldopen"
      let framestart=linecount
    endif
    let linecount+=1
  endfor
endfunction


