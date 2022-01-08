Greet() {
    echo "$PARAM_BRANCH"
    echo "${PARAM_BRANCH:-}"
    echo "${PARAM_BRANCH}"
    echo "$PARAM_BRANCHES"
    echo "${PARAM_BRANCHES:-}"
    echo "${PARAM_BRANCHES}"
    echo "$PARAM_BRANCH_NEXT"
    echo "${PARAM_BRANCH_NEXT:-}"
    echo "${PARAM_BRANCH_NEXT}"
}

Greet
