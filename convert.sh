#!/usr/bin/env bash
input="./input"
output="./output"

mkdir -p "$input" # Make input if it doesn't exist
mkdir -p "$output"

# Get the total number of MKV files
total_files=$(ls "$input"/*.mkv 2> /dev/null | wc -l)
checked_files=0

# Check if there are any files to process
if [ "$total_files" -eq 0 ]; then
    echo "No video files found in the input directory."
    exit 1
fi

 # Check if FFmpeg is installed
if ! command -v ffmpeg &> /dev/null; then
    echo "FFmpeg could not be found. Please make sure it is installed and accessible."
    exit 1
fi

# Iterate over all MKV files in the input directory
for input_file in "$input"/*.mkv; do
    checked_files=$((checked_files + 1))

    # Get the base name of the file (without directory and extension)
    base_name=$(basename "$input_file" .mkv)

    # Set the output file path
    output_file="$output/$base_name.mp4"

    # Get the original bitrate of the input file in kbps (To choose the encoded bitrate)
    original_bitrate=$(ffprobe -v error -select_streams v:0 -show_entries stream=bit_rate -of default=noprint_wrappers=1:nokey=1 "$input_file" | awk '{print int($1/1000)}')

    # If bitrate extraction failed or is zero, set a default bitrate (6000 kbps)
    if [ -z "$original_bitrate" ] || [ "$original_bitrate" -eq 0 ]; then
        original_bitrate=6000
    fi

    # Calculate buffer size (usually double the bitrate)
    bufsize=$((original_bitrate * 2))

    # Check if the output file already exists
    if [ -f "$output_file" ]; then
        echo "Skipping $input_file, already converted."
        continue
    fi
    
    # Run the ffmpeg command with GPU acceleration and preset for quality
    # The -preset flag is what you likely want to change for quality, p1-p7. p1 is fast but bulky, p7 is slow but compact
    if ! ffmpeg -hwaccel_device 0 -hwaccel cuda -i "$input_file" -c:v h264_nvenc -preset p7 -vf "scale=iw:ih" -b:v "${original_bitrate}k" -maxrate "${original_bitrate}k" -bufsize "${bufsize}k" "$output_file"; then
        echo "Error occurred during conversion of $input_file"
        continue
    fi

    # Display progress
    echo "Converted $checked_files out of $total_files files."
done

echo "Conversion complete!"
