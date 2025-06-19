#!/bin/bash

# Output directory
OUTPUT_DIR="$HOME/Media/YourAlchemist"
mkdir -p "$OUTPUT_DIR/image" "$OUTPUT_DIR/audio" "$OUTPUT_DIR/video"

# Supported formats
declare -A FORMATS
FORMATS[1]="1 GIF 2 PNG 3 JPEG 4 SVG"
FORMATS[2]="1 MP3 2 M4A 3 OPUS"
FORMATS[3]="1 M4V 2 MP4 3 WEBM 4 MKV"

# Optional: Check for required tools (uncomment to enable)
# if ! command -v ffmpeg &> /dev/null; then echo "Error: ffmpeg is not installed."; exit 1; fi
# if ! command -v convert &> /dev/null; then echo "Error: ImageMagick is not installed."; exit 1; fi
# if ! command -v dialog &> /dev/null; then echo "Error: dialog is not installed."; exit 1; fi

# Get timestamp
get_timestamp() {
    date +"%Y_%m_%d_%H_%M_%S"
}

# File conversion function
convert_file() {
    local category="$1"
    local format_index="$2"
    local input_file="$3"

    # Validate category
    if [[ ! "1 2 3" =~ $category ]]; then
        echo "Error: Invalid category! Must be 1 (Image), 2 (Audio), or 3 (Video)."
        exit 1
    fi

    # Validate format_index
    if ! [[ $format_index =~ ^[0-9]+$ ]]; then
        echo "Error: Format index must be an integer!"
        exit 1
    fi

    local formats=(${FORMATS[$category]})
    local max_index=$((${#formats[@]}/2))
    if [[ $format_index -lt 1 || $format_index -gt $max_index ]]; then
        echo "Error: Invalid format index! Must be between 1 and $max_index for category $category."
        exit 1
    fi

    # Check if input file exists
    if [[ ! -f "$input_file" ]]; then
        echo "Error: File not found!"
        exit 1
    fi

    local timestamp="$(get_timestamp)"
    local extension="$(echo ${formats[$((format_index*2-1))]} | tr '[:upper:]' '[:lower:]')"
    local filename="$timestamp.$extension"

    case $category in
        1) output_folder="$OUTPUT_DIR/image" ;;
        2) output_folder="$OUTPUT_DIR/audio" ;;
        3) output_folder="$OUTPUT_DIR/video" ;;
    esac

    output_path="$output_folder/$filename"

    case $category in
        1) # Image conversion
            convert "$input_file" "$output_path"
            ;;
        2) # Audio conversion
            case ${formats[$((format_index*2-1))]} in
                MP3) ffmpeg -i "$input_file" -q:a 2 "$output_path" -y -progress pipe:1 ;;
                M4A|OPUS) ffmpeg -i "$input_file" -b:a 128k "$output_path" -y -progress pipe:1 ;;
            esac
            ;;
        3) # Video conversion
            case ${formats[$((format_index*2-1))]} in
                MP4|M4V|MKV) ffmpeg -i "$input_file" -c:v libx264 -crf 22 -c:a aac -b:a 128k "$output_path" -y -progress pipe:1 ;;
                WEBM) ffmpeg -i "$input_file" -c:v libvpx-vp9 -b:v 1M -c:a libopus -b:a 128k "$output_path" -y -progress pipe:1 ;;
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
        echo "Invalid category!"
        exit 1
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
