# altpy.vim

This is a simplistic plugin to easily alternate between Python source and test
files. Currently it works only for projects which tree look similar to this one:
```
.
├── src
│   └── your_module.py
└── tests
    ├── __init__.py
    └── unit
        ├── __init__.py
        └── your_module_test.py
```

This means tests are expected to be in a separate directory, have `_test` suffix
and mimic source files structure.

## Instalation

If you are using junegunn/vim-plug:
```
Plug 'glujan/altpy.vim', {'for': 'python'}
```

## Configuration
Configuration is global but this might change in the future. Currently there are
two options settings:
```
let g:altpy_test_dir = "tests/unit/"
let g:altpy_src_dir = "src/"
```

## Roadmap
- [x] Support separete src and tests directories
- [ ] Per-project configuration
- [ ] Support Django-style tests directories
- [ ] Support different test files naming conventions (ie. prefix `test_`)
