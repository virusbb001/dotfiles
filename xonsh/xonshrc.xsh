# vim: set fileencoding=utf-8 filetype=xonsh.python :

from braceexpand import braceexpand
import shutil
import neovim
import os
import platform
from pathlib import Path

xontrib load coreutils vox vox_tabcomplete readable-traceback jedi docker_tabcomplete

# Config

# show error trace
$XONSH_SHOW_TRACEBACK = True

$IGNOREEOF = True
$INDENT = " " * 4
$AUTO_PUSHD = True
$PUSHD_MINUS = True # todo: check
$HISTCONTROL = set("ignoredups")
$INTENSIFY_COLORS_ON_WIN = False
$AUTO_CD = True
$PROMPT = "{env_name:{}}{BOLD_GREEN}{user}@{hostname}{BOLD_BLUE} {short_cwd}{branch_color}{curr_branch: {}}{NO_COLOR} {BOLD_BLUE}{prompt_end}> {NO_COLOR}"

## input config
$UPDATE_COMPLETIONS_ON_KEYPRESS = False
$CASE_SENSITIVE_COMPLETIONS = False
$COMPLETIONS_CONFIRM = False
$VI_MODE = False
$XONSH_AUTOPAIR = True

# Custom Path Search
# brace expand
# use to @b`file{1,2,3}`
def b(s):
    return list(braceexpand(s))

# Aliases
aliases["where"]=["which","-a"]
aliases["gti"]="git"
aliases["vi"]='vim'

if shutil.which("nvim"):
    aliases["vim"] = "nvim"
    os.environ["VISUAL"] = "nvim"
    os.environ["EDITOR"] = "nvim"
elif shutil.which("vim"):
    os.environ["VISUAL"] = "vim"
    os.environ["EDITOR"] = "vim"


if platform.system() == "Windows":
    # WSL's bash is too slow and not usable on windows
    if "bash" in __xonsh_completers__:
        completer remove bash

if "NVIM_LISTEN_ADDRESS" in ${...}:
    print("nvim: ", $NVIM_LISTEN_ADDRESS)

    if shutil.which("nvr"):
        editor = "nvr --remote-tab-wait-silent +'set bufhidden=delete'"
        aliases["nvim"] = editor
        os.environ["VISUAL"] = editor
        os.environ["EDITOR"] = editor
        os.environ["GIT_EDITOR"] = editor
        # $VISUAL = editor
        # $EDITOR = editor
        # $GIT_EDITOR = editor

    def _tab_open(args, stdin=None, stdout=None, stderr=None):
        if len(args) != 1:
            stderr.write("argument requires 1.\nUsage: tabopen <filename>\n")
            return 2
        with neovim.attach("socket", path=$NVIM_LISTEN_ADDRESS) as nvim:
            vim_cwd = Path(nvim.eval("getcwd()")).resolve()
            target = Path.cwd() / args[0]
            try:
                filename = vim_cwd.relative_to(target)
            except ValueError:
                filename = target
            nvim.command("tabnew " + str(filename))
            print("tab opened")
        return 0

    def _nvim_cd(args):
        new_pwd = Path(args[0]).resolve() if len(args) > 0 else Path.cwd()
        with neovim.attach("socket", path=$NVIM_LISTEN_ADDRESS) as nvim:
            nvim.command("cd " + str(new_pwd))
            print(nvim.eval("getcwd()"))

    aliases["tabopen"] = _tab_open
    aliases["tabnew"] = _tab_open
    aliases["nvim_cd"] = _nvim_cd

$EDITOR = os.environ["EDITOR"]
$VISUAL = os.environ["VISUAL"]


def _clear_var(current):
    def clear_var(args, stdin=None):
        currentSet = set(current)
        globalKeySet = set(globals().keys())
        diffKeys = globalKeySet - currentSet
        if len(diffKeys) < 1:
            print("nothing to do")
            return

        print("This variable has been deleted\n" + ", ".join(diffKeys))
        confirm = input("Are you sure?")
        if confirm[0].lower() == "y":
            import gc
            for key in diffKeys:
                del globals()[key]
            gc.collect()
            print("complete")

    return clear_var


# https://xon.sh/events.html?highlight=on_ptk_create
@events.on_ptk_create
def custom_keybindings(bindings, **kw):
    from prompt_toolkit.keys import Keys

    handler = bindings.add

    @handler(Keys.ControlV)
    def edit_in_editor(event):
        # https://python-prompt-toolkit.readthedocs.io/en/stable/pages/advanced_topics/key_bindings.html
        # https://github.com/jonathanslenders/python-prompt-toolkit/blob/b7ab3ba67df2e7dbf63463fb98f817878dfd256a/prompt_toolkit/key_binding/key_processor.py#L412
        # https://github.com/jonathanslenders/python-prompt-toolkit/blob/7ed428599bda5f62ed7534ee469b97f2b3e8510f/prompt_toolkit/buffer.py#L1352
        # このあたりみて再実装？
        event.current_buffer.tempfile_suffix = '.xsh'
        # nvrに設定されているなら横分割
        event.current_buffer.open_in_editor(event.cli)

# it should be bottom of this script
if "clear_var" not in aliases:
    aliases["clear_var"] = _clear_var(dir())
