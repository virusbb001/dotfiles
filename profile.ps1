Set-StrictMode -Version Latest

function list_neovim {
  [System.IO.Directory]::GetFiles("\\.\\pipe\\") | ? { $_.Contains("nvim") }
}

function fix_tmpdir {
   list_neovim | % {
     Write-Host "processing $_"
     $dir = Split-Path (nvr --servername $_ --remote-expr 'tempname()') -Parent
     Write-Host "`tprogressing ${dir}"
     if (!(Test-Path -Path $dir)) {
       New-Item -ItemType Directory -Path $dir
       Write-Host "`tCreated ${dir}"
     }
   }
}

if (Get-Command -ErrorAction SilentlyContinue fnm) {
  fnm env --use-on-cd --shell powershell | Out-String | Invoke-Expression
}

if (Get-Command -ErrorAction SilentlyContinue corepack) {
  function yarn { corepack yarn $args }
  function yarnpkg { corepack yarnpkg $args }
  function pnpm { corepack pnpm $args }
  function pnpx { corepack pnpx $args }
  function npm { corepack npm $args }
  function npx { corepack npx $args }
}
