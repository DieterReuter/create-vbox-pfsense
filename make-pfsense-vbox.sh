#!/bin/sh
#
# Configurables:
#
#  - Disk size is in GB
#  - Memory size is in MB
#  - SSH port is the local forwarded port to the VM:22
#
disksize="32"
memsize="1024"
sshport="8322"
vmname="pfSense-VBox"
dlsite="http://files.nl.pfsense.org/mirror/downloads"
vboxdir=$(VBoxManage list systemproperties \
            | awk '/^Default.machine.folder/ {print $0}' | cut -c 34- )
CACHE="./image-cache"
mkdir -p "$CACHE"
ISO_32BIT="pfSense-LiveCD-2.1-RELEASE-i386.iso"
ISO_64BIT="pfSense-LiveCD-2.1-RELEASE-amd64.iso"
ISO_FILE="$ISO_32BIT"
ISO_LINK="$dlsite/$ISO_FILE.gz"

VM_ISO_FILE="${vboxdir}/${vmname}/${ISO_FILE}" 

#
# Find a suitable md5sum program.
#
if type md5 >/dev/null 2>&1; then
    md5sum='md5'
    column='NF'
elif type digest >/dev/null 2>&1 &&
     digest md5 /dev/null >/dev/null 2>&1; then
    md5sum='digest md5'
    column='NF'
elif type digest >/dev/null 2>&1 &&
     digest -a md5 /dev/null >/dev/null 2>&1; then
    md5sum='digest -a md5'
    column='1'
elif type md5sum >/dev/null 2>&1; then
    md5sum='md5sum'
    column='1'
elif type openssl >/dev/null 2>&1 &&
     openssl md5 -hex /dev/null >/dev/null 2>&1; then
    md5sum='openssl md5 -hex'
    column='NF'
else
    echo "ERROR: Sorry, could not find an md5 program" 1>&2
    exit 1
fi
#
# Download MD5 file and parse it for the latest ISO image and checksum
#
if [ ! -f "${CACHE}/${ISO_FILE}.gz.md5" ]; then
  curl -o "${CACHE}/${ISO_FILE}.gz.md5" "${ISO_LINK}.md5" # 2>/dev/null
fi
latest_md5=$(cat "${CACHE}/${ISO_FILE}.gz.md5" \
             | awk '{ print $'${column}' }')

#
# Download the latest ISO image and verify
#
mkdir -p "${vboxdir}/${vmname}"
if [ ! -f "${CACHE}/${ISO_FILE}" ]; then
  if [ ! -f "${CACHE}/${ISO_FILE}.gz" ]; then
    echo "Downloading ${ISO_FILE}.gz"
    curl -o "${CACHE}/${ISO_FILE}.gz" "${ISO_LINK}" # 2>/dev/null
  fi
  dl_md5=$(${md5sum} "${CACHE}/${ISO_FILE}.gz" \
           | awk '{ print $'${column}' }')
  if [ -z "${dl_md5}" ]; then
    echo "ERROR: Couldn't fetch ISO image"
    exit 1
  fi
  if [ "${latest_md5}" != "${dl_md5}" ]; then
    echo "ERROR: md5 checksums do not match"
    exit 1
  fi

  #
  # Extract original ISO image
  gzip -d -c "${CACHE}/${ISO_FILE}.gz" > "${CACHE}/${ISO_FILE}" 
  #gzip -d -c "${CACHE}/${ISO_FILE}.gz" > "${VM_ISO_FILE}" 
fi
if [ ! -f "${VM_ISO_FILE}" ]; then
  cp "${CACHE}/${ISO_FILE}" "${VM_ISO_FILE}" 
fi

#
# Create VirtualBox VM
#
echo "Creating/Updating Virtual Machine: ${vmname}"
VBoxManage showvminfo "${vmname}" >/dev/null 2>&1
if [ $? -eq 0 ]; then
    # VM already exists, just update the ISO image
    VBoxManage storageattach "${vmname}" --storagectl "IDE Controller" \
      --port 1 --device 0 --type dvddrive \
      --medium "${VM_ISO_FILE}"
else
    # Create the VM
    VBoxManage createvm --name "${vmname}" --ostype FreeBSD --register
    VBoxManage storagectl "${vmname}" --name "IDE Controller" --add ide

    # Attach the ISO image
    VBoxManage storageattach "${vmname}" --storagectl "IDE Controller" \
      --port 1 --device 0 --type dvddrive --tempeject on \
      --medium "${VM_ISO_FILE}"

    # Create and attach the zone disk
    VBoxManage createhd --filename "${vboxdir}/${vmname}/pfsense-disk.vdi" \
      --size $(echo "${disksize}*1024" | bc)
    VBoxManage storageattach "${vmname}" --storagectl "IDE Controller" \
      --port 0 --device 0 --type hdd \
      --medium "${vboxdir}/${vmname}/pfsense-disk.vdi"

    # Set misc settings
    VBoxManage modifyvm "${vmname}" --nic1 bridged
    VBoxManage modifyvm "${vmname}" --bridgeadapter1 "en1: Wi-Fi (AirPort)"
#    VBoxManage modifyvm "${vmname}" --nic1 nat
    VBoxManage modifyvm "${vmname}" --natpf1 "SSH,tcp,,${sshport},,22"
    VBoxManage modifyvm "${vmname}" --nic2 intnet
    VBoxManage modifyvm "${vmname}" --boot1 dvd --boot2 disk --boot3 none
    VBoxManage modifyvm "${vmname}" --memory ${memsize}

    # Set serial console
    #VBoxManage modifyvm "${vmname}" --uart1 0x3f8 4
    #VBoxManage modifyvm "${vmname}" --uartmode1 client /tmp/serial0
    #VBoxManage modifyvm "${vmname}" --uart2 0x2f8 3
    #VBoxManage modifyvm "${vmname}" --uartmode2 client /tmp/serial1

fi

#
# Start it up
#
echo "Starting Virtual Machine: ${vmname}"
echo "...start:  VBoxManage startvm ${vmname}" 
echo "...delete: VBoxManage unregistervm ${vmname} -d" 


bridgedifs=$(VBoxManage list bridgedifs \
            | grep '^Name:' | cut -c 18- )
echo ""
echo "VBoxManage list bridgedifs:"
echo "${bridgedifs}"


