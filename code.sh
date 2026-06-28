#!/bin/bash

# ==========================================
# CONFIGURATION
# ==========================================
LICENSE_URL="https://raw.githubusercontent.com/minepaneloffcial-dotcom/project-1/main/license.key"
VM_MAKER_URL="https://raw.githubusercontent.com/minepaneloffcial-dotcom/project-1/refs/heads/main/code.sh"
HOSTNAME_EDITOR_URL="https://raw.githubusercontent.com/minepaneloffcial-dotcom/project-2/refs/heads/main/code.sh"
CRYZONBOT_URL="https://raw.githubusercontent.com/minepaneloffcial-dotcom/project-3/refs/heads/main/code.py"
VSCODE_URL="https://raw.githubusercontent.com/minepaneloffcial-dotcom/project-5/refs/heads/main/code.sh"

# Local file ONLY remembers the key so user doesn't have to type it
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
# ANIMATION FUNCTIONS
# ==========================================

type_text() {
    local text="$1"
    local color="$2"
    for (( i=0; i<${#text}; i++ )); do
        echo -ne "${color}${text:$i:1}${NC}"
        sleep 0.02
    done
    echo ""
}

boot_animation() {
    clear
    echo -e "${CYAN}"
    echo "┌────────────────────────────────────────────────────┐"
    echo "│         iTzTasin69 SECURE SYSTEM BOOT v3.0         │"
    echo "└────────────────────────────────────────────────────┘"
    echo ""
    local steps=("Initializing Secure Modules..." "Loading UI Assets..." "Establishing Secure Link..." "Verifying Integrity...")
    for step in "${steps[@]}"; do
        echo -ne "   ${YELLOW}●${NC} $step"
        sleep 0.4
        echo -ne "\r   ${GREEN}✔${NC} $step \n"
    done
    echo ""
}

# ==========================================
# CORE FUNCTIONS
# ==========================================

reset_ui() {
    clear
    echo -ne "\033]0;iTzTasin69 Secure Dashboard\007"
}

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

# --- NEW SECURE LICENSE LOGIC ---
verify_license() {
    local input_key=""
    
    # 1. Check if we have a cached key
    if [ -f "$LOCAL_LICENSE_FILE" ]; then
        source "$LOCAL_LICENSE_FILE"
        input_key="$CACHED_KEY"
    else
        # 2. If no cache, ask user (Hidden input)
        echo -ne "${CYAN}🔑 Enter License Key: ${NC}"
        read -s input_key
        echo ""
    fi

    # 3. MANDATORY ONLINE CHECK (This is what makes it secure)
    echo -e "${BLUE}🔗 Authenticating with Server...${NC}"
    RAW_DATA=$(curl -s --connect-timeout 10 "$LICENSE_URL")

    # 4. Security Check: Did the file exist on GitHub?
    if [[ "$RAW_DATA" == *"<html>"* || "$RAW_DATA" == *"404"* ]] || [ -z "$RAW_DATA" ]; then
        echo -e "${RED}✗ SECURITY ALERT: License file missing from server!${NC}"
        echo -e "${RED}  Access Denied. Local cache wiped.${NC}"
        rm -f "$LOCAL_LICENSE_FILE" # Destroy local cache immediately
        sleep 2
        exit 1
    fi

    # 5. Parse Server Data (Format: KEY EXPIRE LIMIT PERMS)
    read -r SERVER_KEY EXPIRE_DATE DEVICE_LIMIT PERMS <<< "$RAW_DATA"
    
    # Fallback if PERMS is empty in github file
    [ -z "$PERMS" ] && PERMS="all"

    # 6. Validate Key Match
    if [ "$(echo "$input_key" | tr -d '[:space:]')" != "$(echo "$SERVER_KEY" | tr -d '[:space:]')" ]; then
        echo -e "${RED}✗ Invalid License Key!${NC}"
        rm -f "$LOCAL_LICENSE_FILE"
        exit 1
    fi

    # 7. Validate Expiry
    if [[ "$(date +%Y-%m-%d)" > "$EXPIRE_DATE" ]]; then
        echo -e "${RED}✗ License Expired ($EXPIRE_DATE).${NC}"
        rm -f "$LOCAL_LICENSE_FILE"
        exit 1
    fi

    # 8. Success - Save Cache & Export Variables for Menu
    echo "CACHED_KEY=$SERVER_KEY" > "$LOCAL_LICENSE_FILE"
    chmod 600 "$LOCAL_LICENSE_FILE" > /dev/null 2>&1
    
    # Export these so the menu loop can read them
    export LICENSE_EXPIRE="$EXPIRE_DATE"
    export LICENSE_PERMS="$PERMS"
    
    echo -e "${GREEN}✔ Access Granted.${NC}"
    echo -e "${YELLOW}  Expiry: $EXPIRE_DATE | Perms: $PERMS${NC}"
    sleep 2
}

run_script() {
    local url=$1
    local name=$2
    local ext="${url##*.}"
    local filename="/tmp/temp_script.$ext"

    echo -e "${BLUE}⏳ Downloading ${name}...${NC}"
    
    if curl -s -L "$url" -o "$filename"; then
        echo -e "${GREEN}✔ Download Complete.${NC}"
        echo "────────────────────────────────────────────────────"
        
        if [ "$ext" == "py" ]; then
            if command -v python3 &> /dev/null; then
                python3 "$filename"
            else
                echo -e "${RED}✗ Python3 is not installed.${NC}"
            fi
        else
            bash "$filename"
        fi
        
        echo "────────────────────────────────────────────────────"
        echo -e "${YELLOW}✔ Execution Finished.${NC}"
    else
        echo -e "${RED}✗ Failed to download script.${NC}"
    fi
    rm -f "$filename"
    echo ""
    read -p "Press [Enter] to return to dashboard..."
}

# ==========================================
# MAIN LOGIC
# ==========================================

boot_animation
reset_ui
show_logo

# RUN THE SECURE CHECK (Requires internet)
verify_license

# Menu Loop
while true; do
    reset_ui
    show_logo
    
    type_text "  Welcome to iTzTasin69 Premium Dashboard" "${GREEN}"
    echo ""

    echo -e "  ${CYAN}[1]${NC} Premium VM Maker"
    echo -e "  ${CYAN}[2]${NC} Premium Hostname Editor"
    echo -e "  ${CYAN}[3]${NC} CryzonBot LXC (Python)"
    echo -e "  ${CYAN}[4]${NC} Docker VSCode Maker"
    echo -e "  ${RED}[5]${NC} Exit"
    echo ""
    
    echo -e "${BLUE}System Status:${NC} ${GREEN}Online${NC}  |  ${BLUE}User:${NC} ${YELLOW}Root${NC}  |  ${BLUE}Expires:${NC} ${YELLOW}$LICENSE_EXPIRE${NC}"
    echo "-------------------------------------------------------"
    
    echo -ne "${YELLOW}➤ Select Option: ${NC}"
    read choice

    case $choice in
        1|2|3|4)
            # --- PERMISSION CHECK ---
            # If PERMS is not "all", check if the number exists in the comma-separated list
            if [[ "$LICENSE_PERMS" != "all" ]]; then
                if [[ ",$LICENSE_PERMS," != *",$choice,"* ]]; then
                    echo -e "${RED}✗ ACCESS DENIED: Your license does not permit option [$choice].${NC}"
                    sleep 2
                    continue
                fi
            fi
            
            # Run corresponding script
            case $choice in
                1) run_script "$VM_MAKER_URL" "Premium VM Maker" ;;
                2) run_script "$HOSTNAME_EDITOR_URL" "Premium Hostname Editor" ;;
                3) run_script "$CRYZONBOT_URL" "CryzonBot LXC" ;;
                4) run_script "$VSCODE_URL" "Docker VSCode Maker" ;;
            esac
            ;;
        5) 
            echo -e "${RED}Shutting down securely...${NC}"
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
