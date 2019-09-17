scriptencoding utf-8
scriptversion 3

const s:V = vital#quickrepl#new()

const s:List = s:V.import('Data.List')
const s:Msg = s:V.import('Vim.Message')

function quickrepl#get_current_config() abort
  const quickrepl_user_config = get(g:, 'quickrepl_config', #{})
  const quickrepl_user_buffer_config = get(b:, 'quickrepl_config', #{})

  return s:extend([
    \ g:quickrepl_default_config,
    \ quickrepl_user_config,
    \ quickrepl_user_buffer_config,
  \ ])
endfunction

function quickrepl#open(config, filetype, mods, args) abort
  const cmd = s:get_executable(a:config, a:filetype, a:args)
  if type(cmd) ==# v:t_string
    call s:Msg.error('quickrepl: ' .. cmd)
    return
  endif

  const filetype = 'quickrepl-' .. a:filetype
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

function s:get_executable(config, filetype, args) abort
  if a:args !=# []
    if executable(a:args[0])
      return a:args
    endif
    return a:args[0] .. ' is not executable'
  endif

  for cmd in get(a:config, a:filetype, [])
    if s:is_executable(cmd)
      return cmd
    endif
  endfor

  return 'no config for fipetype: ' .. a:filetype
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
