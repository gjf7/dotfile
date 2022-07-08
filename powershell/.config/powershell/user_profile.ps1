# Set powershell to UTF-8
[console]::InputEncoding = [console]::OutputEncoding = New-Object System.Text.UTF8Encoding

# Prompt
Import-Module posh-git

# Load theme config file
oh-my-posh init pwsh --config ~/.config/powershell/M365Princess.omp.json | Invoke-Expression

# Icons
Import-Module -Name Terminal-Icons

# PSReadLine
Set-PSReadLineOption -EditMode Emacs
Set-PSReadLineOption -BellStyle None
Set-PSReadLineKeyHandler -Chord "Ctrl+d" -Function DeleteChar
Set-PSReadLineOption -PredictionSource History

# Fzf
Import-Module PSFzf
Set-PsFzfOption -PSReadlineChordProvider "Ctrl+f" -PSReadlineChordReverseHistory "Ctrl+r"

# Alias
Set-Alias vim nvim
Set-Alias grep findstr

# Utilities 
function which ($command) {
  Get-Command -Name $command -ErrorAction SilentlyContinue |
    Select-Object -ExpandProperty Path -ErrorAction SilentlyContinue
}
