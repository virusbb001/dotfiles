# Personal Dotfiles Context

このプロジェクトは、Zsh、Tmux、Neovimを中心とした開発環境の設定ファイル群（dotfiles）です。Nixを使用した環境構築をサポートしており、ポータビリティとカスタマイズ性を両立しています。

## プロジェクト概要

- **環境管理**: Nix, Home-Manager, およびカスタムシェルスクリプト (`installer.sh`)。
- **シェル**: Zsh (viキーバインド、カスタムプロンプト、`vcs_info` によるGitステータス表示)。
- **エディタ**: Neovim/Vim。`dpp.vim` をプラグインマネージャーとして使用し、`denops.vim` (Deno) ベースのプラグイン（ddc, ddu, skkeleton等）を多用しています。
- **マルチプレクサ**: Tmux (プレフィックスキー: `C-t`、viライクなペイン操作)。

## 主要なディレクトリ構造

- `home/`: `$HOME` 直下に配置される設定ファイル群 (`.zshrc`, `.tmux.conf`, `.vimrc` 等)。
- `vim/`: Neovim/Vimの詳細設定。
    - `rc/`: `dpp.vim` の設定 (`dpp_config.ts`) やLSP、プラグインの定義。
    - `lua/`: Neovim固有のLua設定。
    - `denops/`: Denopsプラグインの自作コード。
- `nix/`: Home-Manager 用の Nix 設定ファイル。
- `config/`: `XDG_CONFIG_HOME` に相当する設定ファイル（Neovimの `init.vim` 等）。
- `shell/`: 補助的なシェルスクリプト。

## 構築・実行手順

### 初回セットアップ
Nixがインストールされている環境では、以下のコマンドでセットアップを行います。

```sh
git clone https://github.com/virusbb001/dotfiles.git dotfiles
cd dotfiles
git submodule init
git submodule update
nix develop --command ./installer.sh
```

### インストーラーの動作 (`installer.sh`)
- `home/` 内のファイルを `$HOME` にコピー/インストールします。
- `.bashrc` に `XDG_CONFIG_DIRS` を追加します。
- `gitconfig` をグローバル設定にインクルードします。
- Nixが利用可能な場合、Home-Manager の設定ファイルをテンプレートから生成します。

## 開発・カスタマイズの慣習

- **Neovim設定**:
    - 設定の大部分は TypeScript (`vim/rc/*.ts`) で記述され、Deno によって実行されます。
    - プラグインの追加は `vim/rc/dpp/` 内の各ファイル (`lazy.ts`, `lsp_plugins.ts` 等) で行います。
    - `dpp.vim` のキャッシュ更新が必要な場合は、Vim内で `dpp#make_state()` を実行します。
- **シェル設定**:
    - `zshrc` は `zsh/` ディレクトリ内のスクリプトを読み込みます。
- **依存関係**:
    - `flake.nix` で開発シェルに必要なツール（`lua-language-server` 等）が定義されています。
