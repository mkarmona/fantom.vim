" We take care to preserve the user's fileencodings and fileformats,
" because those settings are global (not buffer local), yet we want
" to override them for loading Fantom files, which are defined to be UTF-8.
let s:current_fileformats = ''
let s:current_fileencodings = ''

" define fileencodings to open as utf-8 encoding even if it's ascii.
function! s:fantomfiletype_pre()
  let s:current_fileformats = &g:fileformats
  let s:current_fileencodings = &g:fileencodings
  set fileencodings=utf-8 fileformats=unix
  setlocal filetype=fan
endfunction

" restore fileencodings as others
function! s:fantomfiletype_post()
  let &g:fileformats = s:current_fileformats
  let &g:fileencodings = s:current_fileencodings
endfunction

au BufNewFile *.fan setlocal filetype=fan fileencoding=utf-8 fileformat=unix
au BufRead *.fan call s:fantomfiletype_pre()
au BufReadPost *.fan call s:fantomfiletype_post()
