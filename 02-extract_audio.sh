#!/bin/bash

# A script to extract an audio track from a video file using ffmpeg.

# --- Check if the correct number of arguments are provided ---
if [ "$#" -ne 2 ]; then
    echo "❌ Error: Invalid number of arguments."
    echo "Usage: $0 <input_video_path> <output_audio_path>"
    echo "Example: ./extract_audio.sh ./my_video.mp4 ./audio_output.mp3"
    exit 1
fi

# --- Assign arguments to variables for clarity ---
INPUT_VIDEO="$1"
OUTPUT_AUDIO="$2"

# --- Check if the input file exists ---
if [ ! -f "$INPUT_VIDEO" ]; then
    echo "❌ Error: Input file not found at '$INPUT_VIDEO'"
    exit 1
fi

echo "▶️  Starting audio extraction..."
echo "    Input video: $INPUT_VIDEO"
echo "    Output audio: $OUTPUT_AUDIO"

# --- Execute the ffmpeg command ---
# -i: specifies the input file
# -q:a 0: sets the audio quality to the best possible (variable bitrate)
# -map a: selects only the audio stream(s) for processing
ffmpeg -i "$INPUT_VIDEO" -q:a 0 -map a "$OUTPUT_AUDIO"

# --- Check if the ffmpeg command was successful ---
if [ $? -eq 0 ]; then
    echo "✅ Success! Audio extracted to '$OUTPUT_AUDIO'"
else
    echo "❌ Error: ffmpeg command failed. Please check your installation and file paths."
    exit 1
fi