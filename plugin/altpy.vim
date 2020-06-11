" altpy.vim - Quickly alternate between source and tests files
" Maintainer:   glujan <https://github.com/glujan/altpy.vim>
" Version:      0.1
" Licence:      MIT

if exists('g:loaded_altpy')
  finish
endif
let g:loaded_altpy = 1
let g:altpy_test_dir = "tests/unit/"
let g:altpy_src_dir = "src/"

function! FileName() abort
  let fileName=expand("%:r")

  if fileName =~ "^" . g:altpy_test_dir
    let path=substitute(fileName, "^" . g:altpy_test_dir, g:altpy_src_dir, "")
    let path=substitute(path, "_test$", "", "")
    let altFile = path . ".py"
  elseif fileName =~ "^" . g:altpy_src_dir
    let path=substitute(fileName, "^" . g:altpy_src_dir, g:altpy_test_dir, "")
    let altFile = path . "_test.py"
  else
    echoerr "Could not find alternate file"
    let altFile = ""
  endif

  return altFile
endfunction

function! OpenAlt(cmd) abort
  if stridx(expand("%"), ".py") == -1
    return
  endif

  execute "normal! :" . a:cmd . " " . FileName() ."\<cr>"
endfunction

command! A  :call OpenAlt("edit")
command! AE :call OpenAlt("edit")
command! AS :call OpenAlt("split")
command! AV :call OpenAlt("vsplit")
command! AT :call OpenAlt("tabedit")
