#!/bin/bash

# --- CONFIGURATION ---
# URLs
LICENSE_URL="https://raw.githubusercontent.com/minepaneloffcial-dotcom/project-1/main/license.key"
VM_MAKER_URL="https://raw.githubusercontent.com/minepaneloffcial-dotcom/project-1/refs/heads/main/code.sh"
HOSTNAME_EDITOR_URL="https://raw.githubusercontent.com/minepaneloffcial-dotcom/project-2/refs/heads/main/code.sh"

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
MAGENTA='\033[0;35m'
CYAN='\033[0;36m'
WHITE='\033[1;37m'
NC='\033[0m' # No Color

# License Saver File
SAVER_FILE="license_deta_saver.txt"

# --- FUNCTIONS ---

reset_screen() {
    clear
    echo -e "${NC}"
}

# Big TASIN Text
show_logo() {
    echo -e "${CYAN}"
    echo "  _____  _____  _____  _____  _____ "
    echo " /  _  \/  _  \/  ___>|     \|     |"
    echo " | |_| || |_| ||___  ||     ||     |"
    echo " \_____/ \_____/ <_____\_____/|_____|"
    echo -e "${NC}"
    echo "-------------------------------------------------------"
}

check_license() {
    echo -e "${BLUE}[+] Connecting to License Server...${NC}"
    
    # Fetch raw data
    RAW_DATA=$(curl -s "$LICENSE_URL")
    
    if [ -z "$RAW_DATA" ]; then
        echo -e "${RED}[!] Error: Could not connect to license server or file is empty.${NC}"
        exit 1
    fi

    # Parse the data (Format: KEY EXPIRE_DATE LIMIT)
    read -r SERVER_KEY EXPIRE_DATE DEVICE_LIMIT <<< "$RAW_DATA"

    # Get current date in YYYY-MM-DD format
    CURRENT_DATE=$(date +%Y-%m-%d)

    echo -ne "${CYAN}[?] Enter License Key: ${NC}"
    read -s USER_KEY
    echo ""
    
    # 1. Check if Key Matches
    if [ "$(echo -e "$USER_KEY" | tr -d '[:space:]')" != "$(echo -e "$SERVER_KEY" | tr -d '[:space:]')" ]; then
        echo -e "${RED}[X] Invalid License Key! Access Denied.${NC}"
        exit 1
    fi

    # 2. Check Expiry Date
    if [[ "$CURRENT_DATE" > "$EXPIRE_DATE" ]]; then
        echo -e "${RED}[X] License Expired on $EXPIRE_DATE. Please renew.${NC}"
        exit 1
    fi

    echo -e "${GREEN}[✔] License Verified!${NC}"
    echo -e "${YELLOW}[*] Expiry Date: $EXPIRE_DATE${NC}"
    echo -e "${YELLOW}[*] Device Limit: $DEVICE_LIMIT${NC}"
    
    save_license_details "$SERVER_KEY" "$EXPIRE_DATE" "$DEVICE_LIMIT"
    
    sleep 2
}

# Function to Save VPS Details
save_license_details() {
    local key=$1
    local expire=$2
    local limit=$3
    
    # Get VPS Info
    local ip=$(hostname -I | awk '{print $1}')
    local hostname=$(hostname)
    local current_time=$(date)

    echo -e "${MAGENTA}[*] Saving VPS License Details...${NC}"
    
    cat <<EOF > $SAVER_FILE
========================================
    iTzTasin69 PREMIUM LICENSE DATA
========================================
LICENSE KEY     : $key
EXPIRE DATE     : $expire
DEVICE LIMIT    : $limit
----------------------------------------
VPS IP ADDRESS  : $ip
VPS HOSTNAME    : $hostname
ACTIVATED ON    : $current_time
STATUS          : ACTIVE
========================================
EOF
    echo -e "${GREEN}[✔] License Data Saved to '$SAVER_FILE'${NC}"
    sleep 1
}

run_script() {
    local url=$1
    local name=$2
    
    echo -e "${MAGENTA}[*] Downloading $name...${NC}"
    
    curl -s "$url" -o /tmp/temp_script.sh
    
    if [ -s /tmp/temp_script.sh ]; then
        echo -e "${GREEN}[✔] Download Complete. Running $name...${NC}"
        echo "---------------------------------------------------"
        bash /tmp/temp_script.sh
        echo "---------------------------------------------------"
        echo -e "${YELLOW}[*] Script Finished.${NC}"
    else
        echo -e "${RED}[!] Failed to download script. Check URL.${NC}"
    fi
    
    rm -f /tmp/temp_script.sh
    
    echo -e "${NC}"
    read -p "Press Enter to return to dashboard..."
}

# --- MAIN PROGRAM ---
reset_screen
show_logo

# Step 1: License Check
check_license

# Step 2: Main Loop
while true; do
    reset_screen
    show_logo
    
    # Welcome Message
    echo -e "${GREEN}Welcome to iTzTasin69 premium Code Deashbord${NC}"
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
