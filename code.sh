#!/bin/bash

# --- CONFIGURATION ---
LICENSE_URL="https://raw.githubusercontent.com/minepaneloffcial-dotcom/project-1/main/license.key"
VM_MAKER_URL="https://raw.githubusercontent.com/minepaneloffcial-dotcom/project-1/refs/heads/main/code.sh"
HOSTNAME_EDITOR_URL="https://raw.githubusercontent.com/minepaneloffcial-dotcom/project-2/refs/heads/main/code.sh"

# Local storage for auto-login
LOCAL_LICENSE_FILE="/root/.tasin_license"

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
MAGENTA='\033[0;35m'
CYAN='\033[0;36m'
WHITE='\033[1;37m'
NC='\033[0m'

# --- FUNCTIONS ---

reset_screen() {
    clear
    echo -e "${NC}"
}

show_logo() {
    echo -e "${CYAN}"
    echo "████████╗░█████╗░░██████╗██╗███╗░░██╗"
    echo "░░░██║░░░███████║╚█████╗░██║██╔██╗██║"
    echo "░░░██║░░░██╔══██║░╚═══██╗██║██║╚████║"
    echo "░░░██║░░░██║░░██║██████╔╝██║██║░╚███║"
    echo "░░░╚═╝░░░╚═╝░░╚═╝╚═════╝░╚═╝╚═╝░░╚══╝"
    echo -e "${YELLOW}              P R E M I U M   D A S H B O A R Dᴹ ᴬ ᴰ ᴱ ᴮ ʸ ᶦᵀᶻᵀᵃˢᶦᴺ⁶⁹"
    echo -e "${NC}"
    echo "-------------------------------------------------------"
}

# FIXED: Function to read input with * masking (Glitch Removed)
read_password() {
    local prompt_text="$1"
    local password=''
    
    # 1. Print the prompt ONCE before the loop starts
    echo -ne "${CYAN}[?] $prompt_text ${NC}"
    
    # 2. Loop to read character by character (NO -p flag here)
    while IFS= read -r -s -n 1 char
    do
        # Check for Enter (empty input)
        if [[ -z $char ]]; then
            echo # Move to new line
            break
        fi
        
        # Check for Backspace (ASCII 127)
        if [[ $char == $'\177' ]]; then
            if [ -n "$password" ]; then
                # Remove last char from variable
                password="${password%?}"
                # Erase the * from screen (Backspace, Space, Backspace)
                printf '\b \b'
            fi
        else
            # Add char to password
            password+="$char"
            # Print *
            printf '*'
        fi
    done
    
    # Return the password
    echo "$password"
}

save_local_license() {
    local key=$1
    local expire=$2
    local limit=$3
    
    cat <<EOF > "$LOCAL_LICENSE_FILE"
KEY=$key
EXPIRE=$expire
LIMIT=$limit
ACTIVATED=1
EOF
    chmod 600 "$LOCAL_LICENSE_FILE"
}

check_local_license() {
    if [ -f "$LOCAL_LICENSE_FILE" ]; then
        source "$LOCAL_LICENSE_FILE"
        local current_date=$(date +%Y-%m-%d)
        
        if [[ "$current_date" > "$EXPIRE" ]]; then
            echo -e "${RED}[!] Local License expired. Removing file...${NC}"
            rm -f "$LOCAL_LICENSE_FILE"
            return 1
        fi
        return 0
    fi
    return 1
}

verify_and_activate() {
    echo -e "${BLUE}[+] Connecting to License Server...${NC}"
    
    RAW_DATA=$(curl -s "$LICENSE_URL")
    
    if [ -z "$RAW_DATA" ]; then
        echo -e "${RED}[!] Error: Could not connect to license server.${NC}"
        exit 1
    fi

    read -r SERVER_KEY EXPIRE_DATE DEVICE_LIMIT <<< "$RAW_DATA"
    CURRENT_DATE=$(date +%Y-%m-%d)

    # 1. Get Input (Fixed Function Call)
    # Pass only the text, let function handle colors
    USER_KEY=$(read_password "Enter License Key")

    # 2. Check Key
    if [ "$(echo -e "$USER_KEY" | tr -d '[:space:]')" != "$(echo -e "$SERVER_KEY" | tr -d '[:space:]')" ]; then
        echo -e "${RED}[X] Invalid License Key!${NC}"
        exit 1
    fi

    # 3. Check Expiry
    if [[ "$CURRENT_DATE" > "$EXPIRE_DATE" ]]; then
        echo -e "${RED}[X] License Expired on $EXPIRE_DATE.${NC}"
        exit 1
    fi

    echo -e "${GREEN}[✔] License Verified Successfully!${NC}"
    echo -e "${YELLOW}[*] Expiry Date: $EXPIRE_DATE${NC}"
    echo -e "${YELLOW}[*] Device Usage: Active (Limit: $DEVICE_LIMIT)${NC}"
    
    save_local_license "$SERVER_KEY" "$EXPIRE_DATE" "$DEVICE_LIMIT"
    sleep 2
}

run_script() {
    local url=$1
    local name=$2
    
    echo -e "${MAGENTA}[*] Downloading $name...${NC}"
    curl -s "$url" -o /tmp/temp_script.sh
    
    if [ -s /tmp/temp_script.sh ]; then
        echo -e "${GREEN}[✔] Running $name...${NC}"
        echo "---------------------------------------------------"
        bash /tmp/temp_script.sh
        echo "---------------------------------------------------"
        echo -e "${YELLOW}[*] Script Finished.${NC}"
    else
        echo -e "${RED}[!] Failed to download script.${NC}"
    fi
    
    rm -f /tmp/temp_script.sh
    echo -e "${NC}"
    read -p "Press Enter to return to dashboard..."
}

# --- MAIN PROGRAM ---
reset_screen
show_logo

if check_local_license; then
    source "$LOCAL_LICENSE_FILE"
    echo -e "${GREEN}[✔] Auto-Login Success! Welcome back.${NC}"
    echo -e "${YELLOW}[*] License valid until: $EXPIRE | Limit: $LIMIT${NC}"
    sleep 2
else
    verify_and_activate
fi

while true; do
    reset_screen
    show_logo
    
    echo -e "${GREEN}Welcome to iTzTasin69 premium Code Deashbord${NC}"
    echo ""

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
