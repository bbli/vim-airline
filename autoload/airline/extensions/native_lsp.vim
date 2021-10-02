function! s:LspStatus() abort
    if !has('nvim')
        return ""
    endif 
    if (g:benson_lsp_status == 0)
        return ""
    endif

  if luaeval('#vim.lsp.buf_get_clients() > 0')
    let result = luaeval("require('lsp-status').status()")
    " NOTE:Need to slice result since plugin's return string has useless fluff
    return result[9:]
  endif

  return ''
endfunction

function! airline#extensions#native_lsp#get_status() abort
  " Take advantage of fact that plugin is loaded after vimrc
  let result = s:LspStatus()
  if result ==# "" 
      return "" 
  endif
  
  let final_result = airline#util#shorten(result, 50, 9)
  if count(final_result,"%") == 0
      return ""
  else
      return final_result
  endif
endfunction

function! airline#extensions#native_lsp#init(ext) abort
  call airline#parts#define_function('native_lsp_status', 'airline#extensions#native_lsp#get_status')
endfunction
