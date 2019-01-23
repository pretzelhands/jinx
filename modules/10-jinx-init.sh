#!/usr/bin/env bash

# Create configuration file if it doesn't exist.
if [[ ! -f $JINX_CONFIG_FILE ]]
then
    mkdir -p $JINX_CONFIG_FOLDER
    cat <<EOF > $JINX_CONFIG_FILE
#
# .jinx/config
# Configuration file for jinx
#
# Each configuration key must stand on its own line with no comments.
# The comments above each variable explain their purpose.
#

# Where you nginx.conf and other files are located.
nginx_path=/etc/nginx

# Where to find the configuration templates for new sites.
# Gets appended to the nginx path. Must not contain slashes
config_path=configurations

# Which editor to use for editing sites
editor=nano

# Decides whether or not to use colored output.
grumpy=0

EOF

    date +%s > "$JINX_CONFIG_FOLDER/last_update_check"

    echo -e "\033[1;33mFirst run!\033[0m Creating default configuration in ~/.jinx/config"
    echo "Pardon the interruption, we will now continue running your command."
    echo ""
fi

JINX_IS_GRUMPY=$(grep -oh "^grumpy=.*" $JINX_CONFIG_FILE | sed "s/grumpy=//")