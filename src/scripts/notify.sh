# Greet() {
#     echo "Hello ${<<parameters.to>>}" and "$<<parameters.and>>" of "$<<parameters.branch>>"
#     printf '\nbranch: %s \n' "$CIRCLE_BRANCH"
# }

CheckEnvVars() {
    if [ -z "${SLACK_PARAM_CHANNEL:-}" ]; then
       echo "No channel was provided. Enter value for SLACK_DEFAULT_CHANNEL env var, or channel parameter"
       exit 1
    fi
    echo "branch $IT_BRANCH of ${TO_PARAM}"
    printf 'Hello %s \n' "${SLACK_PARAM_CHANNEL}"
}

# Greet
CheckEnvVars
