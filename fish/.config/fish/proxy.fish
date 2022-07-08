#!/bin/fish
set hostip (cat /etc/resolv.conf | grep nameserver | awk '{print $2}')
set wslip (hostname -I | awk '{print $1}')
set port 7890

set PROXY_HTTP "http://$hostip:$port"

function set_proxy
    set -gx http_proxy $PROXY_HTTP
    set -gx HTTP_PROXY $PROXY_HTTP

    set -gx https_proxy $PROXY_HTTP
    set -gx HTTPS_PROXY $PROXY_HTTP
    git config --global http.proxy "$PROXY_HTTP"
    git config --global https.proxy "$PROXY_HTTP"
    if type -q npm
      npm config set proxy $PROXY_HTTP
      npm config set https-proxy $PROXY_HTTP
    else
    end
end

function unset_proxy
    set --erase http_proxy
    set --erase HTTP_PROXY
    set --erase https_proxy
    set --erase HTTPS_PROXY
    git config --global --unset http.proxy
    git config --global --unset https.proxy
end

function test_proxy
    echo Host ip: $hostip
    echo WSL ip: $wslip
    echo Current proxy: $https_proxy
end

if test $argv[1] = set
  set_proxy
else if test $argv[1] = unset
  unset_proxy
else if test $argv[1] = status
  test_proxy
else
  echo Unsupported arguments
end


