#!/bin/bash

qemu-system-arm -M vexpress-a9 -m 512M -kernel u-boot -nographic -sd sd.img
