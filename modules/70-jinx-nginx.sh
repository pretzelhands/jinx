#!/usr/bin/env bash

jinx_nginx_service() {
    case "$1" in
        start) nginx ;;
        stop) nginx -s stop ;;
        restart) nginx -s reload ;;
    esac

    if [[ $? -eq 0 ]]
    then
        local COMMAND=$(echo "$1" | sed 's/.*/\u&/')
        echo -e "${COLOR_GREEN}Success.${FORMAT_END} ${COMMAND}ed nginx on your system."
    fi
}

jinx_nginx_logs() {
    local NGINX_PATH=$(jinx_config_get "nginx_path")
    local NGINX_CONFIG_FILE="$NGINX_PATH/nginx.conf"
    local NGINX_LOGS=$(grep -oh "^error_log .*" "$NGINX_CONFIG_FILE" | sed "s/^error_log //")

    tail -f $(echo "$NGINX_LOGS" | tr -d ";")
}