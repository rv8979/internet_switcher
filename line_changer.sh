#!/bin/bash
echo -e "\e[92m"
if [[ $EUID -ne 0 ]]; then
    echo "This script must be run as root"
    sleep 10
    exit 1
fi

# network reset script by raghav chauhan (raghav.chauhan78@gmail.com)

RED='\033[0;31m' #red color
L_RED='\033[1;31m'
NC='\033[0m' # No Color


#=============================
# variables
#=============================


nic="eth1"                             #nic name here
ip_addr="192.168.2.7"                  #here ip
subnet="255.255.255.0"                 #here subnetmask
dns_srv="8.8.8.8"                      #here dns server
broadcast_adr="192.168.2.255"          #broadcast addr
gateway="192.168.2.1"                  #here gateway


#==========================
#  Functions
#==========================

# ip changer function for broadband

ip_change () {
    
    # add your code here for function
    
    echo "$nic is down"
    #ifconfig $nic down
    echo "connecting to broadband please wait...."
    progress_function
    ifconfig $nic $ip_addr netmask $subnet broadcast $broadcast_adr
    sed -i 's/192.168.1.51 server2/192.168.2.99 server2/g' /etc/hosts    # change hostname in /etc/hosts (host name for BB)
    echo "$nic is up"
    #ifconfig $nic up
    echo "Setting gateway on $nic"
    route add default gw $gateway
    echo "Setting DNS on $nic"
    echo nameserver $dns_srv > /etc/resolv.conf
    if ! ping -q -c 3 192.168.2.1 > /dev/null 2>&1; then
        echo -e "${RED}Error:Cable unplugged. Contact your system administrator.${NC}" >&2
        echo " "
        echo "Auto exit in 10 seconds"
        sleep 10
        exit 1;
    else
        echo " "
        echo "_______________________"
        echo "| Connection success  |"
        echo "_______________________"
        echo "  "
        echo " "
        echo "Auto exit in 10 seconds"
        sleep 10
    fi
}

# connect to leaed line

ll_connect (){
    
    echo "$nic is down"
    ifconfig $nic down
    echo "connecting to leased line please wait...."
    progress_function
    sed -i 's/192.168.2.99 server2/192.168.1.51 server2/g' /etc/hosts    # change hostname in /etc/hosts (hostname for ll)
    ifconfig $nic up
    sleep 5
    if ! ping -q -c 3 192.168.1.1 > /dev/null 2>&1; then
        echo -e "${RED}Error: Cable unplugged. Contact your system administrator.${NC}" >&2
        echo " "
        echo "Auto exit in 10 seconds"
        sleep 10
        exit 1;
    else
        echo " "
        echo "_______________________"
        echo "| Connection success  |"
        echo "_______________________"
        echo "  "
        echo " "
        echo "Auto exit in 10 seconds"
        sleep 10
    fi
    
}

url_fixer (){

    if [[ $myip =~ ^[103]+\.[99]+\.[196]+\.[174]+$ ]]; then
        #printf "Your current connection is: ${RED} Lease Line ${NC}\n"
        sed -i 's/192.168.2.99 server2/192.168.1.51 server2/g' /etc/hosts    # change hostname in /etc/hosts (hostname for ll)
        echo "Server 2 url is fixed with Leased Line"
        echo "Auto exit in 10 seconds/n"
        sleep 10
        exit 1;
        
        elif [[ $myip =~ ^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
        printf "Your current connection is: ${RED} Excitel Broadband ${NC}\n"
        sed -i 's/192.168.1.51 server2/192.168.2.99 server2/g' /etc/hosts    # change hostname in /etc/hosts (host name for BB)
        echo "Server 2 url is fixed with Excitel Broadband"
        echo "Auto exit in 10 seconds/n"
        sleep 10
        exit 1;
        
    else
        printf "error....: ${RED} You are not connect any internet or may be internet not working ${NC}\n"
        echo "Auto exit in 10 seconds"
        sleep 10
        exit 1;
    fi
    
}

# Invoke your function
progress_function (){
    #echo -e "${RED}Error: Contact your system administrato.${NC}" >&2
    
    echo -e "\e[92m"
    echo -ne '##                        (10%)\r'
    sleep 2
    echo -ne '#####                     (25%)\r'
    sleep 2
    echo -ne '#########                 (40%)\r'
    sleep 2
    echo -ne '#############             (50%)\r'
    sleep 2
    echo -ne '###################       (80%)\r'
    sleep 2
    echo -ne '######################### (100%)\r'
    echo -ne '\n'
    
    
}

# main menu options

menu (){
    
    read -p "Enter choice [ 1 - 4] " choice
    
    case $choice in
        1) ip_change ;;
        2) ll_connect ;;
        3) url_fixer  ;;
        4) exit 0;;
        *) echo -e "${RED}Error..invalid option $choice.${NC}" && menu #&& sleep 2
    esac
}

exit_hold (){
    
    read -p "press E for exit [E] " choice
    
    case $choice in
        E) exit && exit ;;
        e) exit && exit ;;
        #		3) exit 0;;
        *) echo -e "${RED}Error..invalid option $choice.${NC}" && exit_hold #&& sleep 2
    esac
    
}

#==============================
# main script start here
#=============================
tput clear

# Move cursor to screen location X,Y (top left is 0,0)
tput cup 3 15

# Set a foreground colour using ANSI escape
tput bold
tput setaf 3
echo "Inter Net connection switch"
tput sgr0

tput cup 5 15
#tput setaf 1
myip=$(wget -qO - icanhazip.com)
llip="103.99.196.174"

printf "Your WAN/Public IP address is: ${RED} $myip ${NC}\n"

tput cup 6 15
if [[ $myip =~ ^[103]+\.[99]+\.[196]+\.[174]+$ ]]; then
    printf "Your current connection is: ${RED} Lease Line ${NC}\n"
    
    elif [[ $myip =~ ^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
    printf "Your current connection is: ${RED} Excitel Broadband ${NC}\n"
    
else
    printf "error....: ${RED} You are not connect any internet or may be internet not working ${NC}\n"
fi
tput cup 7 15


tput sgr0

tput cup 8 17
# Set reverse video mode
tput rev
echo "M A I N - M E N U"
tput sgr0

tput cup 10 15
echo "1. Excitel Broadband"

tput cup 11 15
echo "2. Lease Line"

tput cup 12 15
echo "3. Server 2 Url Fix"

tput cup 13 15
echo "4. Exit"

tput cup 14 15
tput setaf 3
echo "Press 1 for Excitel Broadband or press 2 for LL"

# Set bold mode
tput bold
tput cup 16 15

#============================
# Main script end here
#===========================
menu
#tput clear
#tput sgr0
#tput rc


