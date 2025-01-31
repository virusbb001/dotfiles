* `neovim`
    * For development
* `neovim-stable`
    * To install neovim stable
    * should install `~/local`
    * `make CMAKE_EXTRA_FLAGS="-DCMAKE_INSTALL_PREFIX=$HOME/local" CMAKE_BUILD_TYPE=Release`
* `neovim-head`
    * To install neovim head
    * should install `~/local/neovim-head`
    * `make CMAKE_BUILD_TYPE=RelWithDebInfo CMAKE_EXTRA_FLAGS="-DCMAKE_INSTALL_PREFIX=$HOME/local/neovim-head"`
