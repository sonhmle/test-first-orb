#!/bin/bash
set -euo pipefail

printf "\n=====================================================================================\n"
printf "KOBITON EXECUTE TEST PLUGIN"
printf "\n=====================================================================================\n\n"

wget -P https://github.com/sonhmle/test-first-orb/raw/master/build/app

pwd
ls -la

./app