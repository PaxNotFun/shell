echo "*==================================*"
echo "*       Selecciona el script:      *"
echo "*       1. Heliactyl Scrip         *"
echo "*       2. Pterodactyl Script      *"
echo "*       3. Jexactyl Script        *"
echo "*==================================*"
read -p "Enter the number of the script:  " choice

case $choice in
    1)
        bash <(curl -s https://raw.githubusercontent.com/PaxNotFun/shell/main/holaclient.sh)
        ;;
    2)
        bash <(curl -s https://raw.githubusercontent.com/PaxNotFun/shell/main/panel.sh)
        ;;
    3)
        bash <(curl -s https://raw.githubusercontent.com/PaxNotFun/shell/main/jexactyl.sh)
        ;;
    *)
        echo "Invalid choice. Exiting."
        ;;
esac
