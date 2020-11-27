# Qemu Boot first successful

## Boot Command
### u-bbot
```shell
$ qemu-system-arm -M vexpress-a9 -m 512M -kernel ${IMG_DIR}/uboot -nographic -sd sd.img
```

### kernel
```shell
$ qemu-system-arm -M vexpress-a9 -m 512M -kernel ${IMG_DIR}/zImage -dtb ${DTB_DIR}/vexpress-v2p-ca9.dtb -nographic -append "console=ttyAMA0"
```
