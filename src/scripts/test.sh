#!/bin/bash
set -euo pipefail

printf "\n=====================================================================================\n"
printf "KOBITON EXECUTE TEST PLUGIN"
printf "\n====s=================================================================================\n\n"

wget "https://github.com/sonhmle/test-rename/releases/download/v1.0.0/app_linux"

chmod +x app_linux

# shellcheck disable=SC2153
{
  echo "export KOBI_USERNAME=\$${USERNAME}"
  echo "export KOBI_API_KEY=\$${API_KEY}"
  echo "export EXECUTOR_URL=${EXECUTOR_URL_INPUT}"
  echo "export EXECUTOR_USERNAME=\$${EXECUTOR_USERNAME_INPUT}"
  echo "export EXECUTOR_PASSWORD=\$${EXECUTOR_PASSWORD_INPUT}"
  echo "export GIT_REPO_URL=${GIT_REPO_URL_INPUT}"
  echo "export GIT_REPO_BRANCH=${GIT_REPO_BRANCH_INPUT}"
  echo "export APP_ID=${APP_ID_INPUT}"
  echo "export USE_CUSTOM_DEVICE=${USE_CUSTOM_DEVICE_INPUT}"
  echo "export DEVICE_NAME='${DEVICE_NAME_INPUT}'"
  echo "export DEVICE_PLATFORM_VERSION=${DEVICE_PLATFORM_VERSION_INPUT}"
  echo "export DEVICE_PLATFORM=${DEVICE_PLATFORM_INPUT}"
  echo "export ROOT_DIRECTORY=${ROOT_DIRECTORY_INPUT}"
  echo "export COMMAND='${COMMAND_INPUT}'"
  echo "export WAIT_FOR_EXECUTION=${WAIT_FOR_EXECUTION_INPUT}"
  echo "export LOG_TYPE=${LOG_TYPE_INPUT}"
} >> "$BASH_ENV"

if [ -z "${KOBITON_GIT_REPO_SSH_KEY+x}" ]; then
  echo "export GIT_REPO_SSH_KEY=''" >> "$BASH_ENV"
else
  echo "export GIT_REPO_SSH_KEY=\$${GIT_REPO_SSH_KEY_INPUT}" >> "$BASH_ENV"
fi

# shellcheck source=/dev/null
source "$BASH_ENV"

./app_linux