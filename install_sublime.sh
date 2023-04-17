#!/bin/bash

function configure(){
    printf "Sublime Text installer for Linux\n"
    sleep 1.5s
    
    if [ -x "$(command -v pacman)" ]; then
        PM=pacman # [P]ackage[M]anager
    elif [ -x "$(command -v apt-get)" ]; then
        PM=apt-get
    elif [ -x "$(command -v dnf)" ]; then
        PM=dnf
    elif [ -x "$(command -v yum)" ]; then
        PM=yum
    elif [ -x "$(command -v zypper)" ]; then
        PM=zypper
    else
        echo "Sorry, Your package manager is not supported!"
        echo "Install Sublime manually: https://www.sublimetext.com/download"
        exit 1
    fi
}


function install(){
    printf "Installing...\n"
    case $PM in
        apt-get)
            wget -qO - https://download.sublimetext.com/sublimehq-pub.gpg | gpg --dearmor | sudo tee /etc/apt/trusted.gpg.d/sublimehq-archive.gpg > /dev/null
            sudo apt-get install apt-transport-https

#           Install stable channel
            echo "deb https://download.sublimetext.com/ apt/stable/" | sudo tee /etc/apt/sources.list.d/sublime-text.list

#           Update packages and install sublime
            sudo apt-get update
            sudo apt-get install sublime-text -y
            ;;

        pacman)
            curl -O https://download.sublimetext.com/sublimehq-pub.gpg && sudo pacman-key --add sublimehq-pub.gpg && sudo pacman-key --lsign-key 8A8F901A && rm sublimehq-pub.gpg
        
            echo -e "\n[sublime-text]\nServer = https://download.sublimetext.com/arch/stable/x86_64" | sudo tee -a /etc/pacman.conf
            sudo pacman -Syu sublime-text --noconfirm
            ;;

        dnf)

            sudo rpm -v --import https://download.sublimetext.com/sublimehq-rpm-pub.gpg

            sudo dnf config-manager --add-repo https://download.sublimetext.com/rpm/stable/x86_64/sublime-text.repo
            sudo sudo dnf install sublime-text -y
            ;;

        yum)

            sudo rpm -v --import https://download.sublimetext.com/sublimehq-rpm-pub.gpg

            sudo yum-config-manager --add-repo https://download.sublimetext.com/rpm/stable/x86_64/sublime-text.repo
            sudo yum install sublime-text -y
            ;;

        zypper)

            sudo rpm -v --import https://download.sublimetext.com/sublimehq-rpm-pub.gpg

            sudo zypper addrepo -g -f https://download.sublimetext.com/rpm/stable/x86_64/sublime-text.repo
            sudo zypper install sublime-text
            ;;

    esac

}

configure
install
