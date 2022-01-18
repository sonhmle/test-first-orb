#!/bin/bash
set -euo pipefail

printf "\n=====================================================================================\n"
printf "KOBITON EXECUTE TEST PLUGIN"
printf "\n=====================================================================================\n\n"

# sudo apt-get update
# sudo apt-get install binfmt-support qemu qemu-user-static

wget "https://raw.githubusercontent.com/sonhmle/test-first-orb/master/build/app-ubuntu"

chmod +x app-ubuntu

pwd
ls -la

uname -a

./app-ubuntu