function! airline#extensions#native_lsp#get_status() abort
  " Take advantage of fact that plugin is loaded after vimrc
  return airline#util#shorten(LspStatus(), 50, 9)
endfunction

function! airline#extensions#native_lsp#init(ext) abort
  call airline#parts#define_function('native_lsp_status', 'airline#extensions#native_lsp#get_status')
endfunction
