#!/usr/bin/env bash

# Define colors and formats for making everything pretty.
COLOR_RED=`[[ $JINX_IS_GRUMPY -eq 1 ]] && echo "" || echo "\033[0;31m"`
# COLOR_RED_LIGHT=`[[ $JINX_IS_GRUMPY -eq 1 ]] && echo "" || echo "\033[1;31m"`

COLOR_GREEN=`[[ $JINX_IS_GRUMPY -eq 1 ]] && echo "" || echo "\033[0;32m"`
# COLOR_GREEN_LIGHT=`[[ $JINX_IS_GRUMPY -eq 1 ]] && echo "" || echo "\033[1;32m"`

COLOR_ORANGE=`[[ $JINX_IS_GRUMPY -eq 1 ]] && echo "" || echo "\033[0;33m"`
COLOR_YELLOW=`[[ $JINX_IS_GRUMPY -eq 1 ]] && echo "" || echo "\033[1;33m"`

# COLOR_BLUE=`[[ $JINX_IS_GRUMPY -eq 1 ]] && echo "" || echo "\033[0;34m"`
# COLOR_BLUE_LIGHT=`[[ $JINX_IS_GRUMPY -eq 1 ]] && echo "" || echo "\033[1;34m"`

# COLOR_PURPLE=`[[ $JINX_IS_GRUMPY -eq 1 ]] && echo "" || echo "\033[0;35m"`
COLOR_PURPLE_LIGHT=`[[ $JINX_IS_GRUMPY -eq 1 ]] && echo "" || echo "\033[1;35m"`

# COLOR_CYAN=`[[ $JINX_IS_GRUMPY -eq 1 ]] && echo "" || echo "\033[0;36m"`
# COLOR_CYAN_LIGHT=`[[ $JINX_IS_GRUMPY -eq 1 ]] && echo "" || echo "\033[1;36m"`

# COLOR_GRAY=`[[ $JINX_IS_GRUMPY -eq 1 ]] && echo "" || echo "\033[1;30m"`
# COLOR_GRAY_LIGHT=`[[ $JINX_IS_GRUMPY -eq 1 ]] && echo "" || echo "\033[0;37m"`

# COLOR_BLACK=`[[ $JINX_IS_GRUMPY -eq 1 ]] && echo "" || echo "\033[0;30m"`
# COLOR_WHITE=`[[ $JINX_IS_GRUMPY -eq 1 ]] && echo "" || echo "\033[1;37m"`

FORMAT_BOLD=`[[ $JINX_IS_GRUMPY -eq 1 ]] && echo "" || echo "\033[1m"`
FORMAT_UNDERLINE=`[[ $JINX_IS_GRUMPY -eq 1 ]] && echo "" || echo "\033[4m"`

FORMAT_END=`[[ $JINX_IS_GRUMPY -eq 1 ]] && echo "" || echo "\033[0m"`

