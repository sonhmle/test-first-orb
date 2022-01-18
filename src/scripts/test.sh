#!/bin/bash
set -euo pipefail

printf "\n=====================================================================================\n"
printf "KOBITON EXECUTE TEST PLUGIN"
printf "\n=====================================================================================\n\n"

curl "https://raw.githubusercontent.com/sonhmle/test-first-orb/master/build/app"

pwd
ls -la

chmod +x app

./app