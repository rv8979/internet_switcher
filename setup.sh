#!/bin/bash

if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root"
sleep 10
   exit 1
fi

echo "copying files ......"
cp ./line_changer.sh /bin/
cp ./line_changer_start.sh /bin/
echo "Create shortcut"
cp Line\ Changer.desktop /usr/share/applications/
echo "set permission"
chmod +x /bin/line_changer.sh
chmod +x /bin/line_changer_start.sh
chmod +x /usr/share/applications/Line\ Changer.desktop

