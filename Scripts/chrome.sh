#!/bin/bash
touch $HOME/.config/chrome-flags.conf
echo -e "--use-gl=desktop --enable-features=VaapiVideoDecoder,WebUIDarkMode --force-dark-mode"
