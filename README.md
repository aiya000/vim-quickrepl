# :gift: vim-quickrepl :gift:

The **Simplest** Faster way to open your REPL for filetypes.

(like [vim-quickrun](https://github.com/thinca/vim-quickrun))

![sample](sample.gif)

## VS reply.vim

reply.vim is another good way to open REPL.
But this focuses to synchronize REPL buffers and file buffers,
this often requires a configuration for unknown REPLs
(e.g. `stack ghci`).

vim-quickrepl focuses **simplicity** to configurate.

## :dizzy: How to install :dizzy:

### No package manager

Clone this repo into `$MYVIMRC/pack/haskell/start/`

### dein.nvim

```haskell
call dein#add('aiya000/vim-quickrepl')
```

### dein.nvim with toml

```toml
[[plugins]]
repo = 'aiya000/vim-quickrepl'
```
