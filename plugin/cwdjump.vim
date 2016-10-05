function! s:jump(delta) abort
  redir => jumplines
  silent jumps
  redir END

  let lines = split(jumplines, "\n", 0)[1:]
  let i = 0
  let l = len(lines)
  let pos = l - 1
  let dir = -1
  let jlist = []

  while i < l
    if lines[i] =~# "^>"
      let pos = i
      call add(jlist, {'jump': 0, 'file': expand('%:p')})
      let dir = 1
    else
      let j = str2nr(matchstr(lines[i], '\s*\zs\d\+'))
      let lnum = str2nr(matchstr(lines[i], '\s*\d\+\s\+\zs\d\+'))
      let fname = matchstr(lines[i], '\%(\s*\d\+\)\{3}\s*\zs.*')
      let sline = matchstr(getline(lnum), '\s*\zs.*')[:20]

      if sline == fname[:20]
        let fname = expand('%:p')
      else
        let fname = fnamemodify(fname, ':p')
      endif

      call add(jlist, {'jump': j * dir, 'file': fname})
    endif

    let i += 1
  endwhile

  let cwd = '^'.escape(getcwd(), '\^$.*~&[]')
  let dir = a:delta < 0 ? -1 : 1
  let step = abs(a:delta)

  let j = 0
  let fname = expand('%:p')

  while (dir == -1 ? pos > 0 : pos < l - 1) && step > 0
    let pos += dir
    if jlist[pos].file =~# cwd && filereadable(jlist[pos].file)
      let j = jlist[pos].jump
      let fname = jlist[pos].file
      let step -= 1
    endif
  endwhile

  if fname !~# cwd || !filereadable(fname)
    return
  endif

  if !j
    return
  endif
  execute "normal! ".abs(j).(j < 0 ? "\<c-o>" : "\<c-i>")
endfunction


command! CwdJumpBackward call s:jump(v:count1 * -1)
command! CwdJumpForward call s:jump(v:count1)
