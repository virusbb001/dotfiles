Set-StrictMode -Version Latest

Write-Host $PSScriptRoot

if (!(Test-Path "${home}/_vimrc")) {
  Copy-Item ($PSScriptRoot + "\dot_vimrc") "${home}\_vimrc"
}else{
  Write-Host "vimrc is already exists. skip"
}

if (!(Test-Path $profile)) {
  Copy-Item ($PSScriptRoot + "\profile.ps1") $profile
}else{
  Write-Host "$profile is already exists. skip"
}
