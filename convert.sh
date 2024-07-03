#!/bin/bash
input="./input"
output="./output"

mkdir -p "$output" # Make output if it doesn't exist

# Get the total number of MKV files
total_files=$(ls "$input_directory"/*.mkv 2> /dev/null | wc -l)
converted_files=0

# Iterate over all MKV files in the input directory
for input_file in "$input"/*.mkv; do
    # Get the base name of the file (without directory and extension)
    base_name=$(basename "$input_file" .mkv)
    # Set the output file path
    output_file="$output/$base_name.mp4"
    # Run the ffmpeg command with GPU acceleration
    ffmpeg -hwaccel_device 0 -hwaccel cuda -i "$input_file" -c:v h264_nvenc -preset slow "$output_file"

    # Increment the counter
    converted_files=$((converted_files + 1))
    # Display progress
    echo "Converted $converted_files out of $total_files files."
done

echo "Conversion complete!"
