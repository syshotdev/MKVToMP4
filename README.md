# MKVToMP4
A tool to convert MKV video files to MP4 video files, with the intent of making video editing easier.

Warning: I've found that GPU is only about 2-4x faster in encoding, and it's likely CPU will do a better job of encoding.
Keep this in mind.

## Requirements:
- Nvidia graphics card (You can edit the script to use CPU, use ChatGPT to guide you)
- FFMPEG

To run the program, you can just run the convert.sh and it'll create the input and output folders. Run it again with MKVs in the input folder to convert to mp4.

## Settings

Sadly you do have to edit the script to add or change things, but you can:
- Change the quality and speed (change the -preset flag in the ffmpeg parameters)
- Change GPU to CPU encoding (Use ChatGPT or just rewrite the ffmpeg parameters)
