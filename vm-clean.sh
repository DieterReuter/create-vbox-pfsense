VBoxManage controlvm pfSense-VBox poweroff
VBoxManage unregistervm pfSense-VBox -d
rm -f ./cache/pfSense-LiveCD-2.1-RELEASE-i386.iso

