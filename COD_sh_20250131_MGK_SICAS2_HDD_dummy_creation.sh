#!/bin/bash

# Base directory where the dummy structure will be created
BASE_DIR="./Dummy_LaiSICAS"

# Define the main folders
mkdir -p "$BASE_DIR/$RECYCLE.BIN"
mkdir -p "$BASE_DIR/READY_TO_SHIP"
mkdir -p "$BASE_DIR/RawData_WGS"
mkdir -p "$BASE_DIR/System Volume Information"

# Corrected project-to-range mapping extracted from log file
declare -A PROJECT_RANGES
PROJECT_RANGES["p1039"]="1-352"
PROJECT_RANGES["p1151"]="354-385 387-445 447-449 455-460"
PROJECT_RANGES["p1152"]="462-540 542-551 553-580"
PROJECT_RANGES["p1153"]="582-656 658-675 677-718 720-755"
PROJECT_RANGES["p1154"]="757-822 824-832 834-834 836-862"
PROJECT_RANGES["p1272"]="871-873 875-906 908-921 923-926"
PROJECT_RANGES["p1457"]="928-942 944-957 959-984 986-987"
PROJECT_RANGES["p1488"]="989-999 1001-1011 1013-1019 1021-1049"
PROJECT_RANGES["p1532"]="1051-1063 1065-1070 1072-1106 1108-1171"
PROJECT_RANGES["p1637"]="1173-1174 1176-1177 1181-1183 1185-1187 1189-1204"
PROJECT_RANGES["p1638"]="1206-1209 1211-1509 1512-1564 1566-1601"
PROJECT_RANGES["p1861"]="1604-1638 1640-1671 1808-1910"
PROJECT_RANGES["p1902"]="1912-1947 1949-1978 1980-2066"
PROJECT_RANGES["p854"]="2068-2079 2081-2105 2108-2743 2878-2969 2972-2973 3052-3397"

# Create files based on the correct mapping
for PROJECT in "${!PROJECT_RANGES[@]}"; do
    mkdir -p "$BASE_DIR/RawData_WGS/$PROJECT"

    # Get the assigned ranges for this project
    for RANGE in ${PROJECT_RANGES[$PROJECT]}; do
        START=${RANGE%-*}  # Extract start of range
        END=${RANGE#*-}    # Extract end of range

        for ((NUM=START; NUM<=END; NUM++)); do
            DIR_PATH="$BASE_DIR/RawData_WGS/$PROJECT/$NUM"
            mkdir -p "$DIR_PATH"

            # Create dummy fastq.gz files
            touch "$DIR_PATH/${NUM}_R1.fastq.gz"
            touch "$DIR_PATH/${NUM}_R2.fastq.gz"

            # Create a dummy md5 checksum file
            echo "${NUM}_R1.fastq.gz md5checksum" > "$DIR_PATH/md5sum.txt"
            echo "${NUM}_R2.fastq.gz md5checksum" >> "$DIR_PATH/md5sum.txt"
        done
    done
done

echo "Correct dummy file structure created at $BASE_DIR"
