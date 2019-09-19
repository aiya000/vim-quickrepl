scriptencoding utf-8
scriptversion 3

if exists('g:loaded_vim_quickrepl')
  finish
endif
const g:loaded_vim_quickrepl = v:true

" Configurations

const g:quickrepl_default_config = #{
  \ c: ['cling_c'],
  \ clojure: ['clojure', ['lein', 'repl']],
  \ cpp: ['cling'],
  \ crystal: ['icr'],
  \ csharp: ['csi'],
  \ elixir: ['iex'],
  \ elm: ['elm_repl'],
  \ erlang: ['erl'],
  \ fsharp: ['fsi'],
  \ go: ['go_pry'],
  \ groovy: ['groovysh'],
  \ happy: [['stack', 'ghci'], 'ghci'],
  \ haskell: [['stack', 'ghci'], 'ghci'],
  \ idris: ['idris'],
  \ java: ['jshell'],
  \ javascript: ['node', 'd8', 'electron'],
  \ julia: ['julia'],
  \ kotlin: ['kotlinc'],
  \ lisp: ['sbcl', 'clisp'],
  \ lua: ['lua'],
  \ objc: ['cling_objc'],
  \ ocaml: ['ocaml'],
  \ php: ['psysh', 'php'],
  \ prolog: ['swipl'],
  \ python: ['ptpython', 'python3', 'python'],
  \ r: ['R'],
  \ racket: ['racket'],
  \ ruby: ['pry', 'irb'],
  \ scala: ['scala'],
  \ scheme: ['gauche', 'chibi_scheme', 'mit_scheme', ['racket', '-i']],
  \ sh: ['bash', 'sh'],
  \ sml: ['sml'],
  \ swift: ['swift'],
  \ typescript: ['ts-node', 'tsun'],
  \ zsh: ['zsh'],
\ } | lockvar! g:quickrepl_default_config

let g:quickrepl_config = get(g:, 'quickrepl_config', #{})
let g:quickrepl_use_default_key_mapping = get(g:, 'quickrepl_use_default_key_mapping', v:false)
let g:quickrepl_enable_debug = get(g:, 'quickrepl_enable_debug', v:false)

" Key mapping

function s:via_key() abort
  call quickrepl#log('plugin', 'start via key')
  call quickrepl#run(quickrepl#get_current_config(), &filetype, 'vertical', [])
endfunction

nnoremap <silent> <Plug>(quickrepl-open) :<C-u>call <SID>via_key()<CR>

" Commands

command! -bar -nargs=* QuickReplOpen call quickrepl#open(<q-mods>, <f-args>)

" Side effects for a user

if g:quickrepl_use_default_key_mapping
  nmap <localleader>R <Plug>(quickrepl-open)
endif
