# :gift: vim-quickrepl :gift:

**The fastest way to open your REPL for filetypes.**

(like [vim-quickrun](https://github.com/thinca/vim-quickrun))

![sample](sample.gif)

## VS reply.vim

reply.vim is another good way to open REPL, but this often requires a configuration for unknown REPLs (e.g. `stack ghci`).

vim-quickrepl focuses easy to open REPL.
This requires only adding REPL names to `g:quickrepl_config.filetype_name` or `b:quickrepl_config.filetype_name` even so your REPL is not defined on the default config.
