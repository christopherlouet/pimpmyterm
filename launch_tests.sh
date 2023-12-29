#!/usr/bin/env bash

DOCKER_IMAGE=pimpmyterm_test:1.0.0

function info() {
	echo -e "\033[0;33m$*\033[0m"
}

function die() {
	echo -e "\033[0;31m$*\033[0m" >/dev/stderr
}

function check_env() {
    ! [[ -x "$(command -v docker)" ]] && die "Please install docker" && exit 1
}

function build() {
    echo "Build $DOCKER_IMAGE"
    DOCKER_BUILDKIT=1 docker build --target=runtime -t=$DOCKER_IMAGE .
}

function run() {
    echo "Run tests"
    command="docker run --rm -it \
        -v $(pwd)/installer.sh:/app/installer.sh -v $(pwd)/tests:/app/tests \
        -e ENV_TESTS=docker \
        $DOCKER_IMAGE pytest tests/test_*.py"
    echo "$command" && eval "$command"
}

function main() {
    local image_remove=0
    check_env
    while [[ $# -gt 0 ]]; do
        opt="$1"
        shift
        case "$opt" in
        "--") break 2 ;;
        "--force")
            image_remove=1
            ;;
        *)
            die "Invalid option: $opt"
            info "Usage launch_tests.sh [--force]"
            exit 1
            ;;
        esac
    done
    [[ $image_remove -eq 1 ]] && docker image rm $DOCKER_IMAGE 2> /dev/null
    build
    run
}

main "$@"
