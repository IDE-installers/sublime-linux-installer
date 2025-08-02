#!/bin/bash
check=100

# When the commands to install Sublime Text will change, after modifying this script I'll also increase the 'check' number
# So that when user wants to execute this script, user will be notified that it's outdated

# NOTE: it installs the 'Stable' channel

# function to check if a command exists
function check_cmd(){
    if ! [ `command -v $1`  >/dev/null 2>&1 ]; then
        echo "Sorry, '$1' package is required, install it with your system's package manager"
        exit 1
    fi
}

function check(){
#   before doing any checks, make sure that these three packages are installed: curl, sed, wget
    check_cmd wget
    check_cmd curl
    check_cmd sed

    remote_check="https://raw.githubusercontent.com/IDE-installers/sublime-linux-installer/main/install_sublime.sh"

#   check internet connection
    wget -q --spider http://google.com # <-- can use another server too, not just Google

    if [ $? -ne 0 ]; then
        echo "Sorry, looks like you're offline"
        exit 1
    fi

#   Check if there is a new script release available
#   fetch the second line
    check_line=$(curl -sfL "$remote_check" | sed -n '2p')
    if [ -z "$check_line" ]; then
        echo "Something went wrong" >&2
        exit 1
    fi
#   and see if a new version is available
    if [[ $check_line =~ check=\"?([0-9]+)\"? ]]; then
        remote_check="${BASH_REMATCH[1]}"
    else
        echo "Unable to parse remote check from: $check_line" >&2
        exit 1
    fi

    if [[ remote_check -gt check ]]; then
        echo "A newer version of installer is available: $remote_check (currently using: $check)"
        echo "It's recommended to use the latest version scince this one has a chance of not working properly anymore"
        echo -e "Download latest version with:\nwget -N https://raw.githubusercontent.com/ide-installers/sublime-linux-installer/main/install_sublime.sh"
    exit
    
    else
        echo -e "Up to date\n"
    fi
}

function configure(){
    printf "Sublime Text installer for Linux\n"
    sleep 1.5s
    
    if [ -x "$(command -v pacman)" ]; then
        PM=pacman # [P]ackage[M]anager
#       Sublime supports officially x86_64 and aarch64, so I need user to tell me which one's he using
        
        echo "Is your system is using 'x86_64' or 'aarch64' architecture?"
        echo -e "Options:\n 1-- x86_64\n 2-- aarch64\n"
        read pacman_choice
        case $pacman_choice in
            1)
            echo "Going to install Sublime Text Stable for Fedora 41/dnf5 or newer"
            echo "Press ENTER to Proceed or CTRL + C to Cancel..."
            read
            pacman_choice='amd64'
            ;;
            2)
                pacman_choice='arm64'
                ;;
            *)
            echo "Invalid answer"
            exit 1
            ;;

        esac

    elif [ -x "$(command -v apt-get)" ]; then
        PM=apt-get
    elif [ -x "$(command -v dnf)" ]; then
        PM=dnf
        #
        echo "Are you using 'Fedora 41/dnf5 or newer'? y/n"
        read dnf_choice
        case $dnf_choice in
            y | Y | yes | YES)
            echo "Going to install Sublime Text Stable for Fedora 41/dnf5 or newer"
            echo "Press ENTER to Proceed or CTRL + C to Cancel..."
            read
            dnf_choice='newer'
            ;;
            *)
            dnf_choice='older'
            ;;

        esac
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
#           Install the GPG key
            wget -qO - https://download.sublimetext.com/sublimehq-pub.gpg | sudo tee /etc/apt/keyrings/sublimehq-pub.asc > /dev/null

#           Install stable channel
            echo -e 'Types: deb\nURIs: https://download.sublimetext.com/\nSuites: apt/stable/\nSigned-By: /etc/apt/keyrings/sublimehq-pub.asc' | sudo tee /etc/apt/sources.list.d/sublime-text.sources

#           Update apt sources and install Sublime Text
            sudo apt-get update
            sudo apt-get install sublime-text -y
            ;;

        pacman)
            curl -O https://download.sublimetext.com/sublimehq-pub.gpg && sudo pacman-key --add sublimehq-pub.gpg && sudo pacman-key --lsign-key 8A8F901A && rm sublimehq-pub.gpg

#           Choose architecture
            
            if [ $pacman_choice == 'amd64' ]; then
#               Select "Stable x86_64" Channel
                echo -e "\n[sublime-text]\nServer = https://download.sublimetext.com/arch/stable/x86_64" | sudo tee -a /etc/pacman.conf
            
            elif [ $pacman_choice = 'arm64' ]; then
#               Stable aarch64
                echo -e "\n[sublime-text]\nServer = https://download.sublimetext.com/arch/stable/aarch64" | sudo tee -a /etc/pacman.conf
            fi
            
            sudo pacman -Syu sublime-text --noconfirm
            ;;

        dnf)
            sudo rpm -v --import https://download.sublimetext.com/sublimehq-rpm-pub.gpg

            if [ $dnf_choice == 'newer' ] ; then
#               Stable for Fedora 41/dnf5 or newer
                sudo dnf config-manager addrepo --from-repofile=https://download.sublimetext.com/rpm/stable/x86_64/sublime-text.repo
            elif [ $dnf_choice == 'older' ]; then 
#               Just 'Stable'
                sudo dnf config-manager --add-repo https://download.sublimetext.com/rpm/stable/x86_64/sublime-text.repo
            fi

            sudo dnf install sublime-text -y
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

check
configure
install
