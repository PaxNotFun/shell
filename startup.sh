echo "Selecciona el script:"
echo "1. HolaClient Scrip"
echo "2. Panel Script"
read -p "Enter the number of the script: " choice

case $choice in
    1)
        bash <(curl -s https://raw.githubusercontent.com/PaxNotFun/shell/main/holaclient.sh)
        ;;
    2)
        bash <(curl -s https://raw.githubusercontent.com/PaxNotFun/eggs/master/panel.sh)
        ;;
    *)
        echo "Invalid choice. Exiting."
        ;;
esac
