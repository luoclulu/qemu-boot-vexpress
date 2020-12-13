## Boot u-boot & kernel via QEMU

The environment is required to install QEMU, and get executable file `qemu-system-arm` and `qemu-system-aarch64` used to boot. Use command `qemu-system-arm -machine help` can display the supported board.

### Compile u-boot

The source code of u-boot can be downloaded at <https://gitlab.denx.de/u-boot/u-boot.git>. After cloning code to local system, all the configs about board can be found at directory `configs/`.

Used the following command to configure our u-boot:

```shell
make ARCH=arm vexpress_ca9x4_defconfig
```

and then compile the u-boot by the command:

```shell
make ARCH=arm CROSS_COMPILE=arm-linux-gnueabihf- all
```

The executable file in *ELF format* `u-boot` and the pure binary `u-boot.bin` are finally compiled, where QEMU can start the executable in ELF format `u-boot`.



### Compile kernel

To successfully boot an ARM Linux system, three components are required: `bootloader`, `Linux Kernel`, `rootfs`.

Long time ago, to make `rootfs` has to rely on tool `busybox`. Today, tool `buildroot` can be used to more easily build a `rootfs`.

Tool `buildroot` can be downloaded by command:

```she
git clone git://git.buildroot.net/buildroot
```

> Buildroot Configuration

+ **Target options**:

​	Select **little endian**, **cortex A9**, **VFP extension** and **EABIhf**.

+ **Build options**:

​	Input kinds of **dir**.

+ **Toolchain**:

​	Select **External toolchain**, **custom toolchain** and **Pre-installed toolchain**. Input the **Toolchain path**, **Toolchain prefix** `($(ARCH)-linux-gnueabihf)` and **toolchain version**.

​	The version of toolchain can be found by command `arm-linux-gnueabihf-gcc -v`, and the version of toolchain gcc and tool chain kernl headers can be found in file `version.h` located at

```shell
arm-linux-gnueabihf/libc/usr/include/linux/version.h
```

In **System configuration->Run a getty(login prompt) after boot** set **TTY port** as `ttyAMA0`.

+ **Filesystem images**:

​	Select **cpio the root filesystem** and select **Compression method** as `lz4`.

> Compile Linux Kernel

Get source code of Linux by command:

```she
git clone https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git
```

Linux mainline has supported the board `vexpress_a9`. The config can be found at `arch/arm/configs/`. Generate the configs file by command:

```shel
make ARCH=arm vexpress_defconfig
```

Copy `rootfs.cpio.lz4` compiled by buildroot into root directory:

```she
cp buildroot/output/images/rootfs.cpio/lz4 .
```

Configure out kernel by command:

```she
make ARCH=arm menuconfig
```

Input `rootfs.cpio.lz4` at **General setup->Initramfs source file** to combine our `rootfs` and `kernel`. Besides, to debug our kernel, some kernel hacking features can be enable such as **Showing timing information on printks** located at **kernel hacking->printk and dmesg options**.

Finally, exit menuconfig and compile:

```shel
make ARCH=arm CROSS_COMPILE=arm-linux-gnueabihf- -j8
```



### Boot Command

As for now, all components that boot a Linux kernel via qemu have been generated. However, some preparation can be made before booting.

+ boot from u-boot

```shell
$ qemu-system-arm -M vexpress-a9 -m 512M -kernel ${IMG_DIR}/uboot -nographic -sd sd.img
```

+ boor from kernel

```shell
$ qemu-system-arm -M vexpress-a9 -m 512M -kernel ${IMG_DIR}/zImage -dtb ${DTB_DIR}/vexpress-v2p-ca9.dtb -nographic -append "console=ttyAMA0"
```

