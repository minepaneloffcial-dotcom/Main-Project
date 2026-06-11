#!/bin/bash

# --- CONFIGURATION ---
# URLs
LICENSE_URL="https://raw.githubusercontent.com/minepaneloffcial-dotcom/project-1/main/license.key"
VM_MAKER_URL="https://raw.githubusercontent.com/minepaneloffcial-dotcom/project-1/refs/heads/main/code.sh"
HOSTNAME_EDITOR_URL="https://raw.githubusercontent.com/minepaneloffcial-dotcom/project-2/refs/heads/main/code.sh"

# Colors (Gradient Effect Simulation)
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
MAGENTA='\033[0;35m'
CYAN='\033[0;36m'
WHITE='\033[1;37m'
NC='\033[0m' # No Color

# --- FUNCTIONS ---

# Function to clear screen and reset colors
reset_screen() {
    clear
    echo -e "${NC}"
}

# Function to show Big TASIN Text with "Gradient" colors
show_logo() {
    echo -e "${CYAN}"
    echo "  _____  _____          _____   ____   _____ "
    echo " /  _  \/  ___|  /\    |  _  \ |  _ \ |  _  |"
    echo " | | | |\___ \ /  \   | | | || | | || | | |"
    echo " | |_| | ___) / /\ \  | |_| || |_| || |_| |"
    echo " \_____/ \____/__/  \__\_____/ \____/ \_____/ "
    echo -e "${YELLOW}              P R E M I U M   D A S H B O A R D ${NC}"
    echo "-------------------------------------------------------"
}

# Animation function (Loading Bar)
loading_animation() {
    local pid=$!
    local delay=0.1
    local spinstr='|/-\'
    while [ "$(ps a | awk '{print $1}' | grep $pid)" ]; do
        local temp=${spinstr#?}
        printf " [%c]  " "$spinstr"
        local spinstr=$temp${spinstr%"$temp"}
        sleep $delay
        printf "\b\b\b\b\b\b"
    done
    printf "    \b\b\b\b"
}

# License Check Function
check_license() {
    echo -e "${BLUE}[+] Checking License Server...${NC}"
    
    # Fetch the key from GitHub
    SERVER_KEY=$(curl -s "$LICENSE_URL")
    
    if [ -z "$SERVER_KEY" ]; then
        echo -e "${RED}[!] Error: Could not connect to license server.${NC}"
        exit 1
    fi

    echo -ne "${CYAN}[?] Please Enter License Key: ${NC}"
    read -s USER_KEY
    echo ""

    # Compare input with server key (trim whitespace just in case)
    if [ "$(echo -e "$USER_KEY" | tr -d '[:space:]')" == "$(echo -e "$SERVER_KEY" | tr -d '[:space:]')" ]; then
        echo -e "${GREEN}[✔] License Verified Successfully!${NC}"
        sleep 1
    else
        echo -e "${RED}[X] Invalid License Key! Access Denied.${NC}"
        exit 1
    fi
}

# Function to download and run a script
run_script() {
    local url=$1
    local name=$2
    
    echo -e "${MAGENTA}[*] Downloading $name...${NC}"
    
    # Download to a temp file
    curl -s "$url" -o /tmp/temp_script.sh
    
    if [ -s /tmp/temp_script.sh ]; then
        echo -e "${GREEN}[✔] Download Complete. Running $name...${NC}"
        echo "---------------------------------------------------"
        # Execute the script
        bash /tmp/temp_script.sh
        echo "---------------------------------------------------"
        echo -e "${YELLOW}[*] Script Finished.${NC}"
    else
        echo -e "${RED}[!] Failed to download script. Check URL.${NC}"
    fi
    
    # Clean up
    rm -f /tmp/temp_script.sh
    
    echo -e "${NC}"
    read -p "Press Enter to return to dashboard..."
}

# --- MAIN PROGRAM START ---
reset_screen

# Show Logo
show_logo

# Step 1: License Check
check_license

# Step 2: Main Loop
while true; do
    reset_screen
    show_logo
    
    # Welcome Message
    echo -e "${GREEN}"
    echo "Welcome to iTzTasin69 premium Code Deashbord"
    echo -e "${NC}"
    echo ""

    # Menu Options
    echo -e "${WHITE}[1]${CYAN} Premium VM Maker${NC}"
    echo -e "${WHITE}[2]${CYAN} Premium Hostname Editor${NC}"
    echo -e "${WHITE}[3]${RED} Exit${NC}"
    echo ""
    echo -ne "${YELLOW}Select an option [1-3]: ${NC}"
    
    read choice

    case $choice in
        1)
            run_script "$VM_MAKER_URL" "Premium VM Maker"
            ;;
        2)
            run_script "$HOSTNAME_EDITOR_URL" "Premium Hostname Editor"
            ;;
        3)
            echo -e "${RED}Exiting... Goodbye!${NC}"
            exit 0
            ;;
        *)
            echo -e "${RED}Invalid option. Please try again.${NC}"
            sleep 1
            ;;
    esac
done
