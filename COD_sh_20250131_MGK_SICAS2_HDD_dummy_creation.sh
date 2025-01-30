#!/bin/bash

# Base directory where the dummy structure will be created
BASE_DIR="./Dummy_LaiSICAS"

# Define the main folders
mkdir -p "$BASE_DIR/$RECYCLE.BIN"
mkdir -p "$BASE_DIR/READY_TO_SHIP"
mkdir -p "$BASE_DIR/RawData_WGS"
mkdir -p "$BASE_DIR/System Volume Information"

# Define project folders (from observed structure)
PROJECTS=("p1039" "p1151" "p1152" "p1153" "p1154" "p1272" "p1457" "p1488" "p1532" "p1637" "p1638" "p1861" "p1902" "p854" "p9999" "p9998" "p9997" "p9996" "p9995")

# Extracted file number ranges from uploaded log
PATTERN_RANGES=(
    "1-352" "354-385" "387-445" "447-460" "462-540" "542-551" "553-580" "582-656"
    "658-675" "677-718" "720-755" "757-822" "824-832" "834-834" "836-862" "871-873"
    "875-906" "908-921" "923-926" "928-942" "944-957" "959-984" "986-987" "989-999"
    "1001-1011" "1013-1019" "1021-1049" "1051-1063" "1065-1070" "1072-1106" "1108-1171"
    "1173-1174" "1176-1177" "1181-1183" "1185-1187" "1189-1204" "1206-1209" "1211-1509"
    "1512-1564" "1566-1601" "1604-1638" "1640-1671" "1808-1910" "1912-1947" "1949-1978"
    "1980-2066" "2068-2079" "2081-2105" "2108-2743" "2878-2969" "2972-2973" "3052-3397"
)

# Assign pattern ranges to project folders in a distributed way
for i in "${!PROJECTS[@]}"; do
    PROJECT=${PROJECTS[$i]}
    mkdir -p "$BASE_DIR/RawData_WGS/$PROJECT"
    
    # Distribute ranges evenly among projects
    RANGE_INDEX=$((i * ${#PATTERN_RANGES[@]} / ${#PROJECTS[@]}))
    RANGE_LIMIT=$(((i+1) * ${#PATTERN_RANGES[@]} / ${#PROJECTS[@]}))

    for (( j=RANGE_INDEX; j<RANGE_LIMIT; j++ )); do
        RANGE="${PATTERN_RANGES[$j]}"
        START=${RANGE%-*} # Extract start of range
        END=${RANGE#*-}   # Extract end of range

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

echo "Dummy file structure correctly assigned to each project in $BASE_DIR"
