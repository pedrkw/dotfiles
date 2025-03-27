#!/bin/bash
set -euo pipefail

usage() {
    cat <<EOF
Usage: $(basename "$0") [OPTIONS]

Options:
  -f <file>         Path to the original video file.
  -o <output>       Output file name.
  -h                Show this help message and exit.

If -f or -o are not provided, the script will prompt for them interactively.
The script will also ask for the output directory (default: \$HOME/Videos if it exists, otherwise \$HOME).
If the output file name is not provided, the script uses "EDIT_" followed by the current date (year-month-day) and the original file's extension.
EOF
}

# Initialize variables
orig_file=""
output_name=""

# Parse command-line options
while getopts ":f:o:h" opt; do
    case ${opt} in
        f)
            orig_file=$OPTARG
            ;;
        o)
            output_name=$OPTARG
            ;;
        h)
            usage
            exit 0
            ;;
        \?)
            echo "Invalid option: -$OPTARG" >&2
            usage
            exit 1
            ;;
        :)
            echo "Option -$OPTARG requires an argument." >&2
            usage
            exit 1
            ;;
    esac
done

shift $((OPTIND - 1))

# Function to print an error and exit
error_exit() {
    echo "Error: $1" >&2
    exit 1
}

# If original file not provided via CLI, ask interactively
if [ -z "$orig_file" ]; then
    read -rp "Enter the path to the original video file: " orig_file
fi
[ -z "$orig_file" ] && error_exit "No video file provided."
[ ! -f "$orig_file" ] && error_exit "The file '$orig_file' does not exist."

# Determine default destination folder
if [ -d "$HOME/Videos" ]; then
    default_dest="$HOME/Videos"
else
    default_dest="$HOME"
fi

# Ask for the output directory
read -rp "Enter the output directory (default: $default_dest): " output_dir
output_dir="${output_dir:-$default_dest}"
[ ! -d "$output_dir" ] && error_exit "The directory '$output_dir' does not exist."

# If output file name not provided via CLI, ask interactively
if [ -z "$output_name" ]; then
    read -rp "Enter the output file name (leave empty to use 'EDIT' with timestamp): " output_name
fi

# If still not provided, generate file name based on original file name
if [ -z "$output_name" ]; then
    ext="${orig_file##*.}"
    timestamp=$(date +%Y-%m-%d)
    output_name="EDIT_${timestamp}.${ext}"
fi

# Build full output file path
output_path="$output_dir/$output_name"

# Run ffmpeg with VAAPI acceleration using the provided command
ffmpeg -hwaccel vaapi -vaapi_device /dev/dri/renderD128 -i "$orig_file" \
    -vf 'format=nv12,hwupload' -c:v h264_vaapi -b:v 5M -c:a aac -b:a 128k "$output_path" || error_exit "ffmpeg command failed."

echo "Video processing completed successfully. Output file created at: $output_path"
