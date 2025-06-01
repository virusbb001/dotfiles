return {
  settings = {
    ["rust-analyzer"] = {
      check = {
        command = "clippy"
      },
      procMacro = {
        enable = true,
      },
      cargo = {
        features = "all",
      }
    }
  }
}
