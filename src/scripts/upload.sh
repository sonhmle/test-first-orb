#!/bin/bash
set -ex

printf "\n=====================================================================================\n"
printf "KOBITON APP UPLOAD PLUGIN"
printf "\n=====================================================================================\n\n"

printf "Installing ack...\n"
sudo chmod 755 /usr/local/bin
sudo bash -c "curl -L https://beyondgrep.com/ack-v3.5.0 >/usr/local/bin/ack"
sudo chmod 755 /usr/local/bin/ack

printf "Finish downloading ack\n"

hash ack 2>/dev/null || {
    echo >&2 "ack required, but it's not installed."
    exit 1
}

pwd
ls -la

APP_NAME_INPUT=$KOBITON_APP_NAME
APP_PATH_INPUT=$KOBITON_APP_PATH
APP_ID_INPUT=$KOBITON_APP_ID
KOB_USERNAME_INPUT=$KOBITON_USERNAME
KOB_APIKEY_INPUT=$KOBITON_API_KEY
APP_SUFFIX_INPUT=$KOBITON_APP_TYPE
KOB_APP_ACCESS=$KOBITON_APP_ACCESS

BASICAUTH=$(echo -n "$KOB_USERNAME_INPUT":"$KOB_APIKEY_INPUT" | base64)

echo "Using Auth: $BASICAUTH"

if [ -z "$APP_ID_INPUT" ]; then
    JSON=("{\"filename\":\"${APP_NAME_INPUT}.${APP_SUFFIX_INPUT}\"}")
else
    JSON=("{\"filename\":\"${APP_NAME_INPUT}.${APP_SUFFIX_INPUT}\",\"appId\":$APP_ID_INPUT}")
fi

curl --silent -X POST https://api-test.kobiton.com/v1/apps/uploadUrl \
    -H "Authorization: Basic $BASICAUTH" \
    -H 'Content-Type: application/json' \
    -H 'Accept: application/json' \
    -d "${JSON[@]}" \
    -o ".tmp.upload-url-response.json"

UPLOAD_URL=$(ack -o --match '(?<=url\":")([_\%\&=\?\.aA-zZ0-9:/-]*)')
KAPPPATH=$(ack -o --match '(?<=appPath\":")([_\%\&=\?\.aA-zZ0-9:/-]*)')

echo "Uploading: ${APP_NAME_INPUT} (${APP_PATH_INPUT})"
echo "URL: ${UPLOAD_URL}"

curl --progress-bar -T "${APP_PATH_INPUT}" \
    -H "Content-Type: application/octet-stream" \
    -H "x-amz-tagging: unsaved=true" \
    -X PUT "${UPLOAD_URL}"
#--verbose

echo "Processing: ${KAPPPATH}"

JSON=("{\"filename\":\"${APP_NAME_INPUT}.${APP_SUFFIX_INPUT}\",\"appPath\":\"${KAPPPATH}\"}")
curl -X POST https://api-test.kobiton.com/v1/apps \
    -H "Authorization: Basic $BASICAUTH" \
    -H 'Content-Type: application/json' \
    -d "${JSON[@]}" \
    -o ".tmp.upload-app-response.json"

echo "Response:"
cat ".tmp.upload-app-response.json"

APP_VERSION_ID=$(ack -o --match '(?<=versionId\":)([_\%\&=\?\.aA-zZ0-9:/-]*)')

# Kobiton need some times to update the appId for new appVersion
sleep 30

curl -X GET https://api-test.kobiton.com/v1/app/versions/"$APP_VERSION_ID" \
    -H "Authorization: Basic $BASICAUTH" \
    -H "Accept: application/json" \
    -o ".tmp.get-appversion-response.json"

APP_ID=$(< ".tmp.get-appversion-response.json" ack -o --match '(?<=appId\":)([_\%\&=\?\.aA-zZ0-9:/-]*)')

curl -X PUT https://api-test.kobiton.com/v1/apps/"$APP_ID"/"$KOB_APP_ACCESS" \
    -H "Authorization: Basic $BASICAUTH"

pwd
ls -la

echo "Uploaded app to kobiton repo with appId: ${APP_ID} and versionId: ${APP_VERSION_ID}"
echo "Done"

# CheckEnvVars() {
#     if [ -z "${AND_NAME:-}" ]; then
#        echo "No AND_NAME env var set"
#        exit 1
#     fi
#     echo "branch $IT_BRANCH of ${TO_PARAM}"
#     printf 'Hello %s \n' "$SLACK_PARAM_CHANNEL"
#     printf '\nand name: %s \n' "$AND_NAME"
# }
