# altpy.vim

This is a simplistic plugin to easily alternate between Python source and test
files. It works for projects which tree looks similar to this one:
```
.
├── src
│   ├── your_module.py
│   └── package
|       └── other_module.py
└── tests
    ├── __init__.py
    ├── your_module_test.py
    └── package
        └── test_other_module.py
```

This means tests are expected to be in a separate directory, have `test_` prefix or`_test` suffix
and mimic source files structure.

If an exact alternate file is not found the closest directory is opened instead.

To see available commands, run `help altpy` in your VIM or see [doc/altpy.txt](doc/altpy.txt).

## Instalation

If you are using [junegunn/vim-plug](https://github.com/junegunn/vim-plug):
```
Plug 'glujan/altpy.vim', {'for': 'python'}
```

## Roadmap
- [x] Support separete src and tests directories
- [ ] Per-project configuration
- [x] Support Django-style tests directories
- [x] Support different test files naming conventions (ie. prefix `test_`)
