# Greet() {
#     echo "Hello ${<<parameters.to>>}" and "$<<parameters.and>>" of "$<<parameters.branch>>"
#     printf '\nbranch: %s \n' "$CIRCLE_BRANCH"
# }

CheckEnvVars() {
    if [ -z "${AND_NAME:-}" ]; then
       echo "No AND_NAME env var set"
       exit 1
    fi
    echo "branch $IT_BRANCH of ${TO_PARAM}"
    printf 'Hello %s \n' "$SLACK_PARAM_CHANNEL"
}

# Greet
CheckEnvVars
