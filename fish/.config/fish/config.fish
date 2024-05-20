set fish_greeting ""

fish_vi_key_bindings

# aliases
alias ls "ls -lash"
alias g git
command -q nvim && alias vim nvim

if type -q exa
  alias ll "exa -l -g --icons"
  alias lla "ll -a"
end

set -gx TERM xterm-256color
set -gx EDITOR nvim
set -gx JAVA_HOME ( /usr/libexec/java_home -v11 )
fish_add_path /opt/homebrew/bin
fish_add_path /opt/homebrew/opt/openjdk@11/bin

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

fzf --fish | source

