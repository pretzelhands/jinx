#!/usr/bin/env bash

function jinx_optional_restart {
    case "$1" in
        --restart|-r) jinx_nginx_service "restart";;
    esac
}

function jinx_site_activate {
    if [[ -z "$1" ]]
    then
         echo -e "${COLOR_RED}Failure.${FORMAT_END} Please specify a site name."
         exit 1
    fi

    local NGINX_PATH=$(jinx_config_get "nginx_path")
    local FILE_PATH="$NGINX_PATH/sites-available/$1.conf"

    if [[ ! -f "$FILE_PATH" ]]
    then
         echo -e "${COLOR_RED}Failure.${FORMAT_END} Site '$1' does not exist."
         exit 1
    fi

    ln -sfn $FILE_PATH $NGINX_PATH/sites-enabled/ > /dev/null
    echo -e "${COLOR_GREEN}Success.${FORMAT_END} Activated site '$1'."

    jinx_optional_restart "$2"

    exit 0
}

function jinx_site_deactivate {
    if [[ -z "$1" ]]
    then
         echo -e "${COLOR_RED}Failure.${FORMAT_END} Please specify a site name."
         exit 1
    fi

    local NGINX_PATH=$(jinx_config_get "nginx_path")
    local FILE_PATH="$NGINX_PATH/sites-enabled/$1.conf"

    if [[ ! -f "$FILE_PATH" ]]
    then
         echo -e "${COLOR_ORANGE}Failure.${FORMAT_END} Site '$1' is not activated."
         exit 1
    fi

    rm $FILE_PATH
    echo -e "${COLOR_GREEN}Success.${FORMAT_END} Deactivated site '$1'."

    jinx_optional_restart "$2"

    exit 0
}

function jinx_site_edit {
    if [[ -z "$1" ]]
    then
         echo -e "${COLOR_RED}Failure.${FORMAT_END} Please specify a site name."
         exit 1
    fi

    local EDITOR=$(jinx_config_get "editor")
    local NGINX_PATH=$(jinx_config_get "nginx_path")
    local FILE_PATH="$NGINX_PATH/sites-available/$1.conf"

    if [[ ! -f "$FILE_PATH" ]]
    then
         echo -e "${COLOR_RED}Failure.${FORMAT_END} Site '$1' does not exist."
         exit 1
    fi

    if [[ -z "$EDITOR" ]]
    then
         local EDITOR=nano
         echo -e "${COLOR_YELLOW}No preferred editor.${FORMAT_END} Falling back to nano. Please set the EDITOR configuration key"
    fi

    $EDITOR $FILE_PATH
    exit 0
}

function jinx_site_create {
    local CONFIG_TEMPLATE="default"

    if [[ -z "$1" ]]
    then
         echo -e "${COLOR_RED}Failure.${FORMAT_END} Please specify a site name."
         exit 1
    fi

    if [[ ! -z "$2" ]]
    then
         local CONFIG_TEMPLATE="$2"
    fi

    local NGINX_PATH=$(jinx_config_get "nginx_path")
    local CONFIG_PATH=$(jinx_config_get "config_path")
    local TEMPLATE_PATH="$NGINX_PATH$CONFIG_PATH/"
    local TEMPLATE_FILE="$TEMPLATE_PATH$CONFIG_TEMPLATE.conf"
    local NEW_FILE_PATH="$NGINX_PATH/sites-available/$1.conf"

    if [[ ! -f "$TEMPLATE_FILE" ]]
    then
         echo -e "${COLOR_RED}Failure.${FORMAT_END} Configuration template '$CONFIG_TEMPLATE' does not exist."
         exit 1
    fi

    if [[ -f "$NEW_FILE_PATH" ]]
    then
         echo -e "${COLOR_RED}Failure.${FORMAT_END} Site '$1' already exists. Please choose another name."
         exit 1
    fi

    cp "$TEMPLATE_FILE" "$NEW_FILE_PATH"
    sed -i -e "s/___/$1/g" "$NEW_FILE_PATH"

    echo -e "${COLOR_GREEN}Success.${FORMAT_END} Site '$1' was created and can now be activated."
    exit 0
}

function jinx_site_delete {
    local NGINX_PATH=$(jinx_config_get "nginx_path")
    local FILE_PATH_AVAILABLE="$NGINX_PATH/sites-available/$1.conf"
    local FILE_PATH_ENABLED="$NGINX_PATH/sites-enabled/$1.conf"

    if [[ -f $FILE_PATH_ENABLED ]]
    then
        echo -e "${COLOR_RED}${FORMAT_UNDERLINE}${FORMAT_BOLD}ABORTING. Site '$1' is currently activated!${FORMAT_END}"
        echo -e "If you really want to delete it, please deactivate the site first."
        exit 2
    fi

    if [[ ! -f $FILE_PATH_AVAILABLE ]]
    then
        echo -e "${COLOR_RED}Failure.${FORMAT_END} Site '$1' does not exist."
        exit 1
    fi

    if [[ ! "$2" == "-y" ]] && [[ ! "$2" == "--yes" ]]
    then
        echo -e "${COLOR_ORANGE}Careful:${FORMAT_END} Are you sure you want to delete site '$1'? (y/N): \c"
        read DELETE_CONSENT

        local COMP_DELETE_CONSENT=$(echo $DELETE_CONSENT | tr '[A-Z]' '[a-z]')
    else
        local COMP_DELETE_CONSENT="y"
    fi

    if [[ "$COMP_DELETE_CONSENT" == "y" || "$COMP_DELETE_CONSENT" == "yes" ]]
    then
        rm $FILE_PATH_AVAILABLE
        echo -e "${COLOR_GREEN}Success.${FORMAT_END} Site '$1' was deleted."
        exit 0
    fi

    echo -e "${COLOR_RED}Aborting.${FORMAT_END} Did not receive 'y' or 'yes' as answer, so not deleting site."
    exit 1
}