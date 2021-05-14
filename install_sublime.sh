# sublime text installer for linux
# this program is made of functions, so you can easily modify it


# function to configure the installer
function configure(){
    # lists of valid options
    PML=("apt" "pacman" "yum" "dnf" "zypper") # [P]ackage[M]anager[L]ist
    channelL=("s" "S" "d" "D") # s/S is stable, d/D is Dev

    printf "Install Sublime Text tool\n"
    echo "Before you install Sublime Text, you need to configure some things "

    printf "\nWhich package manager do you use?\n"
    for eachPM in "${PML[@]}"; do echo $eachPM ; done
    echo

    read PM # [P]ackage [M]anager

    printf "Which channel to use? [ [S]table or [D]ev ]\n"
    read channel
}


# function to install sublime text
function install(){
    printf "Installing...\n"
    case $PM in
        apt)
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
            esac

            sudo apt-get update
            sudo apt-get install sublime-text
            ;;

        pacman)
            curl -O https://download.sublimetext.com/sublimehq-pub.gpg && sudo pacman-key --add sublimehq-pub.gpg && sudo pacman-key --lsign-key 8A8F901A && rm sublimehq-pub.gpg
        
            case $channel in 
                # stable
                s | S)
                    echo -e "\n[sublime-text]\nServer = https://download.sublimetext.com/arch/stable/x86_64" | sudo tee -a /etc/pacman.conf
                    ;;
                # Dev
                d | D)
                    echo -e "\n[sublime-text]\nServer = https://download.sublimetext.com/arch/dev/x86_64" | sudo tee -a /etc/pacman.conf
                    ;;
            esac

            sudo pacman -Syu sublime-text
            ;;

        yum)

            sudo rpm -v --import https://download.sublimetext.com/sublimehq-rpm-pub.gpg

            case $channel in 
                # stable
                s | S)
                    sudo yum-config-manager --add-repo https://download.sublimetext.com/rpm/stable/x86_64/sublime-text.repo
                    ;;
                # Dev
                d | D)
                    sudo yum-config-manager --add-repo https://download.sublimetext.com/rpm/dev/x86_64/sublime-text.repo
                    ;;
            esac

            sudo yum install sublime-text
            ;;

        dnf)

            sudo rpm -v --import https://download.sublimetext.com/sublimehq-rpm-pub.gpg

            case $channel in 
                # stable
                s | S)
                    sudo dnf config-manager --add-repo https://download.sublimetext.com/rpm/stable/x86_64/sublime-text.repo
                    ;;
                # Dev
                d | D)
                    sudo dnf config-manager --add-repo https://download.sublimetext.com/rpm/dev/x86_64/sublime-text.repo
                    ;;
            esac

            sudo sudo dnf install sublime-text
            ;;

        zypper)

            sudo rpm -v --import https://download.sublimetext.com/sublimehq-rpm-pub.gpg

            case $channel in 
                # stable
                s | S)
                    sudo zypper addrepo -g -f https://download.sublimetext.com/rpm/stable/x86_64/sublime-text.repo
                    ;;
                # Dev
                d | D)
                    sudo zypper addrepo -g -f https://download.sublimetext.com/rpm/dev/x86_64/sublime-text.repo
                    ;;
            esac

            sudo zypper install sublime-text
            ;;

        *)
            echo "Something went wrong!"
            exit
            ;;

    esac

}

configure
install
