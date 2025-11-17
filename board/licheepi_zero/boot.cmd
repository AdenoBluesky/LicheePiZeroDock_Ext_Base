# setenv bootargs console=ttyS0,115200 panic=5 console=tty0 rootwait root=/dev/mmcblk0p2 earlyprintk rw
# load mmc 0:1 0x41000000 zImage
# load mmc 0:1 0x41800000 sun8i-v3s-licheepi-zero-dock.dtb
# bootz 0x41000000 - 0x41800000

echo -------------------- checking rootfspart ----------
if printenv rootfspart; 
    then echo rootfspart found; 
    else echo rootfspart not found; setenv rootfspart 2; setenv modify_save 1; 
fi

# setenv bootargs console=ttyS0,115200 panic=5 console=tty0 rootwait root=/dev/mmcblk0p${rootfspart} earlyprintk rw
# load mmc 0:1 0x41000000 zImage
# load mmc 0:1 0x41800000 sun8i-v3s-licheepi-zero-dock.dtb

# echo -------------------- printenv --------------------
# printenv
# echo wait 10 sec ...
# sleep 10

echo -------------------- checking modify_save flag -------------------- 
if printenv modify_save; 
    then; 
        if test "${modify_save}" = "1"; 
            then echo modify_save is on.; setenv modify_save 0; saveenv; 
            else echo modify_save is off.;
        fi; 
    else echo modify_save is not found.; 
fi


setenv bootargs console=ttyS0,115200 panic=5 console=tty0 rootwait root=/dev/mmcblk0p${rootfspart} earlyprintk rw
load mmc 0:1 0x41000000 zImage
load mmc 0:1 0x41800000 sun8i-v3s-licheepi-zero-dock-ex.dtb
bootz 0x41000000 - 0x41800000