#!/bin/bash

# Check if the correct number of arguments is provided
if [ $# -ne 1 ]; then
    echo "Usage: $0 <prefix> (prefix must be more than 5 characters)"
    exit 1
fi

PREFIX="$1"

# Check if the prefix is larger than 5 characters
if [ ${#PREFIX} -le 5 ]; then
    echo "Error: The prefix must be longer than 5 characters."
    exit 1
fi

# Confirm the deletion process
read -p "Are you sure you want to remove all users starting with '$PREFIX'? (yes/no) " confirmation
if [ "$confirmation" != "yes" ]; then
    echo "Aborting."
    exit 1
fi

# Get all users that start with the specified prefix
for user in $(getent passwd | grep "^$PREFIX" | cut -d: -f1); do
    # Delete the user and their home directory
    sudo userdel -r "$user"
    
    if [ $? -eq 0 ]; then
        echo "User $user has been deleted."
    else
        echo "Failed to delete user $user."
    fi
done
