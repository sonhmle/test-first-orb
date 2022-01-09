Greet() {
    echo Hello "${<<parameters.to>>}" and "$<<parameters.and>>" of "$<<parameters.branch>>"
    printf '\nbranch: %s \n' "$CIRCLE_BRANCH"
}

Greet
