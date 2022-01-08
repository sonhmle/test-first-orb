Greet() {
    echo "Hello ${PARAM_TO:-} and ${PARAM_AND:-} for ${TO_NAME} of ${PARAM_BRANCH:-}"
}

# Will not run if sourced for bats-core tests.
# View src/tests for more information.
# ORB_TEST_ENV="bats-core"
# if [ "${0#*$ORB_TEST_ENV}" == "$0" ]; then
Greet
# fi
