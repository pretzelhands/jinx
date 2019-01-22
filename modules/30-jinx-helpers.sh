#!/usr/bin/env bash

function jinx_help {
    echo -e "${FORMAT_BOLD}${FORMAT_UNDERLINE}Available commands:${FORMAT_END}"
    echo -e ""
    echo -e "${COLOR_PURPLE_LIGHT}config <key>${FORMAT_END}                             get config value from ~/.jinx/config"
    echo -e "${COLOR_PURPLE_LIGHT}config <key> <value>${FORMAT_END}                     set config value in ~/.jinx/config"
    echo -e ""
    echo -e "${COLOR_PURPLE_LIGHT}version${FORMAT_END}                                  output jinx version number"
    echo -e "${COLOR_PURPLE_LIGHT}update${FORMAT_END}                                   update to latest version"
    echo -e ""
    echo -e "${COLOR_PURPLE_LIGHT}site activate <name> [--restart|-r]${FORMAT_END}      activate a site"
    echo -e "${COLOR_PURPLE_LIGHT}site deactivate <name> [--restart|-r]${FORMAT_END}    deactivate a site"
    echo -e "${COLOR_PURPLE_LIGHT}site delete <name> [--yes|-y]${FORMAT_END}            delete a site"
    echo -e "${COLOR_PURPLE_LIGHT}site create <name> [<template>]${FORMAT_END}          create a site from template"
    echo -e "${COLOR_PURPLE_LIGHT}site edit <name>${FORMAT_END}                         edit a site .conf file with editor"
    echo -e ""
    echo -e "${COLOR_PURPLE_LIGHT}start${FORMAT_END}                                    start nginx service"
    echo -e "${COLOR_PURPLE_LIGHT}restart${FORMAT_END}                                  restart nginx service"
    echo -e "${COLOR_PURPLE_LIGHT}stop${FORMAT_END}                                     stop nginx service"
    echo -e "${COLOR_PURPLE_LIGHT}logs${FORMAT_END}                                     get nginx error logs"
    echo ""
}


# Various useful getter functions

function jinx_get_json_value {
    echo $(echo $1 | python "$JINX_FOLDER/helpers/get_json_value.py" $2)
}

function jinx_get_yesterday_timestamp {
    echo $(python "$JINX_FOLDER/helpers/get_yesterday_timestamp.py")
}