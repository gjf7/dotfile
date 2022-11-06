/mnt/c/Windows/System32/wsl.exe -d "Ubuntu" sh -c "nohup sudo -b dockerd < /dev/null > ~/dockerlogs/dockerd.log 2>&1"
