
" このバッファに対してまだ実行されていない場合のみ処理を実行する
if exists("b:did_ftplugin")
  finish
endif

runtime! ftplugin/python.vim ftplugin/python_*.vim ftplugin/python/*.vim

let b:did_ftplugin=1
