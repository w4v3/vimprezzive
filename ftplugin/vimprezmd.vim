if exists('b:loaded_vimprezzivemd') | finish | endif
let b:loaded_vimprezzivemd = 1

setlocal formatoptions+=ro
setlocal comments+=:!
setlocal signcolumn=no

command Compile call s:Compile()

" creates a vimprez.lhs file
function s:Compile()
  let fn=expand('%:r:r').'.vimprez.lhs'
  let out=['','~~~']
  " use current (estimated) window size
  let row=&lines - 2 - &cmdheight - (&laststatus == 2)
  let col=&columns - ((&number || &relativenumber) ? &numberwidth : 0) - &foldcolumn

  let acc=[]
  let prevline=''
  let sec=''
  for line in getbufline(bufnr(),'1','$')
    if line =~ '^\~\~\~\+$' " slide done
      let out+=s:MakePauses(s:TransformList(acc,row,col,sec),row)+[line]
      let acc=[]
      let prevline=''
    elseif line =~ '^=\+$' " level 1 heading: make own page, use as title until next level 2 heading
      if !empty(acc)
        call remove(acc,-1)
      endif
      let res=s:MakePauses(s:TransformList(acc,row,col,sec),row)
      let out+=res
      if empty(res)
        let out+=s:MakeTitle(prevline,row,col)+['~~~']
      else
        let out+=['~~~']+s:MakeTitle(prevline,row,col)+['~~~']
      endif
      let acc=[]
      let sec=prevline
      let prevline=''
    elseif line =~ '^-\+$' " level 2 heading: use as title for each following slide
      if !empty(acc)
        call remove(acc,-1)
      endif
      let sec=prevline
      let prevline=''
    elseif line =~ '^\%(title\|duration\)=\S.*$' " presentation instructions
      call add(out,line)
    else
      call add(acc,line)
      let prevline=line
    endif
  endfor
  let out+=s:MakePauses(s:TransformList(acc,row,col,sec),row)
  let out+=['~~~', '', '']
  call writefile(out,fn,'b')
  execute 'edit '.fn
endfunction

" add 4 spaces in front of every line
" remove newlines at beginning and end (except around > code)
" center the result on the page vertically
function s:TransformList(lst,row,col,sec)
  while !empty(a:lst) && empty(a:lst[0]) 
        \ && (len(a:lst) == 1 || empty(a:lst[1]) || a:lst[1][0] != '>') " lhs needs empty lines above and below bird-style code
    call remove(a:lst,0)
  endwhile
  while !empty(a:lst) && empty(a:lst[-1])
        \ && (len(a:lst) == 1 || empty(a:lst[-2]) || a:lst[-2][0] != '>')
    call remove(a:lst,-1)
  endwhile
  if empty(a:lst) | return [] | endif
  if !empty(a:sec)
    let titlehdr=[' '.a:sec,repeat('-',a:col)]
  else
    let titlehdr=[]
  endif
  for i in range(len(a:lst))
    if a:lst[i][0] =~ '[>!]'
      let a:lst[i]=a:lst[i][0].'    '.a:lst[i][1:]
    elseif a:lst[i] !~ '^\~\~\~\+$'
      let a:lst[i]='    '.a:lst[i]
    endif
  endfor
  let gap=float2nr(floor((a:row-len(a:lst)-len(titlehdr))/2))
  if gap <= 0
    return titlehdr+a:lst
  else
    let gaps=repeat([''],gap)
    return s:Extend(titlehdr+gaps+a:lst,a:row)
  endif
endfunction

" break page apart on =pause tokens and create copies for piecewise uncovering
" code from previous pages has > replaced with ! so that ghc doesn't complain
" about multiple definitions
function s:MakePauses(lst,row)
  let out=[]
  let acc=[]
  let unfinishedbusiness=0
  for line in a:lst
    if line =~ '=pause'
      let matches=[]
      let isfirst=1
      let count=0
      for bit in split(line,'=pause',1)
        let count+=1
        if isfirst
          call add(acc,bit)
          let isfirst=0
        else
          let acc[-1].=bit
        endif
        if count < len(split(line,'=pause',1))
          let out+=s:Extend(acc,a:row)+['~~~']
          let acc=map(acc,'substitute(v:val,"^>","!","")')
        else
          let unfinishedbusiness=1
        endif
      endfor
    else
      call add(acc,line)
    endif
  endfor
  if unfinishedbusiness
    let out+=s:Extend(acc,a:row)
  else
    let out+=acc
  endif
  return out
endfunction

" section title page: center title vertically and horizontally, draw line
" underneath
function s:MakeTitle(sec,row,col)
  let gapv=float2nr(floor((a:row-3)/2))
  let gaph=float2nr(floor((a:col-len(a:sec))/2))
  let out=repeat([''],gapv)
  let out+=[repeat(' ',gaph).a:sec,repeat('=',a:col)]
  return s:Extend(out,a:row)
endfunction

" return page filled to the requiried format without changing the original
" page in a:lst
function s:Extend(lst,row)
  let out=copy(a:lst)
  let out+=repeat([''],a:row-len(a:lst))
  return out
endfunction
