# vim: set filetype=python :

import shutil
import neovim
import os
import platform
from pathlib import Path

xontrib load vox vox_tabcomplete coreutils

$IGNOREEOF = True
$INDENT = " " * 4
$AUTO_PUSHD = True
$HISTCONTROL = set("ignoredups")
$INTENSIFY_COLORS_ON_WIN = False
$AUTO_CD = True
$PROMPT = "{env_name:{}}{BOLD_GREEN}{user}@{hostname}{BOLD_BLUE} {short_cwd}{branch_color}{curr_branch: {}}{NO_COLOR} {BOLD_BLUE}{prompt_end}> {NO_COLOR}"

# inputs
$UPDATE_COMPLETIONS_ON_KEYPRESS = False
$CASE_SENSITIVE_COMPLETIONS = False
$COMPLETIONS_CONFIRM = True
$VI_MODE = False
$XONSH_AUTOPAIR = True

# show error trace
$XONSH_SHOW_TRACEBACK = True

if shutil.which("nvim"):
    aliases["vim"] = "nvim"
    $VISUAL = "nvim"
    $EDITOR = "nvim"
elif shutil.which("vim"):
    $VISUAL = "vim"
    $EDITOR = "vim"

if platform.system() == "Windows":
    # WSL's bash is too slow and not usable on windows
    if "bash" in __xonsh_completers__:
        completer remove bash

if "NVIM_LISTEN_ADDRESS" in ${...}:
    print("nvim: ", $NVIM_LISTEN_ADDRESS)

    if shutil.which("nvr"):
        editor = "nvr --remote-tab-wait-silent +'set bufhidden=delete'"
        aliases["nvim"] = editor
        $EDITOR = editor

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

print("loaded xonshrc")
