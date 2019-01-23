#!/usr/bin/env bash

jinx_config_set() {
    local JINX_CONFIG_VALUE="$2"

    if [[ -z "$1" ]] || [[ -z "$2" ]]
    then
         echo -e "${COLOR_RED}Failure.${FORMAT_END} Please specify a configuration key and value."
         exit 1
    fi

    if [[ "$1" == "config_path" ]]
    then
        local JINX_CONFIG_VALUE=$(echo $2 | sed -e "s#/##g")
    fi

    grep -q "$1=.*" $JINX_CONFIG_FILE \
        && sed -i -e "s#$1=.*#$1=$JINX_CONFIG_VALUE#" $JINX_CONFIG_FILE \
        || echo "$1=$JINX_CONFIG_VALUE" >> $JINX_CONFIG_FILE

    echo -e "${COLOR_GREEN}Success.${FORMAT_END} Updated setting '$1' to '$JINX_CONFIG_VALUE'."
    exit 0
}

jinx_config_get() {
    if [[ -z "$1" ]]
    then
         echo -e "${COLOR_RED}Failure.${FORMAT_END} Please specify a configuration key."
         exit 1
    fi

    echo $(grep -oh "^$1=.*" $JINX_CONFIG_FILE | sed "s/$1=//")
    exit 0
}
