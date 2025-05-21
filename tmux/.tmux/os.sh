#!/bin/bash

OS=$(uname -s)

case "$OS" in
    "Linux")
        # Further detect Linux distros
        if [ -f /etc/arch-release ]; then
            echo "󰣇 #1793d1"  # Arch
        elif [ -f /etc/fedora-release ]; then
            echo "󰣛 #0B57A4"  # Fedora
        elif [ -f /etc/debian_version ]; then
            if [ -f /etc/linuxmint/info ]; then
                echo "󰣭 #86BE43"  # Mint
            else
                echo "󰣚 #d70a53"  # Debian
            fi
        elif [ -f /etc/ubuntu-release ] || [ -f /etc/lsb-release ] && grep -q "Ubuntu" /etc/lsb-release; then
            echo "󰕈 #E95420"  # Ubuntu
        elif [ -f /etc/centos-release ]; then
            echo " #9ECE26"  # CentOS
        elif [ -f /etc/redhat-release ]; then
            echo "󱄛 #ee0000"  # RedHat
        elif [ -f /etc/SuSE-release ]; then
            echo " #73ba25"  # SUSE
        elif [ -f /etc/gentoo-release ]; then
            echo "󰣨 #54487A"  # Gentoo
        elif [ -f /etc/alpine-release ]; then
            echo " #005880"  # Alpine
        elif [ -f /etc/manjaro-release ]; then
            echo " #34be5b"  # Manjaro
        else
            echo " #000000"  # Generic Linux
        fi
        ;;
    "Darwin")
        echo " white"  # macOS
        ;;
    "MINGW"* | "MSYS"* | "CYGWIN"*)
        echo "󰍲 #0078d7"  # Windows
        ;;
    *)
        echo " #000000"  # Unknown OS, default to Linux
        ;;
esac
