#!/bin/bash

# Check if lit19.conf or lit29.conf exists in /data folder
if [ -f "/data/lit19.conf" ] || [ -f "/data/lit29.conf" ]; then
    echo "Lit configuration file found."
    exit 0
else
    echo "No lit configuration file found."
    read -p "Do you want to configure lit?(Y/n): " response
    
    # Convert response to lowercase and check if it's 'y', 'yes', or empty (default to Y)
    response_lower=$(echo "$response" | tr '[:upper:]' '[:lower:]')
    
    if [ "$response_lower" = "y" ] || [ "$response_lower" = "yes" ] || [ -z "$response" ]; then
        echo "Creating lit19.conf..."
        touch /data/lit19.conf
        echo "lit19.conf created successfully."
    else
        echo "Exiting script."
        exit 0
    fi
fi 