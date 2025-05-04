# lint: https://github.com/PowerShell/PSScriptAnalyzer
Set-StrictMode -Version Latest

Write-Output $PSScriptRoot

# enviromnents

if (Test-Path env:HOME) {
  Write-Output "env:HOME has already set. skip"
} else {
  $home = "$env:USERPROFILE"
  [Environment]::SetEnvironmentVariable("HOME", "$home", [EnvironmentVariableTarget]::User)
  Set-Item env:HOME -value "$home"
}

if (Test-Path env:XDG_CONFIG_HOME) {
  Write-Output "env:XDG_CONFIG_HOME has already set. skip"
} else {
  $xdg_config_home = "$env:USERPROFILE\AppData\Local"
  [Environment]::SetEnvironmentVariable("XDG_CONFIG_HOME", "$xdg_config_home", [EnvironmentVariableTarget]::User)
  Set-Item env:XDG_CONFIG_HOME -value "$xdg_config_home"
}

# Copy Files

if (Test-Path "$home/_vimrc") {
  Write-Output "vimrc is already exists. skip"
}else{
  Copy-Item ($PSScriptRoot + "\home\.vimrc") "${home}\_vimrc"
}

if (Test-Path $profile) {
  Write-Output "$profile is already exists. skip"
}else{
  $LocalProfileSrc=@"
`$dotfiles_root = "$PSScriptRoot"
`$dotfiles_profile = "`$dotfiles_root\profile.ps1"
if ( Test-Path `$dotfiles_profile ) { . `$dotfiles_profile }
"@

  $LocalProfileSrc > $profile
}

xcopy D:\dotfiles\config $env:XDG_CONFIG_HOME /s /P
