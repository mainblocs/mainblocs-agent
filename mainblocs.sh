#!/bin/bash

# Check for jq (JSON parser)
command -v jq >/dev/null 2>&1 || {
    echo "Please install 'jq' - a command-line JSON parser."
    exit 1
}

# Create directory and download the installation script
curl -sSL https://raw.githubusercontent.com/YOUR_USERNAME/YOUR_REPO/main/install.sh -o install.sh

# Create or modify the JSON
JSON_FILE="./config.json"
[ ! -f $JSON_FILE ] && echo '{}' > $JSON_FILE

# Add data to JSON
jq '.web_url = "YOUR_WEB_URL"' $JSON_FILE > tmp.$$.json && mv tmp.$$.json $JSON_FILE
# Add more key-values as required

if [ "$1" == "list" ]; then
    cat $JSON_FILE
    exit 0
fi

# Check for Svelte project creation and npm installations
cd ~/mainblocs

# Using npx to set up Svelte
npx create-svelte@next web-app

cd web-app
npm install
npm run dev