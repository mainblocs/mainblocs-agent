#!/bin/bash

# Detecting OS
OS="$(uname)"

if [ "$OS" == "Linux" ]; then
    # Detecting Linux Distribution
    if [ -f /etc/os-release ]; then
        . /etc/os-release
        DISTRO=$ID
    fi

    if [ "$DISTRO" == "ubuntu" ] || [ "$DISTRO" == "debian" ]; then
        sudo apt update
        sudo apt install -y nodejs npm git
    elif [ "$DISTRO" == "centos" ] || [ "$DISTRO" == "rhel" ] || [ "$DISTRO" == "fedora" ]; then
        sudo yum install -y nodejs npm git
    else
        echo "Unsupported Linux distribution"
    fi
elif [ "$OS" == "Darwin" ]; then
    if ! command -v brew &>/dev/null; then
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    fi
    brew install node git
elif [[ "$OS" == "MINGW"* ]] || [[ "$OS" == "MSYS"* ]]; then
    # This will run if the script is executed in Git Bash or similar terminal on Windows.
    powershell.exe -NoProfile -ExecutionPolicy Bypass -Command "Set-ExecutionPolicy Bypass -Scope Process -Force; iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))"
    choco install -y nodejs git
else
    echo "Unsupported operating system"
fi
WEB_APP_PATH="$(pwd)/web-app"
mkdir -p "$WEB_APP_PATH"

# Store other variables you may have; this is just a placeholder.
# OTHER_VAR="example"

# Check if the user wants to list variables
if [ "$1" == "list" ]; then
    echo "WEB_APP_PATH=$WEB_APP_PATH"
    # echo "OTHER_VAR=$OTHER_VAR"
    exit 0
fi