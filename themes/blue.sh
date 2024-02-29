#!/usr/bin/env bash

# MESSAGE COLORS ######################################################################################################

BADGE_PROMPT_LEFT="${BG_COLORS[NOCOLOR]}${COLORS[WHITE]} ● "
BADGE_PROMPT_RIGHT="${BG_COLORS[WHITE]}${COLORS[BLACK]}"
BADGE_PROMPT_ANSWER="${COLORS[NOCOLOR]}${COLORS[WHITE]}"
BADGE_PROMPT="${BADGE_PROMPT_LEFT}${BADGE_PROMPT_RIGHT}"

BADGE_INFO_LEFT="${BG_COLORS[NOCOLOR]}${COLORS[WHITE]} ● "
BADGE_INFO_RIGHT="${BG_COLORS[WHITE]}${COLORS[BLACK]}"
BADGE_INFO="${BADGE_INFO_LEFT}${BADGE_INFO_RIGHT}"

BADGE_SUCCESS_LEFT="${BG_COLORS[NOCOLOR]}${COLORS[GREEN]} ● "
BADGE_SUCCESS_RIGHT="${BG_COLORS[GREEN]}${COLORS[BLACK]}"
BADGE_SUCCESS="${BADGE_SUCCESS_LEFT}${BADGE_SUCCESS_RIGHT}"

BADGE_WARNING_LEFT="${BG_COLORS[NOCOLOR]}${COLORS[YELLOW]} ● "
BADGE_WARNING_RIGHT="${BG_COLORS[YELLOW]}${COLORS[BLACK]}"
BADGE_WARNING="${BADGE_WARNING_LEFT}${BADGE_WARNING_RIGHT}"

BADGE_DIE_LEFT="${BG_COLORS[NOCOLOR]}${COLORS[RED]} ● "
BADGE_DIE_RIGHT="${BG_COLORS[RED]}${COLORS[BLACK]}"
BADGE_DIE="${BADGE_DIE_LEFT}${BADGE_DIE_RIGHT}"

BADGE_CONFIRM_LEFT="${BG_COLORS[NOCOLOR]}${COLORS[CYAN]} ● "
BADGE_CONFIRM_RIGHT="${BG_COLORS[CYAN]}${COLORS[BLACK]}"
BADGE_CONFIRM="${BADGE_CONFIRM_LEFT}${BADGE_CONFIRM_RIGHT}"

# MENU COLORS #########################################################################################################

MENU_PROMPT_COLORS=("BLUE" "WHITE")

MENU_BADGE_LEFT="${BG_COLORS[BLUE]}${COLORS[BLACK]}"
MENU_BADGE_RIGHT="${BG_COLORS[NOCOLOR]}${COLORS[BLUE]}"

MENU_BADGE_SEARCH_LEFT="${BG_COLORS[NOCOLOR]}${COLORS[WHITE]}"
MENU_BADGE_SEARCH_RIGHT="${BG_COLORS[WHITE]}${COLORS[BLACK]}"

MENU_HEADER_LEFT=()
MENU_HEADER_LEFT+=("${COLORS[NOCOLOR]}")
MENU_HEADER_LEFT+=("${COLORS[NOCOLOR]}")
MENU_HEADER_LEFT+=("${COLORS[NOCOLOR]}")
MENU_HEADER_LEFT+=("${COLORS[NOCOLOR]}")

MENU_HEADER_RIGHT=()
MENU_HEADER_RIGHT+=("${BG_COLORS[NOCOLOR]}${COLORS[BLUE]}")
MENU_HEADER_RIGHT+=("${BG_COLORS[NOCOLOR]}${COLORS[BLUE]}")
MENU_HEADER_RIGHT+=("${BG_COLORS[NOCOLOR]}${COLORS[BLUE]}")
MENU_HEADER_RIGHT+=("${BG_COLORS[NOCOLOR]}${COLORS[BLUE]}")

MENU_COLUMN_LEFT=()
MENU_COLUMN_LEFT+=("${BG_COLORS[NOCOLOR]}${COLORS[BLUE]}")
MENU_COLUMN_LEFT+=("${BG_COLORS[NOCOLOR]}${COLORS[BLUE]}")
MENU_COLUMN_LEFT+=("${BG_COLORS[NOCOLOR]}${COLORS[BLUE]}")
MENU_COLUMN_LEFT+=("${BG_COLORS[NOCOLOR]}${COLORS[BLUE]}")

MENU_COLUMN_RIGHT=()
MENU_COLUMN_RIGHT+=("${BG_COLORS[BLUE]}${COLORS[BLACK]}")
MENU_COLUMN_RIGHT+=("${BG_COLORS[BLUE]}${COLORS[BLACK]}")
MENU_COLUMN_RIGHT+=("${BG_COLORS[BLUE]}${COLORS[BLACK]}")
MENU_COLUMN_RIGHT+=("${BG_COLORS[BLUE]}${COLORS[BLACK]}")

MENU_COLUMN_RIGHT_ENABLED=()
MENU_COLUMN_RIGHT_ENABLED+=("${BG_COLORS[NOCOLOR]}${COLORS[WHITE]}")
MENU_COLUMN_RIGHT_ENABLED+=("${BG_COLORS[NOCOLOR]}${COLORS[WHITE]}")
MENU_COLUMN_RIGHT_ENABLED+=("${BG_COLORS[NOCOLOR]}${COLORS[WHITE]}")
MENU_COLUMN_RIGHT_ENABLED+=("${BG_COLORS[NOCOLOR]}${COLORS[WHITE]}")

# PACKAGES COLOR ######################################################################################################

# Configure headers
PACKAGES_HEADER_LEFT="${COLORS[NOCOLOR]}"
PACKAGES_HEADER_RIGHT=()
# Category
PACKAGES_HEADER_RIGHT+=("${BG_COLORS[NOCOLOR]}${COLORS[BLUE]}")
# Name
PACKAGES_HEADER_RIGHT+=("${BG_COLORS[NOCOLOR]}${COLORS[BLUE]}")
# Source
PACKAGES_HEADER_RIGHT+=("${BG_COLORS[NOCOLOR]}${COLORS[BLUE]}")
# Installed
PACKAGES_HEADER_RIGHT+=("${BG_COLORS[NOCOLOR]}${COLORS[BLUE]}")
# Candidate
PACKAGES_HEADER_RIGHT+=("${BG_COLORS[NOCOLOR]}${COLORS[BLUE]}")
# Maintainer
PACKAGES_HEADER_RIGHT+=("${BG_COLORS[NOCOLOR]}${COLORS[BLUE]}")
# Description
PACKAGES_HEADER_RIGHT+=("${BG_COLORS[NOCOLOR]}${COLORS[BLUE]}")

PACKAGES_COLUMN=()
# Category
PACKAGES_COLUMN+=("${BG_COLORS[BLUE]}${COLORS[BLACK]}")
# Name
PACKAGES_COLUMN+=("${BG_COLORS[BLUE]}${COLORS[BLACK]}")
# Source
PACKAGES_COLUMN+=("${BG_COLORS[BLUE]}${COLORS[BLACK]}")
# Installed
PACKAGES_COLUMN+=("${BG_COLORS[BLUE]}${COLORS[BLACK]}")
# Candidate
PACKAGES_COLUMN+=("${BG_COLORS[BLUE]}${COLORS[BLACK]}")
# Maintainer
PACKAGES_COLUMN+=("${BG_COLORS[BLUE]}${COLORS[BLACK]}")
# Description
PACKAGES_COLUMN+=("${BG_COLORS[BLUE]}${COLORS[BLACK]}")
