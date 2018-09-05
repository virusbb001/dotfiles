"
" Vim syntax file
" Language:	Xonsh
" Maintainer:	virusbb001 <virusbb001a@gmail.com>
" Last Change: YYYY LLL dd
"
if exists("b:current_syntax")
  finish
endif

" for debug
syntax clear

runtime! syntax/python.vim

" for environment
syntax iskeyword @,48-57,192-255,$,_

" documented environments
" ["$" + e for e in xonsh.environ.DEFAULT_DOCS.keys() if "*" not in e]

syntax keyword xshReservedEnv $ANSICON $AUTO_CD $AUTO_PUSHD $AUTO_SUGGEST
syntax keyword xshReservedEnv $AUTO_SUGGEST_IN_COMPLETIONS $BASH_COMPLETIONS
syntax keyword xshReservedEnv $CASE_SENSITIVE_COMPLETIONS $CDPATH $COLOR_INPUT
syntax keyword xshReservedEnv $COLOR_RESULTS $COMPLETIONS_BRACKETS $COMPLETIONS_DISPLAY
syntax keyword xshReservedEnv $COMPLETIONS_CONFIRM $COMPLETIONS_MENU_ROWS $COMPLETION_QUERY_LIMIT
syntax keyword xshReservedEnv $DIRSTACK_SIZE $DYNAMIC_CWD_WIDTH $DYNAMIC_CWD_ELISION_CHAR
syntax keyword xshReservedEnv $EXPAND_ENV_VARS $FORCE_POSIX_PATHS $FOREIGN_ALIASES_OVERRIDE
syntax keyword xshReservedEnv $PROMPT_FIELDS $FUZZY_PATH_COMPLETION $GLOB_SORTED
syntax keyword xshReservedEnv $HISTCONTROL $IGNOREEOF $INDENT $INTENSIFY_COLORS_ON_WIN $LANG
syntax keyword xshReservedEnv $LOADED_RC_FILES $MOUSE_SUPPORT $MULTILINE_PROMPT $OLDPWD
syntax keyword xshReservedEnv $PATH $PATHEXT $PRETTY_PRINT_RESULTS $PROMPT $PROMPT_TOOLKIT_COLOR_DEPTH
syntax keyword xshReservedEnv $PUSHD_MINUS $PUSHD_SILENT $RAISE_SUBPROC_ERROR $RIGHT_PROMPT
syntax keyword xshReservedEnv $BOTTOM_TOOLBAR $SHELL_TYPE $SUBSEQUENCE_PATH_COMPLETION
syntax keyword xshReservedEnv $SUGGEST_COMMANDS $SUGGEST_MAX_NUM $SUGGEST_THRESHOLD
syntax keyword xshReservedEnv $SUPPRESS_BRANCH_TIMEOUT_MESSAGE $TERM $TITLE $UPDATE_COMPLETIONS_ON_KEYPRESS
syntax keyword xshReservedEnv $UPDATE_OS_ENVIRON $UPDATE_PROMPT_ON_KEYPRESS $VC_BRANCH_TIMEOUT $VC_HG_SHOW_BRANCH
syntax keyword xshReservedEnv $VI_MODE $VIRTUAL_ENV $WIN_UNICODE_CONSOLE $XDG_CONFIG_HOME
syntax keyword xshReservedEnv $XDG_DATA_HOME $XONSHRC $XONSH_APPEND_NEWLINE $XONSH_AUTOPAIR
syntax keyword xshReservedEnv $XONSH_CACHE_SCRIPTS $XONSH_CACHE_EVERYTHING $XONSH_COLOR_STYLE $XONSH_CONFIG_DIR
syntax keyword xshReservedEnv $XONSH_DEBUG $XONSH_DATA_DIR $XONSH_ENCODING $XONSH_ENCODING_ERRORS
syntax keyword xshReservedEnv $XONSH_HISTORY_BACKEND $XONSH_HISTORY_FILE $XONSH_HISTORY_MATCH_ANYWHERE
syntax keyword xshReservedEnv $XONSH_HISTORY_SIZE $XONSH_INTERACTIVE $XONSH_LOGIN
syntax keyword xshReservedEnv $XONSH_PROC_FREQUENCY $XONSH_SHOW_TRACEBACK $XONSH_SOURCE
syntax keyword xshReservedEnv $XONSH_STDERR_PREFIX $XONSH_STDERR_POSTFIX $XONSH_STORE_STDIN
syntax keyword xshReservedEnv $XONSH_STORE_STDOUT $XONSH_TRACEBACK_LOGFILE $XONSH_DATETIME_FORMAT

" $XONSH_GITSTATUS_*
syntax keyword xshReservedEnv $XONSH_GITSTATUS_HASH $XONSH_GITSTATUS_BRANCH $XONSH_GITSTATUS_OPERATION
syntax keyword xshReservedEnv $XONSH_GITSTATUS_STAGED $XONSH_GITSTATUS_CONFLICTS $XONSH_GITSTATUS_CHANGED
syntax keyword xshReservedEnv $XONSH_GITSTATUS_UNTRACKED $XONSH_GITSTATUS_STASHED $XONSH_GITSTATUS_CLEAN
syntax keyword xshReservedEnv $XONSH_GITSTATUS_AHEAD $XONSH_GITSTATUS_BEHIND

" keyword of xonsh
syntax keyword xshReservedEnv aliases

highlight default link xshReservedEnv PreProc

let b:current_syntax = "xonsh"
