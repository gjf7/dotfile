set fish_greeting ""

set -gx TERM xterm-256color

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
set -gx JAVA_HOME /usr/lib/jvm/java-11-openjdk-amd64/bin/java
set -gx PATH /usr/local/go/bin $PATH
set -gx PATH $JAVA_HOME/bin $PATH

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

# tabtab source for packages
# uninstall by removing these lines
[ -f ~/.config/tabtab/fish/__tabtab.fish ]; and . ~/.config/tabtab/fish/__tabtab.fish; or true
