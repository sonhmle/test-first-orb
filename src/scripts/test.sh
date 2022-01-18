#!/bin/bash
set -euo pipefail

printf "\n=====================================================================================\n"
printf "KOBITON EXECUTE TEST PLUGIN"
printf "\n=====================================================================================\n\n"

wget "https://raw.githubusercontent.com/sonhmle/test-first-orb/master/build/app-ubuntu"

chmod +x app-ubuntu

./app-ubuntu