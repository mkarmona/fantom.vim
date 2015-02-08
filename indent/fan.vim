" Copyright 2015 Miguel Carmona. All rights reserved.
" Use of this source code is governed by a BSD-style
" license that can be found in the LICENSE file.
"
if exists("b:did_indent")
    finish
endif
let b:did_indent = 1

" C indentation is too far off useful, mainly due to Fantom's := operator.
" Let's just define our own.
setlocal nolisp
setlocal autoindent
setlocal indentexpr=FanIndent(v:lnum)
setlocal indentkeys+=<:>,0=},0=)
setlocal tabstop=2
setlocal shiftwidth=2
setlocal expandtab=2

if exists("*FanIndent")
  finish
endif

function! FanIndent(lnum)
  let prevlnum = prevnonblank(a:lnum-1)
  if prevlnum == 0
    " top of file
    return 0
  endif

  " grab the previous and current line, stripping comments.
  let prevl = substitute(getline(prevlnum), '//.*$', '', '')
  let thisl = substitute(getline(a:lnum), '//.*$', '', '')
  let previ = indent(prevlnum)

  let ind = previ

  if prevl =~ '[({]\s*$'
    " previous line opened a block
    let ind += &sw
  endif
  if prevl =~# '^\s*\(case .*\|default\):$'
    " previous line is part of a switch statement
    let ind += &sw
  endif
  " TODO: handle if the previous line is a label.

  if thisl =~ '^\s*[)}]'
    " this line closed a block
    let ind -= &sw
  endif

  return ind
endfunction
