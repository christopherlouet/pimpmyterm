#!/usr/bin/env bash
# @name Utils
# @brief **utils.sh** is a useful toolbox for developing the bash application.
# @description
#   This toolbox enables you to perform the following actions:
#
#       * Generating the API documentation with the **shdoc** utility
#       * Generating a site from markdown files with **mkdocs**
#       * Run unit tests with **pytest**
#       * Linter the code with the **shellcheck** utility
#       * Install **poetry** if you need to update python dependencies

CURRENT_PATH="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &>/dev/null && pwd)"
LIBS_PATH="$CURRENT_PATH/libs"
PACKAGES_PATH="$CURRENT_PATH/packages"
DOC_PATH="$CURRENT_PATH/docs"
DOCKER_IMAGE="pimpmyterm:1.0.0"

# @description Check if docker is installed.
# @noargs
# @exitcode 0 If docker is installed.
# @exitcode 1 If docker is not installed.
function check_env_docker() {
    ! [[ -x "$(command -v docker)" ]] && die "Please install docker" && return 1
    return 0
}

# @description Building the utils docker image.
# @noargs
# @exitcode 0 If successful.
function docker_build() {
    info "Build $DOCKER_IMAGE"
    DOCKER_BUILDKIT=1 docker build --target=runtime -t="$DOCKER_IMAGE" . 2> /dev/null 1> /dev/null
    return 0
}

# @description Removing the utils docker image.
# @noargs
# @exitcode 0 If successful.
function docker_image_remove() {
    info "Remove $DOCKER_IMAGE"
    docker image rm "$DOCKER_IMAGE" 2> /dev/null
    return 0
}

# @description Execute a command in the docker container.
# @noargs
# @exitcode 0 If successful.
function docker_run() {
    local cmd_docker=""
    [[ -z $cmd_container ]] && cmd_container="bash"
    cmd_docker="docker run --rm -it \
        -e ENV=docker \
        -p 8000:8000 \
        -v $(pwd)/pimpmyterm.sh:/app/pimpmyterm.sh \
        -v $(pwd)/config.ini:/app/config.ini \
        -v $(pwd)/mkdocs.yml:/app/mkdocs.yml \
        -v $(pwd)/docs:/app/docs \
        -v $(pwd)/libs:/app/libs \
        -v $(pwd)/tests:/app/tests \
        -v $(pwd)/themes:/app/themes \
        -v $(pwd)/profiles:/app/profiles \
        $DOCKER_IMAGE $cmd_container"
    info "$cmd_docker" && eval "$cmd_docker"
    return 0
}

# @description Generate API documentation in markdown format.
# @noargs
# @exitcode 0 If successful.
function generate_doc() {

    info "Checking prerequisites"
    if ! command -v gawk &> /dev/null; then
        warning "Please install gawk to generate documentation"
        return 1
    fi

    info "Get the list of libraries"
    libraries=()
    for library_path in "$LIBS_PATH"/*; do
        ! [[ -f $library_path ]] && continue
        library_file_name=${library_path##*/}
        library="${library_file_name%.sh}"
        [[ -n $library ]] && libraries+=("$library_path")
    done
    info "Found libraries: ${#libraries[@]}"

    info "Get the list of packages"
    packages=()
    for package_folder_path in "$PACKAGES_PATH"/*; do
        for package_path in "$package_folder_path"/*; do
            ! [[ -f $package_path ]] && continue
            package_file_name=${package_path##*/}
            package="${package_file_name%.sh}"
            [[ -n $package ]] && packages+=("$package_path")
        done
    done
    info "Found packages: ${#packages[@]}"

    info "Generating the PimpMyTerm API documentation"
    ./bin/shdoc < "$CURRENT_PATH/pimpmyterm.sh" > "$DOC_PATH/pimpmyterm.md"

    info "Generating the Utils API documentation"
    ./bin/shdoc < "$CURRENT_PATH/utils.sh" > "$DOC_PATH/utils.md"

    info "Generate library API documentation"
    ! [[ -d "$DOC_PATH/libs" ]] && mkdir -p "$DOC_PATH/libs"
    for library_path in ${libraries[*]}; do
        library_file_name=${library_path##*/}
        library="${library_file_name%.sh}"
        info "Generating the $library library API documentation"
        ./bin/shdoc < "$library_path" > "$DOC_PATH/libs/$library.md"
    done

    info "Generate packages API documentation"
    ! [[ -d "$DOC_PATH/packages" ]] && mkdir -p "$DOC_PATH/packages"
    for package_path in ${packages[*]}; do
        package_file_name=${package_path##*/}
        package="${package_file_name%.sh}"
        package_dir_path=$(dirname "$package_path")
        package_dir=$(basename "$package_dir_path")
        ! [[ -d "$DOC_PATH/packages/$package_dir" ]] && mkdir -p "$DOC_PATH/packages/$package_dir"
        info "Generating the $package package API documentation"
        ./bin/shdoc < "$package_path" > "$DOC_PATH/packages/$package_dir/$package.md"
    done

    success "Documentation successfully generated!"
    return 0
}

# @description Start the mkdocs server to browse the API documentation in a browser.
# @noargs
# @exitcode 0 If successful.
# @exitcode 1 If the docker environment is not installed.
# @exitcode 2 If docker image deletion failed.
# @exitcode 3 If docker image building failed.
# @exitcode 4 If execution of the command in the docker container has failed.
function mkdocs_server_start() {
    info "Start the mkdocs server"
    local cmd_container="mkdocs serve -a 0.0.0.0:8000"
    ! check_env_docker && return 1
    if [[ $FORCE -gt 0 ]]; then
        ! docker_image_remove && return 2
    fi
    ! docker_build && return 3
    ! docker_run && return 4
    return 0
}

# @description Linter the application's bash code.
# @noargs
# @exitcode 0 If successful.
# @exitcode 1 If the docker environment is not installed.
# @exitcode 2 If docker image deletion failed.
# @exitcode 3 If docker image building failed.
# @exitcode 4 If execution of the command in the docker container has failed.
function lint_code() {
    info "Linting code"
    # Exclude certain types of warnings
    local cmd_container="bash -c \"shellcheck -x *.sh ; shellcheck -e SC2034,SC2294,SC1091 -x **/*.sh\""
    ! check_env_docker && return 1
    if [[ $FORCE -gt 0 ]]; then
        ! docker_image_remove && return 2
    fi
    ! docker_build && return 3
    ! docker_run && return 4
    return 0
}

# @description Run unit tests.
# @noargs
# @exitcode 0 If successful.
# @exitcode 1 If the docker environment is not installed.
# @exitcode 2 If docker image deletion failed.
# @exitcode 3 If docker image building failed.
# @exitcode 4 If execution of the command in the docker container has failed.
function run_tests() {
    info "Run unit tests"
    local cmd_container="pytest tests/test_*.py"
    ! check_env_docker && return 1
    if [[ $FORCE -gt 0 ]]; then
        ! docker_image_remove && return 2
    fi
    ! docker_build && return 3
    ! docker_run && return 4
    return 0
}

# @description Execute bash in the docker container.
# @noargs
# @exitcode 0 If successful.
# @exitcode 1 If the docker environment is not installed.
# @exitcode 2 If docker image deletion failed.
# @exitcode 3 If docker image building failed.
# @exitcode 4 If execution of the command in the docker container has failed.
function run_bash() {
    info "Execute bash in the container"
    ! check_env_docker && return 1
    if [[ $FORCE -gt 0 ]]; then
        ! docker_image_remove && return 2
    fi
    ! docker_build && return 3
    ! docker_run && return 4
    return 0
}

# @description Installing Poetry.
# @noargs
# @exitcode 0 If successful.
# @exitcode 1 If Poetry is already installed.
# @exitcode 2 If Python 3 is not installed.
# @exitcode 3 If Curl is not installed.
function poetry_install() {

    if command -v poetry &> /dev/null; then
        warning "Poetry is already installed"
        return 1
    fi

    info "Checking prerequisites"
    if ! command -v python3 &> /dev/null; then
        warning "Please install python 3"
        return 2
    fi
    if ! command -v curl &> /dev/null; then
        warning "Please install curl"
        return 3
    fi

    info "Installation of poetry"
    curl -sSL https://install.python-poetry.org | python3 -

    info "Adding poetry path"
    if ! echo "$PATH"|grep "$HOME/.local/bin"; then
        if [ -n "$BASH_VERSION" ]; then
            if [ -d "$HOME/.local/bin" ] && [ -f "$HOME/.bashrc" ]; then
                {
                    echo ""
                    echo "export PATH=\"$HOME/.local/bin:$PATH\""
                } >>"$HOME/.bashrc"
            fi
        fi
        info "Relaunch a terminal to execute poetry"
    fi

    return 0
}

# @description Display the help.
# @noargs
# @exitcode 0 If successful.
function help() {
    local output=""
    output="
${COLORS[YELLOW]}Usage:\n${COLORS[WHITE]}  $(basename "$0") [options]\n
${COLORS[YELLOW]}Options:${COLORS[NOCOLOR]}
  ${COLORS[GREEN]}-h, --help${COLORS[WHITE]}                Display help
  ${COLORS[GREEN]}-d, --doc${COLORS[WHITE]}                 Generate the api doc
  ${COLORS[GREEN]}-m, --mkdocs${COLORS[WHITE]}              Start the mkdocs server
  ${COLORS[GREEN]}-l, --linter${COLORS[WHITE]}              Code linting
  ${COLORS[GREEN]}-t, --test${COLORS[WHITE]}                Launch the unit tests
  ${COLORS[GREEN]}-f, --force${COLORS[WHITE]}               Remove docker image before launch the unit tests
  ${COLORS[GREEN]}-b, --bash${COLORS[WHITE]}                Execute bash in the container
  ${COLORS[GREEN]}-p, --poetry${COLORS[WHITE]}              Install poetry
    "
    echo -e "$output\n"|sed '1d; $d'
    return 0
}

# @description Execute tasks based on script parameters or user actions.
# @noargs
# @exitcode 0 If successful.
# @exitcode 1 If an error has been encountered displaying help.
# @exitcode 2 If an error was encountered in generating the documentation.
# @exitcode 3 If an error was encountered starting the mkdocs server.
# @exitcode 4 If an error was encountered while analyzing the code
# @exitcode 5 If an error has been encountered during execution of the unit tests.
# @exitcode 6 If an error was encountered running bash in the docker container.
# @exitcode 7 If an error was encountered installing Poetry.
function execute_tasks() {
    # Display help
    if [[ $HELP -gt 0 ]]; then
        ! help && return 1
        return 0
    fi
    # Generate the api doc
    if [[ $GENERATE_DOC -gt 0 ]]; then
        ! generate_doc && return 2
        return 0
    fi
    # Start the mkdocs server
    if [[ $MKDOCS -gt 0 ]]; then
        ! mkdocs_server_start && return 3
        return 0
    fi
    # Linting code
    if [[ $LINT -gt 0 ]]; then
        ! lint_code && return 4
        return 0
    fi
    # Launch the unit tests
    if [[ $UNIT_TESTS -gt 0 ]]; then
        ! run_tests && return 5
        return 0
    fi
    # Execute bash in the docker container
    if [[ $BASH -gt 0 ]]; then
        ! run_bash && return 6
        return 0
    fi
    # Installing poetry
    if [[ $POETRY -gt 0 ]]; then
        ! poetry_install && return 7
        return 0
    fi
    return 0
}

# @description Display menu.
# @noargs
# @exitcode 0 If successful.
function display_menu() {
    local badge_left="${BG_COLORS[NOCOLOR]}${COLORS[GREEN]}"
    local badge_right="${BG_COLORS[GREEN]}${COLORS[BLACK]}"
    local menu_messages=() menu_message_fields=() option="" message=""
    menu_messages+=("h|Display help")
    menu_messages+=("d|Generate api documentation")
    menu_messages+=("m|Start the mkdocs server")
    menu_messages+=("l|Linting code")
    menu_messages+=("t|Launch unit tests")
    menu_messages+=("b|Execute bash in the container")
    menu_messages+=("p|Install poetry")
    menu_messages+=("q|Quit")
    for menu_message in "${menu_messages[@]}"; do
        IFS=$"|" read -ra menu_message_fields <<< "$menu_message"; unset IFS
        option=${menu_message_fields[0]}
        message=${menu_message_fields[1]}
        printf "$badge_left %s $badge_right %-10s ${COLORS[NOCOLOR]}\n" "$option" "$message"
    done
    local answer=""
    HELP=0 GENERATE_DOC=0 MKDOCS=0 LINT=0 UNIT_TESTS=0 FORCE=0 BASH=0 POETRY=0
    confirm_message "Pick an option"
    # Read the answer
    case "$answer" in
        h) HELP=1 ;;
        d) GENERATE_DOC=1 ;;
        m) MKDOCS=1 ;;
        l) LINT=1 ;;
        t) UNIT_TESTS=1 ;;
        b) BASH=1 ;;
        p) POETRY=1 ;;
        q) info "Good bye!" && exit ;;
        *) die "Invalid option $answer" ; display_menu ;;
    esac
    # Execute the tasks and display menu
    execute_tasks
    display_menu
    return 0
}

# @description Check options passed as script parameters.
# @noargs
# @exitcode 0 If successful.
function check_opts() {
    while [[ $# -gt 0 ]]; do
        opt="$1"
        shift
        case "$opt" in
            -h|--help) HELP=1 ;;
            -d|--doc) GENERATE_DOC=1 ;;
            -m|--mkdocs) MKDOCS=1 ;;
            -l|--linter) LINT=1 ;;
            -t|--test) UNIT_TESTS=1 ;;
            -f|--force) FORCE=1 ;;
            -b|--bash) BASH=1 ;;
            -p|--poetry) POETRY=1 ;;
            *) HELP=1 ;;
        esac
    done
    return 0
}

# @description Main function.
# @noargs
# @exitcode 0 If successful.
# @exitcode 1 If the options check failed.
# @exitcode 2 If menu display has failed.
# @exitcode 3 If task execution failed.
function main() {
    # Common functions
    source "$LIBS_PATH/common.sh"
    # Global variables
    local HELP=0 GENERATE_DOC=0 MKDOCS=0 LINT=0 UNIT_TESTS=0 FORCE=0 BASH=0 POETRY=0
    # Check options
    ! check_opts "$@" && return 1
    # Display menu if no options passed to script
    if [[ $((HELP+GENERATE_DOC+MKDOCS+LINT+UNIT_TESTS+BASH+POETRY)) -eq 0 ]]; then
        ! display_menu && return 2
        return 0
    fi
    ! execute_tasks && return 3
    return 0
}

main "$@"
