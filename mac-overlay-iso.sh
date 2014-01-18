#!/bin/sh -x
#!/bin/sh

# define our mount points
CURR_DIR=`pwd`
MOUNT_NEW=/tmp/mountcd-new
OVERLAY=$CURR_DIR/iso-overlay.tar
OVERLAY_DIR=$CURR_DIR/iso-overlay/

if [ ! -d "$MOUNT_NEW" ]; then
  echo "Error: destination $MOUNT_NEW doesn't exists!"
  exit
fi

## now we have to go inside of our directory
#cd "$MOUNT_NEW"
#tar xvf "$OVERLAY"

# now we have to go inside of our overlay directory
cd "$OVERLAY_DIR"
cp -R . "$MOUNT_NEW"

# result
#ls -al "$ISO_IMAGE_NEW"
cd "$CURR_DIR"


