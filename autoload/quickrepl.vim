scriptencoding utf-8
scriptversion 3

const s:V = vital#quickrepl#new()

const s:List = s:V.import('Data.List')
const s:Msg = s:V.import('Vim.Message')

function quickrepl#get_current_config() abort
  return s:extend([
    \ g:quickrepl_default_config,
    \ g:quickrepl_config,
    \ get(b:, 'quickrepl_config', #{}),
  \ ])
endfunction

" A side effective main function.
"
" Users can use quickrepl#run() to specify detailed arguments.
function quickrepl#open(mods, ...) abort
  call quickrepl#log('plugin', 'started by ', a:mods, a:000)

  const mods = a:mods ==# ''
    \ ? 'vertical'
    \ : a:mods

  call quickrepl#run(
    \ quickrepl#get_current_config(),
    \ &filetype,
    \ mods,
    \ a:000,
  \ )
endfunction

" A core function of vim-quickrepl
function quickrepl#run(config, filetype, mods, args) abort
  const cmd = s:get_executable(a:config, a:filetype, a:args)
  if type(cmd) ==# v:t_dict
    call s:Msg.error('quickrepl: ' .. cmd.error)
    return
  endif

  const filetype = s:make_repl_filetype_name(a:filetype, cmd, a:args)
  call term_start(cmd, #{
    \ term_name: filetype,
    \ term_finish: 'close',
  \ })
  const term_bufnr = winbufnr('.')
  quit
  execute a:mods 'split'
  execute 'buffer' term_bufnr
  execute 'set filetype=' .. filetype
endfunction

function s:make_repl_filetype_name(filetype, cmd, args) abort
  const args = len(a:args) is 0
    \ ? ''
    \ : '-' .. join(a:args, '-')

  const cmd = type(a:cmd) is v:t_string
    \ ? a:cmd
    \ : join(a:cmd, '-')

  const text = 'quickrepl-' .. a:filetype .. '-' .. cmd .. args

  " TODO: Fix for :QuickRepl stack ghci :tasty
  return substitute(text, '[^a-zA-Z0-9-_]', '', 'g')
endfunction

function s:get_executable(config, filetype, args) abort
  if a:args !=# []
    if executable(a:args[0])
      return a:args
    endif
    return #{error: a:args[0] .. ' is not executable'}
  endif

  for cmd in get(a:config, a:filetype, [])
    if s:is_executable(cmd)
      return cmd
    endif
  endfor

  return #{error: 'no config for fipetype: ' .. a:filetype}
endfunction

function s:is_executable(cmd) abort
  return (type(a:cmd) ==# v:t_string && executable(a:cmd)) ||
    \ (type(a:cmd) ==# v:t_list && executable(a:cmd[0]))
endfunction

function quickrepl#log(name, ...) abort
  if g:quickrepl_enable_debug
    const message = s:List.foldl({ x, y ->
      \ x .. ', ' .. s:string(y)
    \ }, '', a:000)
    echomsg 'quickrepl>' .. a:name .. ': ' .. message
  endif
endfunction

function s:extend(xs) abort
  let result = #{}
  for x in a:xs
    call extend(result, x)
  endfor
  return result
endfunction

function s:string(x) abort
  return type(a:x) ==# v:t_string
    \ ? a:x
    \ : string(a:x)
endfunction
