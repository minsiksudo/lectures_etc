#!/bin/bash

# Usage: ./copy_fastq_files.sh <source_directory> <destination_directory>

# Check if the correct number of arguments is provided
if [ "$#" -ne 2 ]; then
    echo "Usage: $0 <source_directory> <destination_directory>"
    exit 1
fi

# Assign arguments to variables
SOURCE_DIR="$1"
DEST_DIR="$2"
PATTERN="*fastq.gz" # File matching pattern

# Check if source directory exists
if [ ! -d "$SOURCE_DIR" ]; then
    echo "Error: Source directory $SOURCE_DIR does not exist."
    exit 1
fi

# Check if destination directory exists, if not, create it
if [ ! -d "$DEST_DIR" ]; then
    echo "Destination directory $DEST_DIR does not exist. Creating it."
    mkdir -p "$DEST_DIR"
fi

# Find and copy files matching the pattern to the destination directory
find "$SOURCE_DIR" -type f -name "$PATTERN" -exec cp {} "$DEST_DIR" \;

# Print completion message
echo "All files matching $PATTERN have been copied to $DEST_DIR."

# Instructions to run this script on macOS
# 1. Make the script executable: chmod +x copy_fastq_files.sh
# 2. Run the script: ./copy_fastq_files.sh /path/to/source /path/to/destination
