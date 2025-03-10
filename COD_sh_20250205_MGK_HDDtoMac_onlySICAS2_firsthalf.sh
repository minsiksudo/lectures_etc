#!/bin/bash
# This code is available online at https://github.com/minsiksudo/lectures_etc/blob/main/COD_sh_20250205_MGK_HDDtoMac_onlySICAS2_fisthalf.sh
# This code recognizes which file is SICAS2 dust raw sequencing files (by baylor ID), and will copy all the SICAS2 dust files from a given path of <source_HDD>.
# For path for the inpuyt, both <source_HDD> and <source_HDD>/<your_sub_directory> can be used. 
## For example
# Usage 1, copying whole drive: ./COD_sh_MGK_SICAS2_copy_batylor_files_tidy.sh <source_HDD> <destination_directory>
# Usage 2, copying a subdirectory: ./COD_sh_MGK_SICAS2_copy_batylor_files_tidy.sh <source_HDD>/<your_sub_directory> <destination_directory>
#!/bin/bash

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
    "354-385" "387-460" "462-551" "553-580" "582-862"
    "871-926" "928-932"
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
        echo "Searching for files with pattern: ${PATTERN}_R[12].fastq.gz"

        # Find subdirectories that match the exact pattern
        SUBDIRS=$(find "$SOURCE_DIR" -type d -regex ".*/[0-9]*${PATTERN}[^0-9]*$")
        
        for SUBDIR in $SUBDIRS; do
            echo "Searching in subdirectory: $SUBDIR"

            # Log found files before copying
            FILES_FOUND=$(find "$SUBDIR" -type f -regex ".*/${PATTERN}_R[12]\.fastq\.gz$")
            
            if [[ -n "$FILES_FOUND" ]]; then
                echo "Found files:"
                echo "$FILES_FOUND"

                # Copy only the correctly matched files if they don't already exist in the destination directory or sizes differ
                while IFS= read -r FILE; do
                    BASENAME=$(basename "$FILE")
                    DEST_FILE="$DEST_DIR/$BASENAME"
                    
                    if [ -f "$DEST_FILE" ]; then
                        SRC_SIZE=$(stat --printf="%s" "$FILE")
                        DEST_SIZE=$(stat --printf="%s" "$DEST_FILE")
                        
                        if [ "$SRC_SIZE" -eq "$DEST_SIZE" ]; then
                            echo "File $DEST_FILE already exists and sizes match. Skipping."
                            continue
                        else
                            echo "File $DEST_FILE exists but sizes differ. Recopying."
                        fi
                    fi
                    
                    echo "Copying $FILE to $DEST_FILE"
                    cp "$FILE" "$DEST_FILE"
                done <<< "$FILES_FOUND"
            else
                echo "No matching files found in $SUBDIR"
            fi
        done
    done
done

# Print completion message
echo "All matching files have been copied to $DEST_DIR."
