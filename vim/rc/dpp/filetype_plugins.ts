// import * as path from "jsr:@std/path";
import { type Plugin } from "jsr:@shougo/dpp-vim@~3.1.0/types"
import { addName, type RemotePlugin } from "./util.ts";
import { join } from "@std/path";

export default function getFileTypePlugins(): Plugin[] {
  // plugins that doesn't have plugin/*
  const syntaxPlugins: RemotePlugin[] = [{
    repo: "dannywillems/vim-icalendar"
  }, {
    repo: "chakrit/upstart.vim"
  }];

  const plugins: RemotePlugin[] = [{
    "repo": "mattn/emmet-vim",
    "on_ft": [
      "html",
      "css",
      "htmldjango",
      "vue",
      "pug",
      "eruby",
      "typescriptreact",
      "xml"
    ],
    hooks_file: join(import.meta.dirname!, "hooks/emmet.lua"),
  },
    {
      "repo": "nikvdp/ejs-syntax",
      "on_ft": [
        "ejs"
      ]
    },
    {
      "repo": "kchmck/vim-coffee-script",
      "on_ft": [
        "coffee"
      ]
    },
    {
      "repo": "Vimjas/vim-python-pep8-indent",
      "on_ft": [
        "python",
        "xonsh"
      ]
    },
    {
      "repo": "jmcantrell/vim-virtualenv",
      "on_ft": "python",
      "hook_add": "let g:virtualenv_auto_activate = 1\n"
    },
    {
      "repo": "fatih/vim-go",
      "on_ft": "go"
    },
    {
      "repo": "vim-ruby/vim-ruby",
      "on_ft": [
        "ruby"
      ]
    },
    {
      "on_ft": [
        "ruby",
        "eruby"
      ],
      "repo": "tpope/vim-rails"
    },
    {
      "on_ft": [
        "ruby"
      ],
      "repo": "tpope/vim-bundler"
    },
    {
      "repo": "kovisoft/slimv",
      "on_ft": [
        "lisp",
        "scheme"
      ],
      "hook_add": "\" let g:slimv_swank_cmd = \"!xterm -e \\\"ros -e '(ql:quickload :swank) (swank:create-server)' wait \\\"&\"\n\" let g:slimv_lisp = 'ros run'\n\" let g:slimv_impl = 'sbcl'\n"
  },
      {
        "repo": "niklasl/vim-rdf"
      },
      {
      "if": "executable(\"swift\")",
      "repo": "keith/swift.vim",
      "on_ft": [
        "swift"
      ]
    },
    {
      "if": "has(\"nvim\") && executable(\"swift\")",
      "repo": "mitsuse/autocomplete-swift"
    },
    {
      "repo": "vim-scripts/nginx.vim",
      "on_ft": [
        "nginx"
      ]
    },
    {
      "repo": "kylef/apiblueprint.vim",
      "on_ft": [
        "apiblueprint"
      ],
      "hook_add": "autocmd FileType apiblueprint setlocal tabstop=4 softtabstop=4 shiftwidth=4\n"
    },
    {
      "repo": "chaimleib/vim-renpy",
      "on_ft": [
        "renpy"
      ]
    },
    {
      "on_ft": [
        "json"
      ],
      "repo": "Quramy/vison"
    },
    {
      "on_ft": [
        "haskell"
      ],
      "repo": "neovimhaskell/haskell-vim"
    },
    {
      "on_ft": [
        "haskell"
      ],
      "repo": "eagletmt/neco-ghc"
    },
    {
      "repo": "Shougo/neco-vim",
      "on_ft": [
        "vim"
      ]
    },
    {
      "repo": "PProvost/vim-ps1",
      "on_ft": [
        "ps1"
      ]
    },
    {
      "repo": "elixir-editors/vim-elixir",
      "on_ft": [
        "elixir"
      ],
      "if": "executable(\"elixir\")"
    },
    {
      "repo": "yasuhiroki/github-actions-yaml.vim",
      "on_ft": [
        "yaml.gha"
      ]
    },
    {
      "repo": "iloginow/vim-stylus",
      "on_ft": "stylus"
    },
    {
      "repo": "rust-lang/rust.vim",
      "on_ft": "rust"
    },
    {
      "repo": "Julian/lean.nvim",
      "on_ft": "lean",
      "lua_source": `require("lean").setup({ mappings = true })`
    }
  ];

  return plugins.concat(syntaxPlugins).map(addName);
}
