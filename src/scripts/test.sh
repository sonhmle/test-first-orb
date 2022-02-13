#!/bin/bash
set -euo pipefail

printf "\n=====================================================================================\n"
printf "KOBITON EXECUTE TEST PLUGIN"
printf "\n====s=================================================================================\n\n"

wget "https://github.com/sonhmle/test-first-orb/releases/download/v1.0.0/app_linux"

chmod +x app_linux

./app_linux