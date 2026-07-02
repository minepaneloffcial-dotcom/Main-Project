#!/bin/bash

# ==========================================
# CONFIGURATION
# ==========================================
LICENSE_URL="https://raw.githubusercontent.com/minepaneloffcial-dotcom/Main-Project/refs/heads/main/license.key"
VM_MAKER_URL="https://raw.githubusercontent.com/minepaneloffcial-dotcom/project-1/refs/heads/main/code.sh"
HOSTNAME_EDITOR_URL="https://raw.githubusercontent.com/minepaneloffcial-dotcom/project-2/refs/heads/main/code.sh"
CRYZONBOT_URL="https://raw.githubusercontent.com/minepaneloffcial-dotcom/project-3/refs/heads/main/code.py"
VSCODE_URL="https://raw.githubusercontent.com/minepaneloffcial-dotcom/project-5/refs/heads/main/code.sh"

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
DIM='\033[2m'
NC='\033[0m'

# ==========================================
# SYSTEM STATS FUNCTIONS
# ==========================================

get_system_stats() {
    # Hostname & Uptime
    HOST_VAL=$(hostname)
    # 'uptime -p' outputs "up X weeks, Y days...", we cut the "up "
    UPTIME_VAL=$(uptime -p 2>/dev/null | cut -d' ' -f2- || uptime | awk -F',' '{print $1}' | awk '{print $3,$4}')
    
    # Disk Usage
    DISK_VAL=$(df -h / | awk 'NR==2 {print $5}')
    
    # CPU Usage (Calculated from /proc/stat)
    CPU_VAL=$(grep 'cpu ' /proc/stat | awk '{usage=($2+$4)*100/($2+$4+$5)} END {print int(usage)}')
    
    # RAM Usage
    RAM_VAL=$(free -m | awk 'NR==2{printf "%.0f", $3*100/$2}')
    
    # Network Status (Ping Google DNS)
    if ping -c 1 -W 1 8.8.8.8 &>/dev/null; then
        NET_VAL="● CONNECTED"
        NET_COLOR="$GREEN"
    else
        NET_VAL="● DISCONNECTED"
        NET_COLOR="$RED"
    fi
}

# ==========================================
# UI FUNCTIONS
# ==========================================

reset_ui() {
    clear
    echo -ne "\033]0;iTzTasin69 Dashboard\007"
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

show_header() {
    get_system_stats # Refresh stats every time screen redraws
    
    # VPS INFO BAR (Safe unicode characters for universal terminal support)
    echo -e " ${BLUE}┌─────────────────────────────────────────────────────────────────────┐${NC}"
    echo -e " ${BLUE}│${NC} ${CYAN}💻${NC} ${BOLD}$HOST_VAL${NC}$(printf '%*s' $(( 38 - ${#HOST_VAL} )) '')${BLUE}│${NC} ${CYAN}⏳${NC} ${DIM}$UPTIME_VAL${NC} ${BLUE}│${NC}"
    echo -e " ${BLUE}│${NC} ${CYAN}💾${NC} Disk: ${YELLOW}$DISK_VAL${NC}$(printf '%*s' $(( 30 - ${#DISK_VAL} )) '')${BLUE}│${NC} ${CYAN}⚙️${NC} CPU: ${YELLOW}$CPU_VAL%${NC} ${DIM}|${NC} RAM: ${YELLOW}$RAM_VAL%${NC} ${BLUE}│${NC}"
    echo -e " ${BLUE}└─────────────────────────────────────────────────────────────────────┘${NC}"
    echo ""
}

show_logo() {
    echo -e "${CYAN}████████╗░█████╗░░██████╗██╗███╗░░██╗${NC}"
    echo -e "${BLUE}░░░██║░░░███████║╚█████╗░██║██╔██╗██║${NC}"
    echo -e "${MAGENTA}░░░██║░░░██╔══██║░╚═══██╗██║██║╚████║${NC}"
    echo -e "${MAGENTA}░░░██║░░░██║░░██║██████╔╝██║██║░╚███║${NC}"
    echo -e "${RED}░░░╚═╝░░░╚═╝░░╚═╝╚═════╝░╚═╝╚═╝░░╚══╝${NC}"
    
    local footer="P R E M I U M   D A S H B O A R Dᴹ ᴬ ᴰ ᴱ ᴮ ʸ ᶦᵀᶻᵀᵃˢᶦᴺ⁶⁹"
    printf "%*s\n" $(( (${#footer} + 80) / 2)) "$(print_gradient "$footer")"
}

show_system_status() {
    echo -e " ${BLUE}┌─────────────────────────────────────────────────────────────────────┐${NC}"
    echo -e " ${BLUE}│${NC} ${BOLD}◉ SYSTEM STATUS${NC}$(printf '%*s' 51 '')${BLUE}│${NC}"
    echo -e " ${BLUE}│${NC}$(printf '%*s' 3 '')CPU Usage: ${YELLOW}$CPU_VAL%${NC}$(printf '%*s' $(( 30 - ${#CPU_VAL} )) '')RAM Usage: ${YELLOW}$RAM_VAL%${NC}$(printf '%*s' $(( 25 - ${#RAM_VAL} )) '')Network: ${NET_COLOR}$NET_VAL${NC} ${BLUE}│${NC}"
    echo -e " ${BLUE}└─────────────────────────────────────────────────────────────────────┘${NC}"
}

boot_animation() {
    clear
    echo -e "${CYAN}"
    echo "┌────────────────────────────────────────────────────┐"
    echo "│         iTzTasin69 SECURE SYSTEM BOOT v4.0         │"
    echo "└────────────────────────────────────────────────────┘"
    echo ""
    local steps=("Initializing Secure Modules..." "Fetching Live Stats..." "Establishing Secure Link..." "Verifying Integrity...")
    for step in "${steps[@]}"; do
        echo -ne "   ${YELLOW}●${NC} $step"
        sleep 0.4
        echo -ne "\r   ${GREEN}✔${NC} $step \n"
    done
    echo ""
}

# ==========================================
# SECURE LICENSE LOGIC
# ==========================================

verify_license() {
    local input_key=""
    
    if [ -f "$LOCAL_LICENSE_FILE" ]; then
        source "$LOCAL_LICENSE_FILE"
        input_key="$CACHED_KEY"
    else
        echo -ne "${CYAN}🔑 Enter License Key: ${NC}"
        read -s input_key
        echo ""
    fi

    echo -e "${BLUE}🔗 Authenticating with Server...${NC}"
    RAW_DATA=$(curl -s --connect-timeout 10 "$LICENSE_URL")

    if [[ "$RAW_DATA" == *"<html>"* || "$RAW_DATA" == *"404"* ]] || [ -z "$RAW_DATA" ]; then
        echo -e "${RED}✗ SECURITY ALERT: License removed from server!${NC}"
        rm -f "$LOCAL_LICENSE_FILE"
        sleep 2
        exit 1
    fi

    read -r SERVER_KEY EXPIRE_DATE DEVICE_LIMIT PERMS <<< "$RAW_DATA"
    [ -z "$PERMS" ] && PERMS="all"

    if [ "$(echo "$input_key" | tr -d '[:space:]')" != "$(echo "$SERVER_KEY" | tr -d '[:space:]')" ]; then
        echo -e "${RED}✗ Invalid License Key!${NC}"
        rm -f "$LOCAL_LICENSE_FILE"
        exit 1
    fi

    if [[ "$(date +%Y-%m-%d)" > "$EXPIRE_DATE" ]]; then
        echo -e "${RED}✗ License Expired ($EXPIRE_DATE).${NC}"
        rm -f "$LOCAL_LICENSE_FILE"
        exit 1
    fi

    echo "CACHED_KEY=$SERVER_KEY" > "$LOCAL_LICENSE_FILE"
    chmod 600 "$LOCAL_LICENSE_FILE" > /dev/null 2>&1
    
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
show_header
show_logo

verify_license

# Menu Loop
while true; do
    reset_ui
    show_header
    show_logo
    show_system_status
    
    echo ""
    echo -e "  ${CYAN}[1]${NC} Premium VM Maker"
    echo -e "  ${CYAN}[2]${NC} Premium Hostname Editor"
    echo -e "  ${CYAN}[3]${NC} CryzonBot LXC (Python)"
    echo -e "  ${CYAN}[4]${NC} Docker VSCode Maker"
    echo -e "  ${RED}[5]${NC} Exit"
    echo ""
    
    echo -e " ${DIM}License Valid Until: $LICENSE_EXPIRE${NC}"
    echo "-------------------------------------------------------"
    
    echo -ne "${YELLOW}➤ Select Option: ${NC}"
    read choice

    case $choice in
        1|2|3|4)
            if [[ "$LICENSE_PERMS" != "all" ]]; then
                if [[ ",$LICENSE_PERMS," != *",$choice,"* ]]; then
                    echo -e "${RED}✗ ACCESS DENIED: Your license does not permit option [$choice].${NC}"
                    sleep 2
                    continue
                fi
            fi
            
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
