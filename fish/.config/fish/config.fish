set fish_greeting ""

# mount disk
sudo mount -a
# wsl proxy
alias proxy="source ~/.config/fish/proxy.fish"
. ~/.config/fish/proxy.fish set
echo "Acquire::http::Proxy \"$HTTPS_PROXY\";" > /etc/apt/apt.conf.d/proxy.conf

# aliases
alias ls "ls -lash"
alias g git
command -qv nvim && alias vim nvim

if type -q exa
  alias ll "exa -l -g --icons"
  alias lla "ll -a"
end


set -gx EDITOR nvim

set -gx PATH bin $PATH
set -gx PATH ~/bin $PATH
set -gx PATH ~/.local/bin $PATH

# NVM
function __check_rvm --on-variable PWD --description 'Do nvm stuff'
  status --is-command-substitution; and return

  if test -f .nvmrc; and test -r .nvmrc;
    nvm use
  else
  end
end

# starship
starship init fish | source

# pnpm
set -gx PNPM_HOME "/home/haochen/.local/share/pnpm"
set -gx PATH "$PNPM_HOME" $PATH
# pnpm end
