#!/bin/bash

case "$(uname -s)" in
   Darwin) 
       # MacOS
       curl -sSL https://raw.githubusercontent.com/mainblocs/mainblocs-agent/main/install.sh -o install.sh
       bash ./install.sh
       ;;
   Linux) 
       # Linux
       curl -sSL https://raw.githubusercontent.com/mainblocs/mainblocs-agent/main/install.sh -o install.sh
       bash ./install.sh
       ;;
   CYGWIN*|MINGW32*|MSYS*|MINGW*) 
       # Windows
       curl -sSL https://raw.githubusercontent.com/mainblocs/mainblocs-agent/main/install.ps1 -o install.ps1
       ;;
       powershell.exe -ExecutionPolicy Bypass -File .\install.ps1
   *) 
       # Unknown OS
       echo "Unknown operating system"
       ;;
esac

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