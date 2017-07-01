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
