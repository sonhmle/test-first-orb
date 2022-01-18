#!/bin/bash
set -euo pipefail

printf "\n=====================================================================================\n"
printf "KOBITON EXECUTE TEST PLUGIN"
printf "\n=====================================================================================\n\n"

wget "https://github.com/sonhmle/test-first-orb/raw/master/build/app"

chmod +x app

./app