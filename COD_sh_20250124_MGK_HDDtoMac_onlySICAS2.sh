#!/bin/bash
# This code is available online at https://github.com/minsiksudo/lectures_etc/blob/main/COD_sh_20250124_MGK_copy_SICAS2_files_HDDtoMacmini.sh
# Usage: ./COD_sh_MGK_SICAS2_copy_batylor_files_tidy.sh <source_HDD> <destination_directory>

#!/bin/bash

# Usage: ./copy_specific_files.sh <source_directory> <destination_directory>

# Check if the correct number of arguments is provided
if [ "$#" -ne 2 ]; then
    echo "Usage: $0 <source_directory> <destination_directory>"
    exit 1
fi

# Assign arguments to variables
SOURCE_DIR="$1"
DEST_DIR="$2"

# Define the range of patterns
PATTERN_RANGES=(
    "354-385" "387-460" "462-551" "553-580" "582-862" "871-918" "928-2132"
)

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

# Expand ranges into individual patterns and copy matching files
for RANGE in "${PATTERN_RANGES[@]}"; do
    START=${RANGE%-*} # Extract start of range
    END=${RANGE#*-}  # Extract end of range

    for ((PATTERN=START; PATTERN<=END; PATTERN++)); do
        echo "Searching for files matching pattern: *${PATTERN}*"
        SUBDIR_PATTERN=$(find "$SOURCE_DIR" -type d -name "*$PATTERN")

        for SUBDIR in $SUBDIR_PATTERN; do
            echo "Searching in subdirectory: $SUBDIR"
            find "$SUBDIR" -type f -name "*_R*.fastq.gz" -exec cp {} "$DEST_DIR" \;
        done
    done
done

# Print completion message
echo "All matching files have been copied to $DEST_DIR."

# Instructions to run this script on macOS
# 1. Make the script executable: chmod +x copy_fastq_files.sh
# 2. Run the script: ./copy_fastq_files.sh /path/to/source /path/to/destination
