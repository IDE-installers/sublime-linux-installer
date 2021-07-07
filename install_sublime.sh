#!/bin/bash

# sublime text installer for linux
# this script is made of functions, so you can easily modify it


# function to configure the installer
function configure(){
    printf "Sublime Text installer for Linux\n"
    echo "Before you install Sublime Text, you need to configure some things "
    
    # lists of valid options
    LPM=("apt" "pacman" "yum" "dnf" "zypper") # [L]ist of [P]ackage [M]anagers
    channelL=("s" "S" "d" "D") # s and S is stable, d and D is Dev

    printf "\nWhich package manager are you using?\n"
    for eachPM in "${LPM[@]}"; do echo $eachPM; done
    echo

    read PM # [P]ackage [M]anager

    printf "Which channel to use? [ [S]table or [D]ev ]\n"
    read channel
}


# function to install sublime text
function install(){
    printf "Installing...\n"
    case $PM in
        apt | APT)
            wget -qO https://download.sublimetext.com/sublimehq-pub.gpg | sudo apt-key add 
            sudo apt-get install apt-transport-https
            
            case $channel in 
                # stable
                s | S)
                    echo "deb https://download.sublimetext.com/ apt/stable/" | sudo tee /etc/apt/sources.list.d/sublime-text.list
                    ;;
                # Dev
                d | D)
                    echo "deb https://download.sublimetext.com/ apt/dev/" | sudo tee /etc/apt/sources.list.d/sublime-text.list
                    ;;
                *) echo "'${channel}' is invalid choice"; exit ;;
            esac

            sudo apt-get update
            sudo apt-get install sublime-text
            ;;

        pacman | PACMAN)
            curl -O https://download.sublimetext.com/sublimehq-pub.gpg && sudo pacman-key --add sublimehq-pub.gpg && sudo pacman-key --lsign-key 8A8F901A && rm sublimehq-pub.gpg
        
            case $channel in 

                s | S)
                    echo -e "\n[sublime-text]\nServer = https://download.sublimetext.com/arch/stable/x86_64" | sudo tee -a /etc/pacman.conf
                    ;;

                d | D)
                    echo -e "\n[sublime-text]\nServer = https://download.sublimetext.com/arch/dev/x86_64" | sudo tee -a /etc/pacman.conf
                    ;;
                *) echo "'${channel}' is invalid choice"; exit ;;
            esac

            sudo pacman -Syu sublime-text
            ;;

        yum | YUM)

            sudo rpm -v --import https://download.sublimetext.com/sublimehq-rpm-pub.gpg

            case $channel in 
                
                s | S)
                    sudo yum-config-manager --add-repo https://download.sublimetext.com/rpm/stable/x86_64/sublime-text.repo
                    ;;
                
                d | D)
                    sudo yum-config-manager --add-repo https://download.sublimetext.com/rpm/dev/x86_64/sublime-text.repo
                    ;;
                *) echo "'${channel}' is invalid choice"; exit ;;
            esac

            sudo yum install sublime-text
            ;;

        dnf | DNF)

            sudo rpm -v --import https://download.sublimetext.com/sublimehq-rpm-pub.gpg

            case $channel in 
                
                s | S)
                    sudo dnf config-manager --add-repo https://download.sublimetext.com/rpm/stable/x86_64/sublime-text.repo
                    ;;
                
                d | D)
                    sudo dnf config-manager --add-repo https://download.sublimetext.com/rpm/dev/x86_64/sublime-text.repo
                    ;;
                *) echo "'${channel}' is invalid choice"; exit ;;
            esac

            sudo sudo dnf install sublime-text
            ;;

        zypper | ZYPPER)

            sudo rpm -v --import https://download.sublimetext.com/sublimehq-rpm-pub.gpg

            case $channel in 
                
                s | S)
                    sudo zypper addrepo -g -f https://download.sublimetext.com/rpm/stable/x86_64/sublime-text.repo
                    ;;
                
                d | D)
                    sudo zypper addrepo -g -f https://download.sublimetext.com/rpm/dev/x86_64/sublime-text.repo
                    ;;
                *) echo "'${channel}' is invalid choice"; exit ;;
            esac

            sudo zypper install sublime-text
            ;;

        *) echo "${PM} is invalid choice!"; exit ;;

    esac

}

configure
install
