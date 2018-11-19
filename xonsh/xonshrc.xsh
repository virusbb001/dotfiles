# vim: set fileencoding=utf-8 :

import importlib
import shutil
import os
import platform
from pathlib import Path
from xonsh.lazyasd import LazyObject
from prompt_toolkit.application.current import get_app
import argparse

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
if importlib.util.find_spec("braceexpand") is not None:
    from braceexpand import braceexpand
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
    if "bash" in __xonsh__.completers:
        completer remove bash

def raw_ansi_red(message: str):
    return "\033[38;5;1m" + message + "\033[39;49m"

if importlib.util.find_spec("neovim") or importlib.util.find_spec("pynvim") is None:
    print(raw_ansi_red("neovim/pynvim module not found"))

if importlib.util.find_spec("nvr") is None:
    print(raw_ansi_red("nvr command is missing"))


def enable_nvim():

    if ("NVIM_LISTEN_ADDRESS" in ${...}
            and (importlib.util.find_spec("neovim") is not None
                 or importlib.util.find_spec("pynvim") is not None)):
        def load_pynvim():
            if importlib.util.find_spec("pynvim") is not None:
                return importlib.import_module("pynvim")
            return importlib.import_module("neovim")

        neovim = load_pynvim()
        print("nvim: ", $NVIM_LISTEN_ADDRESS)

        if shutil.which("nvr"):
            editor = "nvr --remote-tab-wait-silent +'set bufhidden=delete'"
            aliases["nvim"] = editor
            os.environ["VISUAL"] = editor
            os.environ["EDITOR"] = editor
            os.environ["GIT_EDITOR"] = editor
            $GIT_EDITOR = os.environ["GIT_EDITOR"]

        def _set_nvim_object():
            # TODO: allow to tcp
            pynvim = neovim.attach("socket", path=$NVIM_LISTEN_ADDRESS)

            @events.on_exit
            def release_something():
                pynvim.close()

            return pynvim

        pynvim = LazyObject(_set_nvim_object, globals(), 'pynvim')

        def _tab_open(argv, stdin=None, stdout=None, stderr=None):
            parser = argparse.ArgumentParser(description="")
            parser.add_argument("file")
            parser.add_argument("-r", dest='read', action='store_true')
            args = parser.parse_args(argv)
            opts = []
            if args.read:
                opts.append(r"+set\ readonly")

            vim_cwd = Path(pynvim.eval("getcwd()")).resolve()
            target = Path.cwd() / args.file

            try:
                filename = vim_cwd.relative_to(target)
            except ValueError:
                filename = target

            pynvim.input(r"<C-\><C-n>")
            pynvim.command("tabnew "+ " ".join(opts) +" "+ str(filename))
            print("tab opened")
            return 0

        def _nvim_cd(args):
            new_pwd = Path(args[0]).resolve() if len(args) > 0 else Path.cwd()
            pynvim.command("cd " + str(new_pwd))
            print(pynvim.eval("getcwd()"))

        aliases[":tabnew"] = _tab_open
        aliases[":nvim_cd"] = _nvim_cd
    $EDITOR = os.environ["EDITOR"]
    $VISUAL = os.environ["VISUAL"]

enable_nvim()

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
        if confirm[0:1].lower() == "y":
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
        # TODO: nvrに設定されているなら横分割
        event.current_buffer.open_in_editor(event.cli)

    # TODO: change timeoutlen
    @handler(Keys.Escape)
    def leave_from_terminal_mode(event):
        if "pynvim" not in globals():
            # Nothing to do
            return
        globals()["pynvim"].input(r"<C-\><C-n>")


# it should be bottom of this script
if "clear_var" not in aliases:
    aliases["clear_var"] = _clear_var(dir())
