#!/bin/bash

# Path to the SSH configuration file
configFile="$HOME/.ssh/config"

# ANSI Art for the word SSH
ansiArt="
   _____ _____ _    _ 
  / ____/ ____| |  | |
 | (___| (___ | |__| |
  \\___  \\\\___ \\|  __  |
  ____) |___) | |  | |
 |_____/_____/|_|  |_|
"

# Display the ANSI Art with Cyan color
echo -e "\e[36m$ansiArt\e[0m"  # Cyan color

# Function to parse the configuration file and extract host names
function get_hosts_from_config() {
    local filePath="$1"
    local hosts=()

    # Read the configuration file line by line
    while IFS= read -r line; do
        # Check if the line starts with "Host" and capture the host name
        if [[ $line =~ ^Host[[:space:]]+([^#]+) ]]; then
            hosts+=("${BASH_REMATCH[1]}")
        fi
    done < "$filePath"

    echo "${hosts[@]}"
}

# Get the list of hosts from the configuration file
hosts=$(get_hosts_from_config "$configFile")
hostArray=($hosts)  # Convert the list into an array

# Check if there are any hosts found
if [[ ${#hostArray[@]} -eq 0 ]]; then
    echo "No hosts found in the configuration file."
    exit 1
fi

# Display menu for host selection
echo "Select the server to connect to:"
for i in "${!hostArray[@]}"; do
    echo "$((i + 1)). ${hostArray[$i]}"
done

# Get user input for selecting a host
read -rp "Enter the server number: " selection

# Check if the input is a valid number and within the range
if ! [[ $selection =~ ^[0-9]+$ ]] || (( selection <= 0 || selection > ${#hostArray[@]} )); then
    echo "Invalid selection. Exiting."
    exit 1
fi

# Get the selected host based on user input
selectedHost="${hostArray[$((selection - 1))]}"

# Execute the SSH command to connect to the selected host
ssh "$selectedHost"
