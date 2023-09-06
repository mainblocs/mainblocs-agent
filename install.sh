#!/bin/bash
# For Linux
install_package_manager_on_linux() {
    if [ -f /etc/os-release ]; then
        . /etc/os-release
        case $ID in
            debian|ubuntu)
                # APT is generally pre-installed on these distros
                sudo apt-get update
            ;;
            centos|rhel)
                # YUM is generally pre-installed on these distros
                sudo yum check-update
            ;;
            fedora)
                if ! command -v dnf &> /dev/null; then
                    sudo yum install -y dnf
                fi
            ;;
            *)
                echo "Unsupported Linux distribution. Exiting..."
                exit 1
            ;;
        esac
    else
        echo "Unsupported Linux distribution. Exiting..."
        exit 1
    fi
}

# For MacOS
install_package_manager_on_mac() {
    if ! which brew; then
        echo "Brew not found. Installing..."
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    else
        echo "Brew is already installed."
    fi
}

# For Windows
install_package_manager_on_windows() {
    if ! command -v choco; then
        echo "Chocolatey not found. Installing..."
    else
        echo "Chocolatey is already installed."
        # Running the PowerShell script
        powershell.exe -ExecutionPolicy Bypass -File ./install.ps1
    fi
}

# Check based on the OS
case $(uname) in
    "Linux")
        install_package_manager_on_linux
        if ! command -v curl &> /dev/null; then
            sudo apt-get install -y curl || sudo yum install -y curl || sudo dnf install -y curl
        fi
    ;;
    "Darwin") # MacOS
        install_package_manager_on_mac
        if ! command -v curl; then
            brew install curl
        else 
            echo "Curl is already installed."
        fi
    ;;
    "Windows_NT") # Windows
        install_package_manager_on_windows
        if ! command -v curl &> /dev/null; then
            choco install curl
        fi
    ;;
    *)
        echo "Unsupported OS. Exiting..."
        exit 1
    ;;
esac


#!/bin/bash

# Initialize the version variables
NODE_VERSION="not installed"
NPM_VERSION="not installed"
GIT_VERSION="not installed"
JQ_VERSION="not installed"

# Check and install Node
if ! command -v node > /dev/null 2>&1; then
    echo "Node is not installed. Installing..."
    case "$(uname -s)" in
       Darwin)
           brew install node
           ;;
       Linux)
           sudo apt-get install -y nodejs
           ;;
       CYGWIN*|MINGW32*|MSYS*|MINGW*)
           choco install nodejs
           ;;
    esac
    NODE_VERSION=$(node -v)
else
    NODE_VERSION=$(node -v)
    echo "Node version: $NODE_VERSION"
fi

# Check for npm (though it typically comes with Node)
if ! command -v npm > /dev/null 2>&1; then
    echo "npm is not installed. Installing..."
    case "$(uname -s)" in
       Darwin)
           brew install npm
           ;;
       Linux)
           sudo apt-get install -y npm
           ;;
       CYGWIN*|MINGW32*|MSYS*|MINGW*)
           choco install npm
           ;;
    esac
    NPM_VERSION=$(npm -v)
else
    NPM_VERSION=$(npm -v)
    echo "npm version: $NPM_VERSION"
fi

# Check and install Git
if ! command -v git > /dev/null 2>&1; then
    echo "Git is not installed. Installing..."
    case "$(uname -s)" in
       Darwin)
           brew install git
           ;;
       Linux)
           sudo apt-get install -y git
           ;;
       CYGWIN*|MINGW32*|MSYS*|MINGW*)
           choco install git
           ;;
    esac
    GIT_VERSION=$(git --version | awk '{print $3}')
else
    GIT_VERSION=$(git --version | awk '{print $3}')
    echo "Git version: $GIT_VERSION"
fi
# Check and install jq
if ! command -v jq > /dev/null 2>&1; then
    echo "jq (JSON parser) is not installed. Installing..."
    case "$(uname -s)" in
       Darwin)
           brew install jq
           ;;
       Linux)
           sudo apt-get install -y jq
           ;;
       CYGWIN*|MINGW32*|MSYS*|MINGW*)
           choco install jq
           ;;
    esac
        JQ_VERSION=$(jq --version)
        JQ_VERSION=$(jq --version | cut -d "-" -f2)
        echo "jq version: $JQ_VERSION"
else
    JQ_VERSION=$(jq --version)
    JQ_VERSION=$(jq --version | cut -d "-" -f2)
    echo "jq version: $JQ_VERSION"
fi

# Write versions to a JSON file
echo "{\"node\": \"$NODE_VERSION\", \"npm\": \"$NPM_VERSION\", \"git\": \"$GIT_VERSION\", \"jq\": \"$JQ_VERSION\"}" > config.json
