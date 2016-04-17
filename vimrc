" base_dir
let s:vim_files_dir = "~/dotfiles/vim/"

" 環境ごとに変えたい
let s:vim_files=[
   \    {
   \        "load": 1,
   \        "filename": "vim_settings.vim"
   \    },
   \    {
   \        "load": 1,
   \        "filename": "vim_plug_base.vim"
   \    },
   \    {
   \        "load": 0,
   \        "filename": "vim_plugins_1.vim"
   \    },
   \]

let s:my_load_script="~/dotfiles/vim/my_loader.vim"

if filereadable(expand(s:my_load_script))
 execute 'source ' . s:my_load_script
endif

if exists("*LoadSettingFiles")
 call LoadSettingFiles(s:vim_files)
else
 echohl WarningMsg
 echo "LoadSettingFiles is not found"
 echo "Please check ". s:my_load_script . " is exists"
 echo "or is there a typo ."
 echohl None
endif
