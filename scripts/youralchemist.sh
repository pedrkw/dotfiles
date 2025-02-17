#!/bin/bash

# Output directory
OUTPUT_DIR="$HOME/Media/YourAlchemist"
mkdir -p "$OUTPUT_DIR/image" "$OUTPUT_DIR/audio" "$OUTPUT_DIR/video"

# Supported formats
declare -A FORMATS
FORMATS[1]="1 GIF 2 PNG 3 JPEG 4 SVG"
FORMATS[2]="1 MP3 2 M4A 3 OPUS"
FORMATS[3]="1 M4V 2 MP4 3 WEBM 4 MKV"

# Get timestamp
get_timestamp() {
    date +"%Y_%m_%d_%H_%M_%S"
}

# File conversion function
convert_file() {
    local category="$1"
    local format_index="$2"
    local input_file="$3"

    if [[ ! -f "$input_file" ]]; then
        echo "Error: File not found!"
        exit 1
    fi

    local timestamp="$(get_timestamp)"
    local formats=(${FORMATS[$category]})
    local extension="$(echo ${formats[$((format_index*2-1))]} | tr '[:upper:]' '[:lower:]')"
    local filename="$timestamp.$extension"

    case $category in
        1) output_folder="$OUTPUT_DIR/image" ;;
        2) output_folder="$OUTPUT_DIR/audio" ;;
        3) output_folder="$OUTPUT_DIR/video" ;;
        *) echo "Error: Invalid category!"; exit 1 ;;
    esac

    output_path="$output_folder/$filename"

    case $category in
        1) convert "$input_file" "$output_path" ;; # Image
        2)
            case ${formats[$((format_index*2-1))]} in
                MP3) ffmpeg -i "$input_file" -q:a 2 "$output_path" -y -progress pipe:1 ;;
                M4A|OPUS) ffmpeg -i "$input_file" -b:a 128k "$output_path" -y -progress pipe:1 ;;
            esac
            ;;
        3)
            case ${formats[$((format_index*2-1))]} in
                MP4|M4V|MKV) ffmpeg -hwaccel vaapi -vaapi_device /dev/dri/renderD128 -i "$input_file" -c:v h264_vaapi -qp 22 "$output_path" -y -progress pipe:1 ;;
                WEBM) ffmpeg -hwaccel vaapi -vaapi_device /dev/dri/renderD128 -i "$input_file" -c:v vp9_vaapi -b:v 1M "$output_path" -y -progress pipe:1 ;;
            esac
            ;;
    esac

    if [[ $? -eq 0 ]]; then
        echo "Conversion complete: $output_path"
    else
        echo "Error converting file."
    fi
}

# TUI Mode
interactive_mode() {
    dialog --clear --title "File Converter" --menu "Choose a category:" 15 50 3 \
        1 "Image" \
        2 "Audio" \
        3 "Video" 2> category.txt
    category=$(<category.txt)
    rm -f category.txt

    if [[ -z "${FORMATS[$category]}" ]]; then
        echo "Invalid category!"; exit 1
    fi

    format_index=$(dialog --clear --title "Choose Format" --menu "Select output format:" 15 50 5 $(
        echo ${FORMATS[$category]}
    ) 2>&1 >/dev/tty)

    input_file=$(dialog --clear --title "File Input" --inputbox "Enter the file path:" 10 50 2>&1 >/dev/tty)

    convert_file "$category" "$format_index" "$input_file"
}

# Command-line Mode
if [[ $# -ge 2 ]]; then
    category="$1"
    format_index="$2"
    input_file="$3"

    if [[ -z "$input_file" ]]; then
        read -p "Enter the file path: " input_file
    fi

    convert_file "$category" "$format_index" "$input_file"
else
    interactive_mode
fi
