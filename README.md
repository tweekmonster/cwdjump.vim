# cwdjump.vim

Jumps restricted to files within the current directory.


## Install

Use a plugin manager.


## Usage

There are two commands: `:CwdJumpBackward` and `:CwdJumpForward`

Since you might want to keep the original keys, there's no default key map.
You'll have to set it up yourself.

Here's an example overriding the `<c-o>` and `<c-i>` keys:

```vim
nnoremap <silent> <c-o> :<c-u>CwdJumpBackward<cr>
nnoremap <silent> <c-i> :<c-u>CwdJumpForward<cr>
```

With those maps, `<c-o>` and `<c-i>` will restrict jumps to files within the
current directory.  Using a count (e.g. `5<c-o>`) will work the same way,
except it will skip files that don't exist within the current directory.

What is the current directory?  See: `:help pwd`
