#!/bin/sh

HOST=192.168.0.1

if ! ping=$(ping -n -c 1 -W 1 $HOST 2> /dev/null); then
    echo "%{F#BF616A}%{F-} Host não identificado"
else
    rtt=$(echo "$ping" | sed -rn 's/.*time=([0-9]{1,})\.?[0-9]{0,} ms.*/\1/p')

    if [ "$rtt" -lt 100 ]; then
        icon="%{F#92eb8b}%{F-}"
    elif [ "$rtt" -lt 150 ]; then
        icon="%{F#e5eb8b}%{F-}"
    else
        icon="%{F#eb8b8b}%{F-}"
    fi

    echo "$icon $rtt ms"
fi
