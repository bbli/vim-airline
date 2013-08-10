" MIT license. Copyright (c) 2013 Bailey Ling.
" vim: ts=2 sts=2 sw=2 fdm=indent

" http://got-ravings.blogspot.com/2008/10/vim-pr0n-statusline-whitespace-flags.html

function! airline#extensions#whitespace#check()
  if &readonly || !g:airline_detect_whitespace
    return ''
  endif

  if !exists('b:airline_whitespace_check')
    let b:airline_whitespace_check = ''
    let trailing = search(' $', 'nw')
    let indents = [search('^ ', 'nb'), search('^ ', 'n'), search('^\t', 'nb'), search('^\t', 'n')]
    let mixed = indents[0] != 0 && indents[1] != 0 && indents[2] != 0 && indents[3] != 0

    if trailing != 0 || mixed
      let b:airline_whitespace_check = g:airline_whitespace_symbol." "
      if g:airline_detect_whitespace == 1
        if trailing != 0
          let b:airline_whitespace_check .= 'trailing['.trailing.'] '
        endif
        if mixed
          let mixnr = indents[0] == indents[1] ? indents[0] : indents[2]
          let b:airline_whitespace_check .= 'mixed-indent['.mixnr.'] '
        endif
      endif
    endif
  endif
  return b:airline_whitespace_check
endfunction!

function! airline#extensions#whitespace#apply()
  if exists('w:airline_active') && w:airline_active
    if !exists('w:airline_section_warning')
      let w:airline_section_warning = ' '
    endif
    let w:airline_section_warning .= '%{airline#extensions#whitespace#check()}'
  endif
endfunction

function! airline#extensions#whitespace#toggle()
  let g:airline_detect_whitespace = !g:airline_detect_whitespace
  if g:airline_detect_whitespace
    call airline#extensions#whitespace#init()
  else
    autocmd! airline_whitespace CursorHold,BufWritePost
  endif
endfunction

let s:initialized = 0
function! airline#extensions#whitespace#init()
  if !s:initialized
    let s:initialized = 1
    call add(g:airline_statusline_funcrefs, function('airline#extensions#whitespace#apply'))
  endif

  augroup airline_whitespace
    autocmd!
    autocmd CursorHold,BufWritePost * unlet! b:airline_whitespace_check
  augroup END
endfunction
