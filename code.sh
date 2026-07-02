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
# SYSTEM STATS FUNCTIONS (100% Accurate)
# ==========================================

get_system_stats() {
    # Universal Uptime Calculator (Works on Ubuntu, Debian, Alpine, CentOS)
    local up_seconds=$(cat /proc/uptime | awk '{print $1}')
    local days=$((up_seconds/86400))
    local hours=$(( (up_seconds%86400)/3600 ))
    local mins=$(( (up_seconds%3600)/60 ))
    UPTIME_VAL="${days}d ${hours}h ${mins}m"
    
    HOST_VAL=$(hostname)
    DISK_VAL=$(df -h / | awk 'NR==2 {print $5}')
    CPU_VAL=$(grep 'cpu ' /proc/stat | awk '{usage=($2+$4)*100/($2+$4+$5)} END {print int(usage)}')
    RAM_VAL=$(free -m | awk 'NR==2{printf "%.0f", $3*100/$2}')
    
    # Short words for perfect alignment
    if ping -c 1 -W 1 8.8.8.8 &>/dev/null; then
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

draw_ui() {
    get_system_stats # Refresh stats
    
    # TOP SYSTEM BAR (Perfectly aligned using padding math)
    echo -e " ${BLUE}━━━━━━━━━━━━━━━━ SYSTEM STATUS ━━━━━━━━━━━━━━━━${NC}"
    echo -e " ${CYAN}HOST:${NC} ${BOLD}$HOST_VAL${NC}$(printf '%*s' $((32 - ${#HOST_VAL})) '')${CYAN}UPTIME:${NC} ${DIM}$UPTIME_VAL${NC}"
    echo -e " ${CYAN}CPU:${NC}  ${YELLOW}$CPU_VAL%${NC}$(printf '%*s' $((28 - ${#CPU_VAL})) '')${CYAN}RAM:${NC} ${YELLOW}$RAM_VAL%${NC}$(printf '%*s' $((27 - ${#RAM_VAL})) '')${CYAN}NET:${NC} ${NET_COLOR}$NET_VAL${NC}"
    echo -e " ${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo ""
    
    # LOGO
    echo -e "${CYAN}  ██████╗░█████╗░░██████╗██╗███╗░░██╗${NC}"
    echo -e "${BLUE}  ██╔════╝██╔══██╗██╔════╝██║██╔██╗██║${NC}"
    echo -e "${MAGENTA}  ██║░░░░░███████║╚█████╗░██║██║╚████║${NC}"
    echo -e "${MAGENTA}  ██║░░░░░██╔══██║░╚═══██╗██║██║░╚███║${NC}"
    echo -e "${RED}  ╚██████╗██║░░██║██████╔╝██║██║░╚███║${NC}"
    echo -e "${RED}  ╚═════╝╚═╝░░╚═╝╚═════╝░╚═╝╚═╝░░╚══╝${NC}"
    echo ""
    echo -e "      $(print_gradient "P R E M I U M   D A S H B O A R Dᴹ ᴬ ᴰ ᴱ ᴮ ʸ ᶦᵀᶻᵀᵃˢᶦᴺ⁶⁹")"
    echo ""
}

show_menu() {
    echo -e " ${BLUE}━━━━━━━━━━━━━━━━ SCRIPT MENU ━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "   ${CYAN}➜${NC}  ${WHITE}[1]${NC} Premium VM Maker"
    echo -e "   ${CYAN}➜${NC}  ${WHITE}[2]${NC} Premium Hostname Editor"
    echo -e "   ${CYAN}➜${NC}  ${WHITE}[3]${NC} CryzonBot LXC (Python)"
    echo -e "   ${CYAN}➜${NC}  ${WHITE}[4]${NC} Docker VSCode Maker"
    echo -e "   ${CYAN}➜${NC}  ${RED}[5]${NC} Exit Dashboard"
    echo -e " ${BLUE}━━━━━━━━━━━━━━━━━━━━━━
