" altpy.vim - Quickly alternate between source and tests files
" Maintainer:   glujan <https://github.com/glujan/altpy.vim>
" Version:      0.2
" Licence:      MIT

if exists('g:loaded_altpy')
  finish
endif
let g:loaded_altpy = 1

function! GetAltPath()
python3 << EOF
from __future__ import annotations

from pathlib import Path

import vim

ROOT_DIR = Path('.').absolute()
TESTS_DIR = ('tests', 'test')
SUPPORTED_EXTENSIONS = ('.py', '.go', '.rb')


def _source_to_unit(path: Path | str) -> Path | None:
    source_path = Path(path).absolute().relative_to(ROOT_DIR)

    for directory in source_path.parents:
        possible_test_dirs = (
            tests_dir
            for test_dir in TESTS_DIR
            if (tests_dir := directory / test_dir).is_dir()
        )
        if next(possible_test_dirs, None):
            test_dir_path = (tests_dir / source_path.relative_to(directory)).parent
            possible_test_files = (
                unit_path
                for file_name in (f'test_{source_path.name}', f'{source_path.stem}_test.{source_path.suffix}')
                if (unit_path := test_dir_path / file_name).exists()
            )
            return next(possible_test_files, test_dir_path)
    return None  # TODO raise some exception?


def _unit_to_source(path: Path | str) -> Path | None:
    unit_path = Path(path).absolute().relative_to(ROOT_DIR)
    reversed_unit_path = list(reversed(unit_path.parts))
    for test_dir in TESTS_DIR:
        try:
            idx = reversed_unit_path.index(test_dir)
        except ValueError:
            pass
        else:
            reversed_unit_path.pop(idx)
            *source_dir, unit_name = reversed(reversed_unit_path)
            if unit_name.startswith('test_'):
                source_name = unit_name[5:]
            else:
                source_name = unit_name[:-5]
            source_path = Path(*source_dir, source_name)
            if source_path.exists():
                return source_path
            else:
                return source_path.parent
    return None  # TODO raise some exception?


def alt_path(path: Path | str) -> Path | None:
    filename = Path(path).name
    if not filename.endswith(SUPPORTED_EXTENSIONS):
        return None  # TODO raise some exception?
    elif filename.startswith('test_') or filename.endswith(tuple(f'_test.{ext}' for ext in SUPPORTED_EXTENSIONS)):
        return _unit_to_source(path)
    else:
        return _source_to_unit(path)


alt_path = alt_path(vim.current.buffer.name)
vim.command(f"let altPath = '{alt_path}'")
EOF
  return altPath
endfunction

function! OpenAlt(cmd) abort
  execute "normal! :" . a:cmd . " " . GetAltPath() ."\<cr>"
endfunction

command! A  :call OpenAlt("edit")
command! AE :call OpenAlt("edit")
command! AS :call OpenAlt("split")
command! AV :call OpenAlt("vsplit")
command! AT :call OpenAlt("tabedit")
