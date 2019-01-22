#!/usr/bin/env bash

function jinx_nginx_service {
    case "$1" in
        start)
            nginx
            echo -e "${COLOR_GREEN}Success.${FORMAT_END} Started nginx on your system."
        ;;

        stop)
            nginx -s stop
            echo -e "${COLOR_GREEN}Success.${FORMAT_END} Stopped nginx on your system."
        ;;

        restart)
            nginx -s reload
            echo -e "${COLOR_GREEN}Success.${FORMAT_END} Restarted nginx on your system."
        ;;

    esac
}

function jinx_nginx_logs {
    local NGINX_PATH=$(jinx_config_get "nginx_path")
    local NGINX_CONFIG_FILE="$NGINX_PATH/nginx.conf"
    local NGINX_LOGS=$(grep -oh "error_log .*" "$NGINX_CONFIG_FILE" | sed "s/^error_log //")

    tail -f $(echo "$NGINX_LOGS" | tr -d ";")
}