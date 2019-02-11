# vim: set fileencoding=utf-8 :

import importlib
import shutil
import os
import platform
from pathlib import Path
from xonsh.lazyasd import LazyObject
import argparse
import xonsh

xontrib load coreutils vox vox_tabcomplete readable-traceback jedi docker_tabcomplete

# Config

# show error trace
$XONSH_SHOW_TRACEBACK = True

$IGNOREEOF = True
$INDENT = " " * 4
$AUTO_PUSHD = True
$PUSHD_MINUS = True # todo: check
$HISTCONTROL = {"ignoredups"}
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
# use to @B`file{1,2,3}`
if importlib.util.find_spec("braceexpand") is not None:
    from braceexpand import braceexpand
    def B(s):
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

    def refreshenv():
        # this function is rewritten for xonsh of chocolatey's refreshenv
        # original source: https://github.com/chocolatey/choco/blob/8f4fe74f618df312f7773a218e76822a3337129b/src/chocolatey.resources/helpers/functions/Update-SessionEnvironment.ps1
        # original's license is Apache License Version 2.0: http://www.apache.org/licenses/LICENSE-2.0

        import winreg
        import xonsh

        # Registry Key ref:
        # https://docs.microsoft.com/ja-jp/dotnet/api/system.environmentvariabletarget?view=netframework-4.8#System_EnvironmentVariableTarget_Machine
        sys_env_dict ={}
        usr_env_dict = {}
        env_dict = {}
        add_to_converter = set((
            xonsh.tools.str_to_env_path,
            xonsh.tools.pathsep_to_upper_seq
        ))

        env = xonsh.environ.Env(**__xonsh__.env)

        username = env.get("USERNAME")
        architecture = env.get("PROCESSOR_ARCHITECTURE")
        def expand_value(value, regtype):
            if regtype == winreg.REG_EXPAND_SZ:
                return winreg.ExpandEnvironmentStrings(value)
            if regtype == winreg.REG_SZ:
                assert type(value) == str, "wrong Registry type"
                return value
            print("Unknown type:",regtype)
            raise NotImplementedError

        with winreg.OpenKeyEx(winreg.HKEY_LOCAL_MACHINE, r'System\CurrentControlSet\Control\Session Manager\Environment') as key:
            for i in range(winreg.QueryInfoKey(key)[1]):
                value = winreg.EnumValue(key, i)
                name = "PATH" if value[0].upper() == "PATH" else value[0]
                env[name] = expand_value(value[1], value[2])

        with winreg.OpenKeyEx(winreg.HKEY_CURRENT_USER, r'Environment') as key:
            for i in range(winreg.QueryInfoKey(key)[1]):
                reg_value = winreg.EnumValue(key, i)
                name = "PATH" if reg_value[0].upper() == "PATH" else reg_value[0]
                convert = env.get_ensurer(name).convert
                value = expand_value(reg_value[1], reg_value[2])
                if convert in add_to_converter:
                    env[name] += convert(value)
                else:
                    env[name] = value

        if username is not None:
            env["USERNAME"] = username
        if architecture is not None:
            env["PROCESSOR_ARCHITECTURE"] = architecture
        missing_path = set(__xonsh__.env["PATH"]) - set(env["PATH"])
        for p in missing_path:
            env["PATH"].add(p)

        # get diff
        old_env_exists = set(__xonsh__.env.keys()) 
        new_env_exists = set(env.keys())
        print("removed: ", ", ".join(old_env_exists - new_env_exists ))
        print("added: ", ", ".join(new_env_exists - old_env_exists))
        changed_env = set()
        for i in (new_env_exists & old_env_exists):
            if __xonsh__.env[i] != env[i]:
                changed_env.add(i)
        if len(changed_env) > 0:
            print("changed:", ", ".join(changed_env))

        # __xonsh__.env.update(env)
        return env


    def sys_env():
        import winreg
        import xonsh

        env_dict = {}

        with winreg.OpenKeyEx(winreg.HKEY_LOCAL_MACHINE, r'System\CurrentControlSet\Control\Session Manager\Environment') as key:
            for i in range(winreg.QueryInfoKey(key)[1]):
                value = winreg.EnumValue(key, i)
                name = "PATH" if value[0].upper() == "PATH" else value[0]
                env_dict[name] = value[1]

        return env_dict


    def usr_env():
        import winreg
        import xonsh

        env_dict = {}

        with winreg.OpenKeyEx(winreg.HKEY_CURRENT_USER, r'Environment') as key:
            for i in range(winreg.QueryInfoKey(key)[1]):
                value = winreg.EnumValue(key, i)
                name = "PATH" if value[0].upper() == "PATH" else value[0]
                env_dict[name] = value[1]

        return env_dict

def checkhealth():
    def print_error_msg(message: str):
        # TODO print red color
        print(message)

    if (importlib.util.find_spec("neovim") or importlib.util.find_spec("pynvim")) is None:
        print_error_msg("neovim/pynvim module not found")

    if importlib.util.find_spec("nvr") is None:
        print_error_msg("nvr command is missing")


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
            editor = "nvr --remote-tab-wait-silent '+set bufhidden=delete'"
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

        def _fix_tmpdir(args):
            tempdir = Path(pynvim.eval("tempname()")).parent
            tempdir.mkdir(exist_ok=True)
            print(f"missing {str(tempdir)} is fixed.")

        aliases[":tabnew"] = _tab_open
        aliases[":nvim_cd"] = _nvim_cd
        aliases[":fix_tmpdir"] = _fix_tmpdir
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


def show_ast(cmd):
    xonsh.ast.pprint_ast(__xonsh__.execer.parse(cmd, ctx=__xonsh_ctx__))


# https://xon.sh/events.html?highlight=on_ptk_create
@events.on_ptk_create
def custom_keybindings(prompter, bindings, **kw):
    from prompt_toolkit.keys import Keys

    handler = bindings.add

    @handler(Keys.ControlV)
    def edit_in_editor(event):
        # https://python-prompt-toolkit.readthedocs.io/en/stable/pages/advanced_topics/key_bindings.html
        visual_backup = os.environ.get("VISUAL")
        os.environ["VISUAL"] = "nvr -cc 10split --remote-wait '+set bufhidden=delete fileformat=unix'"
        event.current_buffer.tempfile_suffix = '.xsh'
        def reset_visual(_):
            os.environ["VISUAL"] = visual_backup

        future = event.current_buffer.open_in_editor(event.cli)
        future.add_done_callback(reset_visual)

    prompter.app.timeoutlen = 0.05
    prompter.app.ttimeoutlen = 0.01


    @handler(Keys.Escape)
    def leave_from_terminal_mode(event):
        if "pynvim" not in globals():
            # Nothing to do
            return
        globals()["pynvim"].input(r"<C-\><C-n>")


# it should be bottom of this script
if "clear_var" not in aliases:
    aliases["clear_var"] = _clear_var(dir())
