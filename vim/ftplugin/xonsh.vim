if exists('b:did_ftplugin')
  finish
endif

runtime! ftplugin/python.vim ftplugin/python_*.vim ftplugin/python/*.vim

let b:did_ftplugin=1
