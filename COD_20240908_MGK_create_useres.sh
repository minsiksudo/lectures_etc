#!/bin/bash
INPUT="2024Fbiostatistics_users.txt" # The file that contains the list of usernames

while IFS= read -r username; do
    # Create the user with the home directory and default shell
    sudo useradd -m "$username" -s /bin/bash
    
    # Set the password to be the same as the username
    echo "$username:$username" | sudo chpasswd

    echo "User $username added with password $username."
done < "$INPUT"
