scriptencoding utf-8
scriptversion 3

if exists('g:loaded_vim_quickrepl')
  finish
endif
const g:loaded_vim_quickrepl = v:true

" Configurations

const g:quickrepl_default_config = #{
  \ ruby: ['irb'],
  \ haskell: [['stack', 'ghci'], 'ghci'],
\ }

let g:quickrepl_use_default_key_mapping = get(g:, 'quickrepl_use_default_key_mapping', v:false)

" Key mapping

function s:via_key() abort
  call quickrepl#open(quickrepl#get_current_config(), &filetype, 'vertical', [])
endfunction

nnoremap <silent> <Plug>(quickrepl-open) :<C-u>call <SID>via_key()<CR>

" Commands

function s:via_cmd(mods, args) abort
  const mods = a:mods ==# ''
    \ ? 'vertical'
    \ : a:mods

  call quickrepl#open(
    \ quickrepl#get_current_config(),
    \ &filetype,
    \ mods,
    \ a:args,
  \ )
endfunction

command! -bar -nargs=? QuickReplOpen call s:via_cmd(<q-mods>, [<f-args>])

" Side effects for a user

if g:quickrepl_use_default_key_mapping
  nmap <localleader>R <Plug>(quickrepl-open)
endif