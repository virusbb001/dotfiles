Set-StrictMode -Version Latest

function list_neovim {
  [System.IO.Directory]::GetFiles("\\.\\pipe\\") | ? { $_.Contains("nvim") }
}

function fix_tmpdir {
   list_neovim | % {
     Write-Host "processing $_"
     $dir = Split-Path (nvr --servername $_ --remote-expr 'tempname()') -Parent
     write-Host "`tprogressing ${dir}"
     if (!(Test-Path -Path $dir)) {
       New-Item -ItemType Directory -Path $dir
       Write-Host "Created ${dir}"
     }
   }
}
