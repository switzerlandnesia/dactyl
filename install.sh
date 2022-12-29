#!/bin/bash

if (( $EUID != 0 )); then
    echo "Please run as root"
    exit
fi

clear

installTheme(){
    cd /var/www/
    tar -cvf MinecraftPurpleThemebackup.tar.gz pterodactyl
    echo "Installing Theme"
    cd /var/www/pterodactyl
    rm -r MinecraftPurpleTheme
    git clone https://github.com/switzerlandnesia/dactyl.git
    cd MinecraftPurpleTheme
    rm /var/www/pterodactyl/resources/scripts/MinecraftPurpleTheme.css
    rm /var/www/pterodactyl/resources/scripts/index.tsx
    mv index.tsx /var/www/pterodactyl/resources/scripts/index.tsx
    mv MinecraftPurpleTheme.css /var/www/pterodactyl/resources/scripts/MinecraftPurpleTheme.css
    cd /var/www/pterodactyl

    curl -sL https://deb.nodesource.com/setup_14.x | sudo -E bash -
    apt update
    apt install -y nodejs

    npm i -g yarn
    yarn

    cd /var/www/pterodactyl
    yarn build:production
    sudo php artisan optimize:clear


}

installThemeQuestion(){
    while true; do
        read -p "Are You Sure That You Want To Install The Theme [y/n] " yn
        case $yn in
            [Yy]* ) installTheme; break;;
            [Nn]* ) exit;;
            * ) echo "Please Answer Yes Or No.";;
        esac
    done
}

repair(){
    bash <(curl https://raw.githubusercontent.com/switzerlandnesia/dactyl/main/repair.sh)
}

restoreBackUp(){
    echo "Restoring Backup"
    cd /var/www/
    tar -xvf MinecraftPurpleThemebackup.tar.gz
    rm MinecraftPurpleThemebackup.tar.gz

    cd /var/www/pterodactyl
    yarn build:production
    sudo php artisan optimize:clear
}
echo "Copyright (c) 2022 Pterodactyl"
echo "This Program Is Free Software"
echo ""
echo "WhatsApp: https://whatsapp.com"
echo "Tweet: https://twitter.com"
echo ""
echo "[1] Install Theme"
echo "[2] Restore Backup"
echo "[3] Repair Panel"
echo "[4] Exit"

read -p "Please Enter A Number: " choice
if [ $choice == "1" ]
    then
    installThemeQuestion
fi
if [ $choice == "2" ]
    then
    restoreBackUp
fi
if [ $choice == "3" ]
    then
    repair
fi
if [ $choice == "4" ]
    then
    exit
fi