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
# SYSTEM STATS
# ==========================================
get_system_stats() {
    local up_seconds=$(cat /proc/uptime | awk '{print int($1)}')
    local days=$((up_seconds/86400))
    local hours=$(( (up_seconds%86400)/3600 ))
    local mins=$(( (up_seconds%3600)/60 ))
    UPTIME_VAL="${days}d ${hours}h ${mins}m"
    
    HOST_VAL=$(hostname)
    CPU_VAL=$(grep 'cpu ' /proc/stat | awk '{usage=($2+$4)*100/($2+$4+$5)} END {print int(usage)}')
    RAM_VAL=$(free -m | awk 'NR==2{printf "%.0f", $3*100/$2}')
    
    if curl -s --connect-timeout 2 http://google.com > /dev/null 2>&1; then
        NET_VAL="ONLINE"
        NET_COLOR="$GREEN"
    else
        NET_VAL="OFFLINE"
        NET_COLOR="$RED"
    fi
}

# ==========================================
# CLEAN UI FUNCTIONS
# ==========================================
reset_ui() {
    clear
    printf "\033]0;iTzTasin69 Dashboard\007"
}

print_gradient() {
    local text="$1"
    local len=${#text}
    local colors=("31" "33" "32" "36" "34" "35")
    for (( i=0; i<len; i++ )); do
        color_index=$(( (i % 6) ))
        printf "\033[0;3${colors[$color_index]}m${text:i:1}"
    done
    printf "\033[0m\n"
}

draw_ui() {
    get_system_stats
    
    # Clean Open-Box System Info
    echo -e "   ${DIM}┌─ System Info ──────────────────────────${NC}"
    printf "   ${DIM}│${NC} ${CYAN}Host:${NC} %-18s ${CYAN}Uptime:${NC} %s${NC}\n" "$HOST_VAL" "$UPTIME_VAL"
    printf "   ${DIM}│${NC} ${CYAN}CPU:${NC} ${YELLOW}%-5s${NC} ${CYAN}RAM:${NC} ${YELLOW}%-5s${NC} ${CYAN}Net:${NC} ${NET_COLOR}%-6s${NC}\n" "$CPU_VAL%" "$RAM_VAL%" "$NET_VAL"
    echo -e "   ${DIM}└──────────────────────────────────────${NC}"
    echo ""
    
    # Clean TASIN Logo
    echo -e "${CYAN}████████╗░█████╗░░██████╗██╗███╗░░██╗${NC}"
    echo -e "${BLUE}░░░██║░░░███████║╚█████╗░██║██╔██╗██║${NC}"
    echo -e "${MAGENTA}░░░██║░░░██╔══██║░╚═══██╗██║██║╚████║${NC}"
    echo -e "${MAGENTA}░░░██║░░░██║░░██║██████╔╝██║██║░╚███║${NC}"
    echo -e "${RED}░░░╚═╝░░░╚═╝░░╚═╝╚═════╝░╚═╝╚═╝░░╚══╝${NC}"
    echo ""
    echo -n "      "
    print_gradient "P R E M I U M   D A S H B O A R Dᴹ ᴬ ᴰ ᴱ ᴮ ʸ ᶦᵀᶻᵀᵃˢᶦᴺ⁶⁹"
    echo ""
}

show_menu() {
    echo -e "   ${DIM}┌─ Script Menu ──────────────────────────${NC}"
    echo -e "   ${DIM}│${NC}   ${CYAN}[1]${NC} Premium VM Maker"
    echo -e "   ${DIM}│${NC}   ${CYAN}[2]${NC} Premium Hostname Editor"
    echo -e "   ${DIM}│${NC}   ${CYAN}[3]${NC} CryzonBot LXC (Python)"
    echo -e "   ${DIM}│${NC}   ${CYAN}[4]${NC} Docker VSCode Maker"
    echo -e "   ${DIM}│${NC}   ${RED}[5]${NC} Exit Dashboard"
    echo -e "   ${DIM}└──────────────────────────────────────${NC}"
    echo -e "   ${DIM}License expires: $LICENSE_EXPIRE${NC}"
    echo "   ----------------------------------------------"
}

boot_animation() {
    clear
    echo -e "${CYAN}"
    echo "┌────────────────────────────────────────────────────┐"
    echo "│         iTzTasin69 SECURE SYSTEM BOOT v6.0         │"
    echo "└────────────────────────────────────────────────────┘"
    echo ""
    local steps=("Initializing Modules..." "Checking Network..." "Connecting to DB..." "Verifying Integrity...")
    for step in "${steps[@]}"; do
        printf "   ${YELLOW}●${NC} %s" "$step"
        sleep 0.3
        printf "\r   ${GREEN}✔${NC} %s \n" "$step"
    done
    echo ""
}

# ==========================================
# MULTI-LINE SECURE LICENSE LOGIC (FIXED)
# ==========================================
verify_license() {
    local input_key=""
    
    if [ -f "$LOCAL_LICENSE_FILE" ]; then
        source "$LOCAL_LICENSE_FILE"
        input_key="$CACHED_KEY"
    else
        echo -ne "   ${CYAN}🔑 Enter License Key: ${NC}"
        read -s input_key
        echo ""
    fi

    echo -e "   ${BLUE}🔗 Authenticating with Server...${NC}"
    RAW_DATA=$(curl -s --connect-timeout 10 "$LICENSE_URL")

    if [[ "$RAW_DATA" == *"<html>"* || "$RAW_DATA" == *"404"* ]] || [ -z "$RAW_DATA" ]; then
        echo -e "   ${RED}✗ SECURITY ALERT: License file missing from server!${NC}"
        rm -f "$LOCAL_LICENSE_FILE"
        sleep 2
        exit 1
    fi

    # FIX: Loop through ALL lines to find the matching key
    FOUND=0
    while IFS= read -r line; do
        [ -z "$line" ] && continue
        
        # Parse from the RIGHT side: PERMS, LIMIT, EXPIRE
        PERMS=$(echo "$line" | awk '{print $NF}')
        DEVICE_LIMIT=$(echo "$line" | awk '{print $(NF-1)}')
        EXPIRE_DATE=$(echo "$line" | awk '{print $(NF-2)}')
        
        # Everything else on the left is the KEY (Supports spaces in keys!)
        SERVER_KEY=$(echo "$line" | awk '{$NF=""; $(NF-1)=""; $(NF-2)=""; print substr($0,1,length($0)-2)}' | xargs)
        
        # Check if typed key matches this line
        if [ "$input_key" == "$SERVER_KEY" ]; then
            FOUND=1
            break
        fi
    done <<< "$RAW_DATA"

    if [ "$FOUND" -eq 0 ]; then
        echo -e "   ${RED}✗ Invalid License Key!${NC}"
        rm -f "$LOCAL_LICENSE_FILE"
        sleep 1
        exit 1
    fi

    if [[ "$(date +%Y-%m-%d)" > "$EXPIRE_DATE" ]]; then
        echo -e "   ${RED}✗ License Expired ($EXPIRE_DATE).${NC}"
        rm -f "$LOCAL_LICENSE_FILE"
        sleep 1
        exit 1
    fi

    echo "CACHED_KEY=$SERVER_KEY" > "$LOCAL_LICENSE_FILE"
    chmod 600 "$LOCAL_LICENSE_FILE" > /dev/null 2>&1
    
    export LICENSE_EXPIRE="$EXPIRE_DATE"
    export LICENSE_PERMS="$PERMS"
    
    echo -e "   ${GREEN}✔ Access Granted.${NC}"
    echo -e "   ${DIM}  Expiry: $EXPIRE_DATE | Perms: $PERMS${NC}"
    sleep 2
}

run_script() {
    local url="$1"
    local name="$2"
    local ext="${url##*.}"
    local filename="/tmp/temp_script.$ext"

    echo -e "   ${BLUE}⏳ Downloading ${name}...${NC}"
    
    if curl -s -L "$url" -o "$filename"; then
        echo -e "   ${GREEN}✔ Download Complete.${NC}"
        echo -e "   ${DIM}─────────────────────────────────────────${NC}"
        
        if [ "$ext" == "py" ]; then
            if command -v python3 &> /dev/null; then
                python3 "$filename"
            else
                echo -e "   ${RED}✗ Python3 is not installed.${NC}"
            fi
        else
            bash "$filename"
        fi
        
        echo -e "   ${DIM}─────────────────────────────────────────${NC}"
        echo -e "   ${YELLOW}✔ Execution Finished.${NC}"
    else
        echo -e "   ${RED}✗ Failed to download script.${NC}"
    fi
    rm -f "$filename"
    echo ""
    read -p "   Press [Enter] to return to dashboard..."
}

# ==========================================
# MAIN LOGIC
# ==========================================

boot_animation
reset_ui
draw_ui

verify_license

while true; do
    reset_ui
    draw_ui
    show_menu
    
    echo -ne "   ${YELLOW}➤ Select Option: ${NC}"
    read choice

    case $choice in
        1|2|3|4)
            if [[ "$LICENSE_PERMS" != "all" ]]; then
                if [[ ",$LICENSE_PERMS," != *",$choice,"* ]]; then
                    echo -e "   ${RED}✗ ACCESS DENIED: License does not permit option [$choice].${NC}"
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
            echo -e "   ${RED}Shutting down securely...${NC}"
            sleep 1
            reset_ui
            exit 0 
            ;;
        *) 
            echo -e "   ${RED}Invalid option.${NC}"
            sleep 1
            ;;
    esac
done
