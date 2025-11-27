#! /bin/sh

INIT_ACTIVE_PARTITION_NO=2
INIT_STANDBY_PARTITION_NO=3
TARGET_DEVICE_NAME=/dev/swupdate_rootfs_target

echo "======================================"
echo " toggle_partition                     "
echo "======================================"

if [ $# -lt 1 ]; then
    exit 0;
fi


function get_current_root_device
{
	for i in `cat /proc/cmdline`; do
		if [ ${i:0:5} = "root=" ]; then
			CURRENT_ROOT="${i:5}"
            # /dev/mmcblk0p3
		fi
	done
}

function get_update_partition
{
	CURRENT_PARTITION="${CURRENT_ROOT: -1}"
    echo Current Partition is $CURRENT_PARTITION
    UPDATE_PARTITION="$INIT_STANDBY_PARTITION_NO"
	if [ $CURRENT_PARTITION = "$INIT_ACTIVE_PARTITION_NO" ]; then
		UPDATE_PARTITION="$INIT_STANDBY_PARTITION_NO"
	else
		UPDATE_PARTITION="$INIT_ACTIVE_PARTITION_NO"
	fi

    UPDATE_DEVICE_NAME=${CURRENT_ROOT%p?}p$UPDATE_PARTITION
}

function create_symbolic_link
{
    echo Create Symbolic link
    if [ -L $TARGET_DEVICE_NAME ]; then
        echo symbolic link is already exist.
        rm -f $TARGET_DEVICE_NAME
    fi
    ln -s $UPDATE_DEVICE_NAME $TARGET_DEVICE_NAME
    ls -l $TARGET_DEVICE_NAME
}

function delete_symbolic_link
{
    echo Delete Symbolic link
    if [ -L $TARGET_DEVICE_NAME ]; then
        rm -f $TARGET_DEVICE_NAME
    fi
}

function change_active_rootfs_partition
{
    fw_setenv rootfspart $UPDATE_PARTITION
}

get_current_root_device
echo Current ROOT divece is $CURRENT_ROOT
get_update_partition

if [ $1 == "preinst" ]; then
    echo "run pre install script."

    echo SW Update Target Partition is $UPDATE_PARTITION
    echo SW Update Target Device is $UPDATE_DEVICE_NAME
    
    create_symbolic_link
fi

if [ $1 == "postinst" ]; then
    echo "run post install script."

    delete_symbolic_link
    echo "change rootfs partition($CURRENT_PARTITION -> $UPDATE_PARTITION)"
    change_active_rootfs_partition
    echo Partition to be active on reboot is $UPDATE_PARTITION
    
fi
