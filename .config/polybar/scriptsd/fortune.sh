#!/usr/bin/env bash
# Credit: Franklin Souza
# Telegram: @FranklinTech

scr='/tmp/screenshot.png'
icon="$HOME/.Lock/ArchLinux01.png"
font="$HOME/.fonts/Poppins.otf"

[ ! -d $HOME/.local/share/i3lock/ ] && mkdir -p $HOME/.local/share/i3lock/

# Expand is used to convert the tabs to spaces which
# are handled better by imageMagick
fortune=$(expand -t 2 <(fortune -s brasil))
gradientColor='#000000'

# take a screenshot
maim "$scr"

# get gradient dimensions directly from the screenshot
read width height <<<$(file $scr | cut -d, -f 2 | tr -d ' ' | tr 'x' ' ')
height=$((height / 2))

convert "$scr" -scale 10% -scale 1000%\
	-size "${width}x${height}" -gravity south-west \
	gradient:none-"$gradientColor" -composite -matte \
	"$icon" -gravity center -composite -matte \
	-gravity center -pointsize 20 \
    -font $font -fill "#EAE4D1" -annotate +0+220 "$fortune Talking is easy, show me the code." "$scr"
	-font $font -fill "#EAE4D1" -annotate +0+200 "$fortune" "$scr"
i3lock -ui "$scr"
