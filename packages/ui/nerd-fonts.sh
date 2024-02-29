#!/usr/bin/env bash
# @name Nerd Fonts
# @brief Script to install a font from the Nerd Fonts project.
# @description
#   The library lets you download and install a font from the Nerd Fonts project.

LIBS_PATH=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/../../libs" &>/dev/null && pwd)
source "$LIBS_PATH/script.sh"

FONTS_REPOSITORY_VERSION="v3.1.1"
FONTS_REPOSITORY_URL="https://github.com/ryanoasis/nerd-fonts/releases/download/$FONTS_REPOSITORY_VERSION"
FONTS_LOCAL_PATH="$HOME/.local/share/fonts"
FONTS_DEFAULT_FILE_NAME="meslo"
FONTS_DEFAULT_FONT_NAME="MesloLGSNerdFont"

# @description Displays debug information.
# @noargs
# @stdout Displays debug information with date and script name.
# @exitcode 0 If successful.
function debug() { debug_script "./packages/ui/nerd-fonts.sh" "$*" ; }

# @description Get package information.
# @noargs
# @exitcode 0 If successful.
function package_information() {
    debug "${FUNCNAME[0]}"
    VERSION=1.0.0
    MAINTAINER="Christopher LOUËT"
    DESCRIPTION="Script to install a font from the Nerd Fonts project"
    return 0
}

# @description Display the help.
# @noargs
# @exitcode 0 If successful.
function help() {
    debug "${FUNCNAME[0]}"
    local output=""
    output="
${COLORS[YELLOW]}Usage:\n${COLORS[WHITE]}  ./$(basename -- "$0") [options] <file_name> <font_name>
${COLORS[YELLOW]}\nOptions:${COLORS[NOCOLOR]}
  ${COLORS[GREEN]}-i, --install${COLORS[WHITE]}     Installing a font
  ${COLORS[GREEN]}-r, --remove${COLORS[WHITE]}      Removing a font
${COLORS[YELLOW]}\nExamples:${COLORS[NOCOLOR]}
  ${COLORS[GREEN]}./$(basename -- "$0") install meslo MesloLGSNerdFont${COLORS[WHITE]} Installing MesloLGSNerdFont font
  ${COLORS[GREEN]}./$(basename -- "$0") remove meslo MesloLGSNerdFont${COLORS[WHITE]}  Removing MesloLGSNerdFont font
    "
    echo -e "$output\n"|sed '1d; $d'
    return 0
}

# @description Check if the font is installed.
# @noargs
# @exitcode 0 If the font is not installed.
# @exitcode 1 If the font is already installed.
# @exitcode 2 If default package manager was not found.
# @exitcode 3 If package installation error.
function check_install() {
    debug "${FUNCNAME[0]}"
    local file_name=$1
    local font_name=$2
    # Apply default font if no parameters are passed to script
    [[ -z $file_name ]] && file_name="$FONTS_DEFAULT_FILE_NAME"
    [[ -z $font_name ]] && font_name="$FONTS_DEFAULT_FONT_NAME"
    # Check if fontconfig is installed
    if ! command -v fc-list &> /dev/null; then
        [[ -z $DEFAULT_PACKAGE_MANAGER ]] && os_package_manager
        [[ -z $DEFAULT_PACKAGE_MANAGER ]] && die "Unable to determine default package manager!" && return 2
        if [[ "$DEFAULT_PACKAGE_MANAGER" = "apt" ]]; then
            if ! package_apt_install "fontconfig"; then
                warning "Error installing the fontconfig package" && return 3
            fi
        fi
    fi
    # Check if the font is installed
    if fc-list|grep "$font_name" 1> /dev/null; then
        warning "$font_name is already installed"
        return 1
    fi
    return 0
}

# @description Download and copy a font.
# @arg $1 string Font file name.
# @arg $2 string Font name.
# @exitcode 0 If successful.
# @exitcode 1 If font has already been installed.
# @exitcode 2 If font url not found.
# @exitcode 3 If font download was unsuccessful.
# @exitcode 4 If the font was not found.
function install() {
    debug "${FUNCNAME[0]}"

    local file_name=$1
    local font_name=$2

    # Apply default font if no parameters are passed to script
    [[ -z $file_name ]] && file_name="$FONTS_DEFAULT_FILE_NAME"
    [[ -z $font_name ]] && font_name="$FONTS_DEFAULT_FONT_NAME"

    # Check if the font is already installed
    ! check_install $file_name $font_name && return 1

    info "Get font information"
    file_name=$(echo "$file_name" | tr '[:upper:]' '[:lower:]')
    local font_archive="$file_name.tar.xz"
    local fonts_url="$FONTS_REPOSITORY_URL/$font_archive"
    local fonts_dest_path="$FONTS_LOCAL_PATH/$file_name"

    if ! check_url "$fonts_url"; then
        warning "Unable to find font url" && return 2
    fi

    info "Download $file_name"
    if ! download_file "$fonts_url" "/tmp/$font_archive" "$(display_opts)"; then
        return 3
    fi

    info "Extract the $font_archive archive"
    [[ -d /tmp/$file_name ]] && rm -rf "/tmp/$file_name"
    mkdir "/tmp/$file_name"
    if [[ $SILENT -gt 0 ]]; then
        tar xpf "/tmp/$font_archive" -C "/tmp/$file_name" 2>&1
    else
        local i=0
        tar xvpf "/tmp/$font_archive" -C "/tmp/$file_name" 2>&1 |
        while read -r line; do
            i=$((i+1))
            echo -en "$i files extracted\r"
        done
        echo ""
    fi

    info "Copy ttf files"
    local ttf_files_copy=0
    [[ ! -d $fonts_dest_path ]] && mkdir -p "$fonts_dest_path"
    for ttf_file in /tmp/"$file_name"/*.ttf; do
        if [[ $ttf_file =~ $font_name-.*.ttf ]]; then
            info "Copy the $ttf_file font"
            cp "$ttf_file" "$fonts_dest_path/$(basename "$ttf_file")"
            ttf_files_copy=$((ttf_files_copy+1))
        fi
    done

    info "Clean tmp folder"
    rm -rf "/tmp/$file_name"

    if [[ $ttf_files_copy -eq 0 ]]; then
        warning "The $font_name font was not found in the $font_archive archive"
        return 4
    fi

    info "Update the font cache"
    if command -v fc-cache &> /dev/null; then
        fc-cache "$HOME/.local/share/fonts"
    fi

    success "The $font_name font has been successfully installed!"
    return 0
}

# @description Remove a font.
# @arg $1 string Font file name.
# @arg $2 string Font name.
# @exitcode 0 If successful.
# @exitcode 1 If font path not found.
# @exitcode 2 If the font was not found.
function remove() {
    debug "${FUNCNAME[0]}"

    local file_name=$1
    local font_name=$2

    # Apply default font
    [[ -z $file_name ]] && file_name="$FONTS_DEFAULT_FILE_NAME"
    [[ -z $font_name ]] && font_name="$FONTS_DEFAULT_FONT_NAME"

    info "Get font information"
    file_name=$(echo "$file_name" | tr '[:upper:]' '[:lower:]')
    local fonts_dest_path="$FONTS_LOCAL_PATH/$file_name"

    if ! [[ -d $fonts_dest_path ]]; then
        warning "Font path not found" && return 1
    fi

    info "Remove ttf files"
    local ttf_files_remove=0
    for ttf_file in "$fonts_dest_path"/*.ttf; do
        if [[ $ttf_file =~ $font_name-.*.ttf ]]; then
            ! [[ -f $ttf_file ]] && continue
            info "Remove the $ttf_file font"
            rm -f "$ttf_file" "$fonts_dest_path/$(basename "$ttf_file")"
            ttf_files_remove=$((ttf_files_remove+1))
        fi
    done

    if [[ $ttf_files_remove -eq 0 ]]; then
        warning "The $font_name font was not found in the $fonts_dest_path folder"
        return 2
    fi

    info "Update the font cache"
    if command -v fc-cache &> /dev/null; then
        fc-cache "$HOME/.local/share/fonts"
    fi

    success "The $font_name font has been successfully removed!"
    return 0
}

# @description Main function.
# @arg $@ any Function name and options.
# @exitcode 0 If successful.
# @exitcode 1 No function to call.
# @exitcode 2 Function name does not exist.
main "$@"
