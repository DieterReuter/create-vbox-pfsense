#!/bin/sh
#!/bin/sh -x

# define our mount points
CURR_DIR=`pwd`
MOUNT_NEW=/tmp/mountcd-new
ISO_IMAGE_NEW=$CURR_DIR/image-mac.iso

if [ ! -d "$MOUNT_NEW" ]; then
  echo "Error: destination $MOUNT_NEW doesn't exists!"
  exit
fi

# now we have to go inside of our directory
cd "$MOUNT_NEW"
#ls -al 

# let's create the new ISO image
mkisofs -V pfSense -J -R -b boot/cdboot -no-emul-boot -o "$ISO_IMAGE_NEW" . 

# result
#ls -al "$ISO_IMAGE_NEW"
cd "$CURR_DIR"

# Remove the working directory
sudo rm -fr "$MOUNT_NEW"

