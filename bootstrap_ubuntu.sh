#!/bin/bash


#
# Installs oh my zsh
#
install_oh_my_zsh() 
{
    if [ ! -d ~/.oh-my-zsh ]; then
        sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
    fi

    if [ ! -d ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions ]; then
        git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
    fi

    if [ ! -d ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting ]; then
        git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
    fi

    sed -i 's/plugins=(git)/plugins=(git zsh-autosuggestions zsh-syntax-highlighting)/' ~/.zshrc
}


function install_apt_packages() {
    PACKAGES=(
        curl
        git
        terminator
        openvpn
        vlc
        zsh
        ca-certificates
    )

    sudo apt-get install ${PACKAGES[@]}
}

function install_snap_packages() {
    PACKAGES=(
        brave
        chromium
        mailspring
        bitwarden
        postman
        spotify
        simplenote
    )

    for package in "${PACKAGES[@]}"
    do
        sudo snap install  $package
    done

    PACKAGES=(
        code
    )

    for package in "${PACKAGES[@]}"
    do
        sudo snap install  $package --classic
    done
}




function install_packages()
{
  echo "Installing packages"
  
  apt install -y python3 python3-pip
  apt install -y build-essential libssl-dev libffi-dev python3-dev
  apt install -y  python3-dev
  
  install_apt_packages
  install_snap_packages

  install_oh_my_zsh
  
}

function update_and_upgrade()
{
  echo "Update and Upgrade"

  apt-get update -y
  apt-get upgrade -y
}

function configure_ubuntu()
{
gsettings set org.gnome.shell favorite-apps "['firefox_firefox.desktop', 'org.gnome.Nautilus.desktop', 'libreoffice-writer.desktop', 'code_code.desktop', 'spotify_spotify.desktop', 'terminator.desktop']"
}

function  root_or_die()
{
  if [ "$EUID" -ne 0 ]
    then echo "Please run as root"
    exit
  fi
}

root_or_die
update_and_upgrade
install_packages
configure_ubuntu
