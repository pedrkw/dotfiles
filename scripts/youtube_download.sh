#!/bin/bash

echo "Script to download audio or video by @pedrkw"
echo "Select an option:"
echo "1 - Download video"
echo "2 - Download audio"
read option

if [ "$option" == "1" ]; then
    cd
    echo "Enter the path where the video should be saved"
    read path
    cd "$path" || { echo "The specified path does not exist"; exit 1; }
    
    echo "Paste the URL/link of the video"
    read video_url

    # Check if youtube-dl command exists before running it
    if ! command -v youtube-dl &> /dev/null; then
        echo "youtube-dl command not found, please install it first"
        exit 1
    fi

    youtube-dl "$video_url"
    echo "Download completed, the file was downloaded successfully"
elif [ "$option" == "2" ]; then
    cd
    echo "Enter the path where the audio should be saved"
    read path
    cd "$path" || { echo "The specified path does not exist"; exit 1; }

    echo "Paste the URL/link of the video"
    read audio_url

    # Check if youtube-dl command exists before running it
    if ! command -v youtube-dl &> /dev/null; then
        echo "youtube-dl command not found, please install it first"
        exit 1
    fi

    youtube-dl --extract-audio --audio-format mp3 "$audio_url"
    echo "Download completed, the file was downloaded successfully"
else
    echo "Invalid option, please select 1 or 2"
    exit 1
fi
