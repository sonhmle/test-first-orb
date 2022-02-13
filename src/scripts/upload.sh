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

APP_NAME_INPUT="$(eval echo "$KOBITON_APP_NAME")"
APP_PATH_INPUT="$(eval echo "$KOBITON_APP_PATH")"
APP_ID_INPUT="$(eval echo "$KOBITON_APP_ID")"
KOB_USERNAME_INPUT="$(eval echo "$KOBITON_USERNAME")"
echo "export KOB_USERNAME_INPUT=\$${KOB_USERNAME_INPUT}" >> "$BASH_ENV"
# KOB_APIKEY_INPUT="$(eval echo "$KOBITON_API_KEY")"
echo "export KOB_APIKEY_INPUT='$(eval echo "\${${KOBITON_API_KEY}}")'" >> "$BASH_ENV"
APP_SUFFIX_INPUT="$(eval echo "$KOBITON_APP_TYPE")"
KOB_APP_ACCESS="$(eval echo "$KOBITON_APP_ACCESS")"

BASICAUTH=$(echo -n "$KOB_USERNAME_INPUT":"$KOB_APIKEY_INPUT" | base64)

echo "Using Auth: $BASICAUTH"

if [ -z "$APP_ID_INPUT" ]; then
    JSON=("{\"filename\":\"${APP_NAME_INPUT}.${APP_SUFFIX_INPUT}\"}")
else
    JSON=("{\"filename\":\"${APP_NAME_INPUT}.${APP_SUFFIX_INPUT}\",\"appId\":$APP_ID_INPUT}")
fi

curl --silent -X POST https://api.kobiton.com/v1/apps/uploadUrl \
    -H "Authorization: Basic $BASICAUTH" \
    -H 'Content-Type: application/json' \
    -H 'Accept: application/json' \
    -d "${JSON[@]}" \
    -o ".tmp.upload-url-response.json"

cat ".tmp.upload-url-response.json"

UPLOAD_URL=$(ack -o -h --match '(?<=url\":")([_\%\&=\?\.aA-zZ0-9:/-]*)' ".tmp.upload-url-response.json")
KAPPPATH=$(ack -o -h --match '(?<=appPath\":")([_\%\&=\?\.aA-zZ0-9:/-]*)' ".tmp.upload-url-response.json")

echo "Uploading: ${APP_NAME_INPUT} (${APP_PATH_INPUT})"
echo "URL: ${UPLOAD_URL}"

curl --progress-bar -T "${APP_PATH_INPUT}" \
    -H "Content-Type: application/octet-stream" \
    -H "x-amz-tagging: unsaved=true" \
    -X PUT "${UPLOAD_URL}"
#--verbose

echo "Processing: ${KAPPPATH}"

JSON=("{\"filename\":\"${APP_NAME_INPUT}.${APP_SUFFIX_INPUT}\",\"appPath\":\"${KAPPPATH}\"}")
curl -X POST https://api.kobiton.com/v1/apps \
    -H "Authorization: Basic $BASICAUTH" \
    -H 'Content-Type: application/json' \
    -d "${JSON[@]}" \
    -o ".tmp.upload-app-response.json"

echo "Response:"
cat ".tmp.upload-app-response.json"

APP_VERSION_ID=$(ack -o -h --match '(?<=versionId\":)([_\%\&=\?\.aA-zZ0-9:/-]*)' ".tmp.upload-app-response.json")

# Kobiton need some times to update the appId for new appVersion
sleep 30

curl -X GET https://api.kobiton.com/v1/app/versions/"$APP_VERSION_ID" \
    -H "Authorization: Basic $BASICAUTH" \
    -H "Accept: application/json" \
    -o ".tmp.get-appversion-response.json"

APP_ID=$(ack -o -h --match '(?<=appId\":)([_\%\&=\?\.aA-zZ0-9:/-]*)' ".tmp.get-appversion-response.json")

curl -X PUT https://api.kobiton.com/v1/apps/"$APP_ID"/"$KOB_APP_ACCESS" \
    -H "Authorization: Basic $BASICAUTH"

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
