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

function fix_tmpdir {
  $nvim_listen_address_backup = $null
  if (Test-Path Env:\NVIM_LISTEN_ADDRESS) {
    $nvim_listen_address_backup = $env:NVIM_LISTEN_ADDRESS
  }
   [System.IO.Directory]::GetFiles("\\.\\pipe\\") | ? { $_.Contains("nvim") } | % {
     $env:NVIM_LISTEN_ADDRESS = $_
     $dir = Split-Path (nvr --remote-expr 'tempname()') -Parent
     write-Host "progressing ${dir}"
     if (-not $dir) {
       New-Item -ItemType Directory -Path $dir
       Write-Host "Created ${dir}"
     }
   }
}
