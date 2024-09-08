#!/bin/bash

# Check if the correct number of arguments is provided
if [ $# -ne 1 ]; then
    echo "Usage: $0 /path/to/user_file"
    exit 1
fi

INPUT="$1" # The file path provided as an argument

# Check if the file exists
if [ ! -f "$INPUT" ]; then
    echo "File $INPUT not found!"
    exit 1
fi

# Read through the file and create users
while IFS= read -r user_id; do
    username="$user_id" # Prefixing with "user_"
    
    # Create the user with home directory and default shell
    sudo useradd -m "$username" -s /bin/bash
    
    # Set the password to be the same as the username
    echo "$username:$username" | sudo chpasswd

    echo "User $username added with password $username."
done < "$INPUT"
