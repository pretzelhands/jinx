#!/usr/bin/env bash

jinx_check_version() {
    local JINX_LAST_UPDATE_CHECK=$(cat "$JINX_CONFIG_FOLDER/last_update_check")
    local JINX_LAST_UPDATE_LIMIT=$(jinx_get_yesterday_timestamp)

    if [[ $JINX_LAST_UPDATE_CHECK -gt $JINX_LAST_UPDATE_LIMIT ]]
    then
        return
    fi

    local JINX_LATEST_VERSION=$(curl -sq ${JINX_RELEASE_URL} | awk -F\" '/tag_name/ {print $4;}')

    if [[ "$JINX_VERSION" != "$JINX_LATEST_VERSION" ]]
    then
        echo -e "${COLOR_YELLOW}There is a new version of jinx available.${FORMAT_END}"
        echo -e "Please run 'jinx update' to get the latest version"
    fi
}

jinx_update_version() {
    echo -n "Grabbing latest release from GitHub... "

    # Relevant files and folders.
    local JINX_EXECUTABLE=$(which jinx)

    # Grab the relevant tarball
    local JINX_TARBALL=$(curl -sq ${JINX_RELEASE_URL} | awk -F\" '/tarball_url/ {print $4;}')
    local JINX_LATEST_VERSION=$(curl -sq ${JINX_RELEASE_URL} | awk -F\" '/tag_name/ {print $4;}')

    if [[ "$JINX_VERSION" == "$JINX_LATEST_VERSION" ]]
    then
        echo -e "${COLOR_GREEN}done.${FORMAT_END}\n${COLOR_GREEN}You are already using the latest version of jinx!${FORMAT_END}"
        exit 0
    fi

    echo -e "${COLOR_GREEN}done.${FORMAT_END}"

    # Clean up in case an existing jinx installation is there
    [ -d "$JINX_ETC" ] && rm -r $JINX_ETC
    [ -f "$JINX_BIN" ] && rm $JINX_BIN

    # Prepare temporary directory
    mkdir -p $JINX_TMP/unpacked

    # Create directory for module and helper scripts
    mkdir -p $JINX_ETC/helpers
    mkdir -p $JINX_ETC/modules

    # Fetch the tarball
    echo -n "Grabbing latest tarball from GitHub... "
    curl -L "$JINX_TARBALL" -o "$JINX_TMP/jinx.tar.gz" --silent
    tar xzf "$JINX_TMP/jinx.tar.gz" -C "$JINX_TMP/unpacked" --strip-components 1
    echo -e "${COLOR_GREEN}done.${FORMAT_END}"

    # Move everything to where it belongs
    echo -n "Installing files... "
    mv "$JINX_TMP/unpacked/jinx" "$JINX_BIN"
    mv "$JINX_TMP/unpacked/helpers" "$JINX_ETC"
    mv "$JINX_TMP/unpacked/modules" "$JINX_ETC"

    # Make the script executable
    chmod a+x "$JINX_BIN"
    echo -e "${COLOR_GREEN}done.${FORMAT_END}"

    # Always clean up behind yourself
    echo -n "Cleaning up... "
    rm -r $JINX_TMP
    echo -e "${COLOR_GREEN}done.${FORMAT_END}"
}

jinx_uninstall() {
    if [[ $1 == "-y" ]] || [[ $1 == "--yes" ]]
    then
        echo -e "\n${COLOR_RED}Time to say goodbye. Uninstalling jinx.${FORMAT_END}"
        echo -n "Removing modules and executable... "

        rm -r $JINX_ETC
        rm $JINX_BIN

        echo -e "${COLOR_GREEN}done${FORMAT_END}\n"

        echo -e "Your existing configuration is still preserved in the ~/.jinx folder."
        echo -e "You can delete this folder if you want.\n"

        exit 0
    fi

    echo -e "\n${COLOR_ORANGE}Oh no! So sorry to see you go.${FORMAT_END}"
    echo -e "If you really want to uninstall jinx please run: ${COLOR_PURPLE_LIGHT}jinx uninstall -y${FORMAT_END}\n"
}