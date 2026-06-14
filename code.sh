#!/bin/bash

# ==========================================
# CONFIGURATION
# ==========================================
LICENSE_URL="https://raw.githubusercontent.com/minepaneloffcial-dotcom/project-1/main/license.key"
VM_MAKER_URL="https://raw.githubusercontent.com/minepaneloffcial-dotcom/project-1/refs/heads/main/code.sh"
HOSTNAME_EDITOR_URL="https://raw.githubusercontent.com/minepaneloffcial-dotcom/project-2/refs/heads/main/code.sh"
CRYZONBOT_URL="https://raw.githubusercontent.com/minepaneloffcial-dotcom/project-3/refs/heads/main/code.py"
LOCAL_LICENSE_FILE="/root/.tasin_license"

# ==========================================
# COLORS
# ==========================================
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
MAGENTA='\033[0;35m'
CYAN='\033[0;36m'
BOLD='\033[1m'
NC='\033[0m'

# ==========================================
# ANIMATION FUNCTIONS
# ==========================================

# Typewriter effect
type_text() {
    local text="$1"
    local color="$2"
    local delay=0.02
    for (( i=0; i<${#text}; i++ )); do
        echo -ne "${color}${text:$i:1}${NC}"
        sleep $delay
    done
    echo ""
}

# Boot Animation
boot_animation() {
    clear
    echo -e "${CYAN}"
    echo "┌────────────────────────────────────────────────────┐"
    echo "│           iTzTasin69 SYSTEM BOOT v2.0               │"
    echo "└────────────────────────────────────────────────────┘"
    echo ""
    
    local steps=("Initializing Core Modules..." "Loading UI Assets..." "Checking Network..." "Verifying Security...")
    
    for step in "${steps[@]}"; do
        echo -ne "   ${YELLOW}●${NC} $step"
        sleep 0.5
        echo -ne "\r   ${GREEN}✔${NC} $step \n"
        sleep 0.1
    done
    echo ""
}

# ==========================================
# CORE FUNCTIONS
# ==========================================

reset_ui() {
    clear
    echo -ne "\033]0;iTzTasin69 Dashboard\007"
}

# Gradient Text Generator
print_gradient() {
    local text="$1"
    local len=${#text}
    local colors=("31" "33" "32" "36" "34" "35")
    for (( i=0; i<len; i++ )); do
        color_index=$(( (i % 6) ))
        echo -ne "\033[0;3${colors[$color_index]}m${text:i:1}"
    done
    echo -e "${NC}"
}

show_logo() {
    echo ""
    echo -e "${CYAN}████████╗░█████╗░░██████╗██╗███╗░░██╗${NC}"
    echo -e "${BLUE}░░░██║░░░███████║╚█████╗░██║██╔██╗██║${NC}"
    echo -e "${MAGENTA}░░░██║░░░██╔══██║░╚═══██╗██║██║╚████║${NC}"
    echo -e "${MAGENTA}░░░██║░░░██║░░██║██████╔╝██║██║░╚███║${NC}"
    echo -e "${RED}░░░╚═╝░░░╚═╝░░╚═╝╚═════╝░╚═╝╚═╝░░╚══╝${NC}"
    
    local footer="P R E M I U M   D A S H B O A R Dᴹ ᴬ ᴰ ᴱ ᴮ ʸ ᶦᵀᶻᵀᵃˢᶦᴺ⁶⁹"
    printf "%*s\n" $(( (${#footer} + 80) / 2)) "$(print_gradient "$footer")"
    echo "-------------------------------------------------------"
    echo ""
}

save_license() {
    cat <<EOF > "$LOCAL_LICENSE_FILE"
KEY=$1
EXPIRE=$2
LIMIT=$3
ACTIVATED=1
EOF
    chmod 600 "$LOCAL_LICENSE_FILE" > /dev/null 2>&1
}

check_local_license() {
    if [ -f "$LOCAL_LICENSE_FILE" ]; then
        source "$LOCAL_LICENSE_FILE"
        local current_date=$(date +%Y-%m-%d)
        if [[ "$current_date" > "$EXPIRE" ]]; then
            rm -f "$LOCAL_LICENSE_FILE"
            return 1
        fi
        return 0
    fi
    return 1
}

# Enhanced Script Runner (Supports .py and .sh)
run_script() {
    local url=$1
    local name=$2
    
    # Determine file extension
    local ext="${url##*.}"
    local filename="/tmp/temp_script.$ext"

    echo -e "${BLUE}⏳ Downloading ${name}...${NC}"
    
    if curl -s -L "$url" -o "$filename"; then
        echo -e "${GREEN}✔ Download Complete.${NC}"
        echo "────────────────────────────────────────────────────"
        
        # Execute based on extension
        if [ "$ext" == "py" ]; then
            if command -v python3 &> /dev/null; then
                python3 "$filename"
            else
                echo -e "${RED}✗ Python3 is not installed on this system.${NC}"
            fi
        else
            bash "$filename"
        fi
        
        echo "────────────────────────────────────────────────────"
        echo -e "${YELLOW}✔ Execution Finished.${NC}"
    else
        echo -e "${RED}✗ Failed to download script. Check URL/Internet.${NC}"
    fi
    rm -f "$filename"
    echo ""
    read -p "Press [Enter] to return to dashboard..."
}

# ==========================================
# MAIN LOGIC
# ==========================================

boot_animation

# Check for saved license
if check_local_license; then
    source "$LOCAL_LICENSE_FILE"
    reset_ui
    show_logo
    echo -e "${GREEN}✔ Auto-Login Successful.${NC}"
    echo -e "${CYAN}  Key: ${KEY:0:5}...${NC} | ${YELLOW}Expire: $EXPIRE${NC}"
    sleep 2
else
    # Manual Login
    reset_ui
    show_logo
    echo -e "${BLUE}🔗 Connecting to License Server...${NC}"
    RAW_DATA=$(curl -s "$LICENSE_URL")

    if [ -z "$RAW_DATA" ]; then
        echo -e "${RED}✗ Connection failed. Check internet.${NC}"
        exit 1
    fi

    read -r SERVER_KEY EXPIRE_DATE DEVICE_LIMIT <<< "$RAW_DATA"
    CURRENT_DATE=$(date +%Y-%m-%d)

    echo -ne "${CYAN}🔑 Enter License Key: ${NC}"
    read -s USER_KEY
    echo ""

    if [ "$(echo "$USER_KEY" | tr -d '[:space:]')" != "$(echo "$SERVER_KEY" | tr -d '[:space:]')" ]; then
        echo -e "${RED}✗ Invalid License Key.${NC}"
        exit 1
    fi

    if [[ "$CURRENT_DATE" > "$EXPIRE_DATE" ]]; then
        echo -e "${RED}✗ License Expired ($EXPIRE_DATE).${NC}"
        exit 1
    fi

    echo -e "${GREEN}✔ License Verified!${NC}"
    echo -e "${YELLOW}  Expire: $EXPIRE_DATE | Limit: $DEVICE_LIMIT${NC}"
    save_license "$SERVER_KEY" "$EXPIRE_DATE" "$DEVICE_LIMIT"
    sleep 2
fi

# Menu Loop
while true; do
    reset_ui
    show_logo
    
    # Typewriter welcome
    type_text "  Welcome to iTzTasin69 Premium Dashboard" "${GREEN}"
    echo ""

    # Menu Items
    echo -e "  ${CYAN}[1]${NC} Premium VM Maker"
    echo -e "  ${CYAN}[2]${NC} Premium Hostname Editor"
    echo -e "  ${CYAN}[3]${NC} CryzonBot LXC (Python)"
    echo -e "  ${RED}[4]${NC} Exit"
    echo ""
    
    # Footer Status
    echo -e "${BLUE}System Status:${NC} ${GREEN}Online${NC}  |  ${BLUE}User:${NC} ${YELLOW}Root${NC}"
    echo "-------------------------------------------------------"
    
    echo -ne "${YELLOW}➤ Select Option: ${NC}"
    read choice

    case $choice in
        1) run_script "$VM_MAKER_URL" "Premium VM Maker" ;;
        2) run_script "$HOSTNAME_EDITOR_URL" "Premium Hostname Editor" ;;
        3) run_script "$CRYZONBOT_URL" "CryzonBot LXC" ;;
        4) 
            echo -e "${RED}Shutting down...${NC}"
            sleep 1
            reset_ui
            exit 0 
            ;;
        *) 
            echo -e "${RED}Invalid option.${NC}"
            sleep 1
            ;;
    esac
done
