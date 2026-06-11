#!/bin/bash

# ==========================================
# CONFIGURATION
# ==========================================
LICENSE_URL="https://raw.githubusercontent.com/minepaneloffcial-dotcom/project-1/main/license.key"
VM_MAKER_URL="https://raw.githubusercontent.com/minepaneloffcial-dotcom/project-1/refs/heads/main/code.sh"
HOSTNAME_EDITOR_URL="https://raw.githubusercontent.com/minepaneloffcial-dotcom/project-2/refs/heads/main/code.sh"
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
NC='\033[0m'

# ==========================================
# FUNCTIONS
# ==========================================

reset_ui() {
    clear
    tput reset # Hard reset terminal
}

# Function to print text in a horizontal Rainbow Gradient
print_gradient() {
    local text="$1"
    local len=${#text}
    # Gradient colors: Red -> Yellow -> Green -> Cyan -> Blue -> Magenta
    local colors=("31" "33" "32" "36" "34" "35")
    
    for (( i=0; i<len; i++ )); do
        color_index=$(( (i % 6) ))
        echo -ne "\033[0;3${colors[$color_index]}m${text:i:1}"
    done
    echo -e "${NC}"
}

show_logo() {
    echo ""
    # Vertical Gradient for the Logo (Cyan -> Blue -> Purple -> Pink)
    echo -e "${CYAN}████████╗░█████╗░░██████╗██╗███╗░░██╗"
    echo -e "${BLUE}░░░██║░░░███████║╚█████╗░██║██╔██╗██║"
    echo -e "${MAGENTA}░░░██║░░░██╔══██║░╚═══██╗██║██║╚████║"
    echo -e "${MAGENTA}░░░██║░░░██║░░██║██████╔╝██║██║░╚███║"
    echo -e "${RED}░░░╚═╝░░░╚═╝░░╚═╝╚═════╝░╚═╝╚═╝░░╚══╝${NC}"
    
    # Gradient Footer
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

run_script() {
    local url=$1
    local name=$2
    
    echo -e "${BLUE}⏳ Downloading ${name}...${NC}"
    if curl -s "$url" -o /tmp/temp_script.sh; then
        echo -e "${GREEN}✓ Downloaded. Executing...${NC}"
        echo "────────────────────────────────────────────────────"
        bash /tmp/temp_script.sh
        echo "────────────────────────────────────────────────────"
        echo -e "${YELLOW}✓ Execution Complete.${NC}"
    else
        echo -e "${RED}✗ Failed to download script.${NC}"
    fi
    rm -f /tmp/temp_script.sh
    echo ""
    read -p "Press [Enter] to continue..."
}

# ==========================================
# MAIN LOGIC
# ==========================================

reset_ui
show_logo

# Check for saved license
if check_local_license; then
    source "$LOCAL_LICENSE_FILE"
    echo -e "${GREEN}✔ Auto-Login Successful.${NC}"
    echo -e "${YELLOW}  Valid Until: $EXPIRE | Limit: $LIMIT${NC}"
    sleep 2
else
    # Manual Login
    echo -e "${BLUE}🔗 Connecting to License Server...${NC}"
    RAW_DATA=$(curl -s "$LICENSE_URL")

    if [ -z "$RAW_DATA" ]; then
        echo -e "${RED}✗ Connection failed. Check internet.${NC}"
        exit 1
    fi

    read -r SERVER_KEY EXPIRE_DATE DEVICE_LIMIT <<< "$RAW_DATA"
    CURRENT_DATE=$(date +%Y-%m-%d)

    # Input
    echo -ne "${CYAN}🔑 Enter License Key: ${NC}"
    read -s USER_KEY
    echo ""

    # Validation
    if [ "$(echo "$USER_KEY" | tr -d '[:space:]')" != "$(echo "$SERVER_KEY" | tr -d '[:space:]')" ]; then
        echo -e "${RED}✗ Invalid License Key.${NC}"
        exit 1
    fi

    if [[ "$CURRENT_DATE" > "$EXPIRE_DATE" ]]; then
        echo -e "${RED}✗ License Expired ($EXPIRE_DATE).${NC}"
        exit 1
    fi

    echo -e "${GREEN}✔ License Verified!${NC}"
    echo -e "${YELLOW}  Expiry: $EXPIRE_DATE | Devices: $DEVICE_LIMIT${NC}"
    save_license "$SERVER_KEY" "$EXPIRE_DATE" "$DEVICE_LIMIT"
    sleep 2
fi

# Menu Loop
while true; do
    reset_ui
    show_logo
    
    # Gradient Welcome Message
    print_gradient "Welcome to iTzTasin69 premium Code Deashbord"
    echo ""

    echo -e "  ${CYAN}[1]${NC} Premium VM Maker"
    echo -e "  ${CYAN}[2]${NC} Premium Hostname Editor"
    echo -e "  ${RED}[3]${NC} Exit"
    echo ""
    echo -ne "${YELLOW}➤ Select Option: ${NC}"
    read choice

    case $choice in
        1) run_script "$VM_MAKER_URL" "Premium VM Maker" ;;
        2) run_script "$HOSTNAME_EDITOR_URL" "Premium Hostname Editor" ;;
        3) 
            echo -e "${RED}Goodbye!${NC}"
            exit 0 
            ;;
        *) 
            echo -e "${RED}Invalid option.${NC}"
            sleep 1
            ;;
    esac
done
