#!/bin/sh

# ufetch-like script

## INFO
user=$(whoami)
host=$(hostname)
#os="Linux"
os=$(grep '^PRETTY_NAME=' /etc/os-release | cut -d'"' -f2)
kernel=$(uname -sr)
uptime=$(uptime -p | sed 's/up //')
shell=$(basename "$SHELL")

## DEFINE COLORS
bold="$(tput bold)"
black="$(tput setaf 0)"
red="$(tput setaf 1)"
green="$(tput setaf 2)"
yellow="$(tput setaf 3)"
blue="$(tput setaf 4)"
magenta="$(tput setaf 5)"
cyan="$(tput setaf 6)"
white="$(tput setaf 7)"
reset="$(tput sgr0)"

# Color definitions for output
lc="${reset}${bold}${black}"      # labels
nc="${reset}${yellow}"            # user and hostname
ic="${reset}${bold}${white}"      # info
c0="${reset}${blue}"              # first color
c1="${reset}${cyan}"              # second color
c2="${reset}${green}"             # third color

## OUTPUT
cat <<EOF

${c0}      ___     ${nc}${user}${ic}@${nc}${host}${reset}
${c0}     (${c1}.. ${c0}\    ${lc}OS:        ${ic}${os}${reset}
${c0}     (${c2}<> ${c0}|    ${lc}KERNEL:    ${ic}${kernel}${reset}
${c0}    /${c1}/  \\ ${c0}\\   ${lc}UPTIME:    ${ic}${uptime}${reset}
${c0}   ( ${c1}|  | ${c0}/|  ${lc}SHELL:     ${ic}${shell}${reset}
${c2}  _${c0}/\\ ${c1}__)${c0}/${c2}_${c0})  
${c2}  \/${c0}-____${c2}\/${reset}

EOF
