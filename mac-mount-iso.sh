#!/bin/sh
#!/bin/sh -x

# define our mount points
MOUNT_CD=/tmp/mountcd
MOUNT_NEW=/tmp/mountcd-new
ISO_IMAGE=./cache/pfSense-LiveCD-2.1-RELEASE-i386.iso
OS_TYPE=`uname -s`

if [ -d "$MOUNT_NEW" ]; then
  echo "Error: destination $MOUNT_NEW already exists!"
  exit
fi

# create mount point where to mount our ISO image
echo "Create mount point $MOUNT_CD"
mkdir -p "$MOUNT_CD"
#ls -ald "$MOUNT_CD"

# mount the ISO image
echo "Mount ISO image $ISO_IMAGE"
if [ "x$OS_TYPE"  == "xDarwin" ]; then
  # Mac OS X
  sudo hdiutil attach -nobrowse -mountpoint "$MOUNT_CD" "$ISO_IMAGE"
else
  # Linux
  sudo mount -t iso9660 "$ISO_IMAGE" "$MOUNT_CD"
fi
#ls -al "$MOUNT_CD"

# copy the complete ISO directory to a new directory for R/W
echo "Copy contents to new driectory $MOUNT_NEW"
cp -r "$MOUNT_CD" "$MOUNT_NEW"
chmod -R +w "$MOUNT_NEW"

# umount the ISO image
echo "Unmount ISO image $ISO_IMAGE"
if [ "x$OS_TYPE"  == "xDarwin" ]; then
  # Mac OS X
  sudo hdiutil detach "$MOUNT_CD"
else
  # Linux
  sudo umount -f "$MOUNT_CD"
fi
#ls -ald "$MOUNT_CD"

# remove the mount point
rm -fr "$MOUNT_CD"
#ls -ald "$MOUNT_CD"

# result
ls -ald "$MOUNT_NEW"
#ls -al "$MOUNT_NEW"

