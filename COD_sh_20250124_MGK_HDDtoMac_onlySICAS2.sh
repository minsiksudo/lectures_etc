#!/bin/bash
# This code is available online at https://github.com/minsiksudo/lectures_etc/blob/main/COD_sh_20250124_MGK_HDDtoMac_onlySICAS2.sh
# This code recognizes which file is SICAS2 dust raw sequencing files (by baylor ID), and will copy all the SICAS2 dust files from a given path of <source_HDD>.
# For path for the inpuyt, both <source_HDD> and <source_HDD>/<your_sub_directory> can be used. 
## For example
# Usage 1, copying whole drive: ./COD_sh_MGK_SICAS2_copy_batylor_files_tidy.sh <source_HDD> <destination_directory>
# Usage 2, copying a subdirectory: ./COD_sh_MGK_SICAS2_copy_batylor_files_tidy.sh <source_HDD>/<your_sub_directory> <destination_directory>

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
    "354-385" "387-460" "462-551" "553-580" "582-862" "871-926" "928-1019" "1021-1049" "1051-1106" "1108-1204" "1206-1267" "1269-1290" "1292-1362" "1364-1382" "2013-2066" "2068-2079" "2081-2105" "2110-2119" "2123-2132"
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
        echo "Searching for files matching pattern: *_${PATTERN}_R*.fastq.gz"
        
        # Find subdirectories that match the exact pattern
        SUBDIR_PATTERN=$(find "$SOURCE_DIR" -type d -regex ".*/[0-9]*$PATTERN[^0-9]*$")

        for SUBDIR in $SUBDIR_PATTERN; do
            echo "Searching in subdirectory: $SUBDIR"
            
            # Use a stricter regex pattern to avoid incorrect partial matches
            find "$SUBDIR" -type f -regex ".*_${PATTERN}_R[12]\.fastq\.gz$" -print0 | xargs -0 cp -t "$DEST_DIR"
        done
    done
done

# Print completion message
echo "All matching files have been copied to $DEST_DIR."
