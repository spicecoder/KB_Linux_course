#!/bin/bash

# Greet the user by their username
username=$(whoami)
echo "Hello, $username! Where would you like to work today?"

# Ask for the directory name
read -p "Enter the directory name: " dir_name

# Find all matching directories (case-sensitive)
matches=$(find ~ -type d -name "*$dir_name*" 2>/dev/null)

# If no matches, exit
if [ -z "$matches" ]; then
    echo "No directories found matching '$dir_name'."
    exit 1
fi

# Split the matches into an array
IFS=$'\n' read -rd '' -a matches_array <<< "$matches"

# Let the user select a directory
echo "Select a directory:"
select selected_dir in "${matches_array[@]}"; do
    if [ -n "$selected_dir" ]; then
        echo "Changing directory to: $selected_dir"
        cd "$selected_dir"
        break
    else
        echo "Invalid selection. Please try again."
    fi
done