Set-StrictMode -Version Latest

function sudo {
 <#
 $file, [string]$arguments = $args;

 if (!$file) {
  Write-Host "sudo [command] [args]"
  return
 }
 
 $psi = New-Object System.Diagnostics.ProcessStartInfo $file;
 $psi.Arguments = $arguments;
 $psi.Verb = "runas";
 $psi.WorkingDirectory = Get-Location;
 [System.Diagnostics.Process]::Start($psi);
 #>
 if ($args.Length -lt 1){
  Write-Host "sudo command"
  return
 }
 
 powershell -command "Start-Process -Verb runas $args"
}

function list_neovim {
  [System.IO.Directory]::GetFiles("\\.\\pipe\\") | ? { $_.Contains("nvim") }
}

function fix_tmpdir {
   list_neovim | % {
     $dir = Split-Path (nvr --servername $_ --remote-expr 'tempname()') -Parent
     write-Host "progressing ${dir}"
     if (!(Test-Path -Path $dir)) {
       New-Item -ItemType Directory -Path $dir
       Write-Host "Created ${dir}"
     }
   }
}
