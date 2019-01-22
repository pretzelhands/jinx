#!/usr/bin/env bash

function jinx_latest_version {
    echo $(curl -s https://api.github.com/repos/pretzelhands/jinx/releases/latest)
}

function jinx_check_version {
    local JINX_LAST_UPDATE_CHECK=$(cat "$JINX_CONFIG_FOLDER/last_update_check")
    local JINX_LAST_UPDATE_LIMIT=$(jinx_get_yesterday_timestamp)

    if [[ $JINX_LAST_UPDATE_CHECK -gt $JINX_LAST_UPDATE_LIMIT ]]
    then
        return
    fi

    local JINX_LATEST_RELEASE=$(jinx_latest_version)
    local JINX_LATEST_VERSION=$(jinx_get_json_value "$JINX_LATEST_RELEASE" "tag_name")

    if [[ "$JINX_VERSION" != "$JINX_LATEST_VERSION" ]]
    then
        echo -e "${COLOR_YELLOW}There is a new version of jinx available.${FORMAT_END}"
        echo -e "Please run 'jinx update' to get the latest version"
    fi
}

function jinx_update_version {
    echo -n "Grabbing latest release from GitHub... "

    local JINX_EXECUTABLE=$(which jinx)
    local JINX_TMP="/var/tmp/jinx"
    local JINX_LATEST_RELEASE=$(jinx_latest_version)
    local JINX_LATEST_TARBALL=$(jinx_get_json_value "$JINX_LATEST_RELEASE" "tarball_url")
    local JINX_LATEST_VERSION=$(jinx_get_json_value "$JINX_LATEST_RELEASE" "tag_name")

    if [[ "$JINX_VERSION" == "$JINX_LATEST_VERSION" ]]
    then
        echo -e "${COLOR_GREEN}done.${FORMAT_END}\n${COLOR_GREEN}You are already using the latest version of jinx!${FORMAT_END}"
        exit 0
    fi

    echo -e "${COLOR_GREEN}done.${FORMAT_END}"
    echo -n "Grabbing latest tarball from GitHub... "
    mkdir -p $JINX_TMP
    mkdir -p $JINX_TMP/unpacked
    curl -L "$JINX_LATEST_TARBALL" -o "$JINX_TMP/jinx.tar.gz" --silent
    echo -e "${COLOR_GREEN}done.${FORMAT_END}"

    echo -n "Unpacking jinx executable and installing ... "
    tar xzf "$JINX_TMP/jinx.tar.gz" -C "$JINX_TMP/unpacked" --strip-components 1
    mv "$JINX_TMP/unpacked/jinx" "$JINX_EXECUTABLE"
    echo -e "${COLOR_GREEN}done.${FORMAT_END}"

    rm -r /var/tmp/jinx
    exit 0
}