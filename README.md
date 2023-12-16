# FirmDTA

## Introduction

FirmDTA is a cross-platform, full-system simulation dynamic taint analysis framework for IoT firmware, including real-time Virtual Machine Introspection(VMI), precise and comprehensive taint propagation, and asynchronous analysis tools.

## Building

compiler：gcc/g++ version 7 or higher

需要先安装ninja：

```
git clone git://github.com/ninja-build/ninja.git && cd ninja
 ./configure.py --bootstrap
cp ninja /usr/bin/
ninja --version
```

然后到FirmDTA目录下进行安装：

```
cd FirmDTA
.install_depends.sh
./configure --enable-debug --target-list=i386-softmmu,mips-softmmu,arm-softmmu,mipsel-softmmu
make -j3
```

编译时会在FirmDTA/下自动创建build文件夹，编译完成后可以在该文件夹下找到qemu-system-i386、qemu-system-arm、qemu-system-mips、qemu-system-mipsel

## Usage

在使用firmadyne或者firmAE成功仿真固件后，会得到一个启动文件run.sh，其中启动固件的命令一般为：

```shell
${QEMU} -m 256 -M ${QEMU_MACHINE} -kernel ${KERNEL} \
    -drive if=ide,format=raw,file=${IMAGE} -append "root=${QEMU_ROOTFS} console=ttyS0 nandsim.parts=64,64,64,64,64,64,64,64,64,64 rdinit=/firmadyne/preInit.sh rw debug ignore_loglevel print-fatal-signals=1 user_debug=31 firmadyne.syscall=0" \
    -nographic \
    -netdev tap,id=nettap0,ifname=${TAPDEV_0},script=no -device e1000,netdev=nettap0 -netdev socket,id=net1,listen=:2001 -device e1000,netdev=net1 -netdev socket,id=net2,listen=:2002 -device e1000,netdev=net2 -netdev socket,id=net3,listen=:2003 -device e1000,netdev=net3 | tee ${WORK_DIR}/qemu.final.serial.log
```

替换掉其中的变量：

```shell
/FirmDTA/build/qemu-system-mips -m 1024 -M malta -kernel ./vmlinux.mipseb_3.2.1   \
      	-drive if=ide,format=raw,file=./image.raw -append "root=/dev/sda1 console=ttyS0 nandsim.parts=64,64,64,64,64,64,64,64,64,64 rdinit=/firmadyne/preInit.sh rw debug ignore_loglevel print-fatal-signals=1 user_debug=31 firmadyne.syscall=0" \
   	-monitor stdio  \
     	-netdev tap,id=net0,ifname=tap11_0,script=no -device e1000,netdev=net0 -netdev socket,id=net1,listen=:2001 -device e1000,netdev=net1 -netdev socket,id=net2,listen=:2002 -device e1000,netdev=net2 -netdev socket,id=net3,listen=:2003 -device e1000,netdev=net3 | tee ./qemu.final.serial.log
```

这样就可以使用FirmDTA启动固件。

### VMI

FirmDTA提供了三条hmp指令来查看当前系统的进程和模块信息：

```
list_all_proc			//查看当前系统的所有进程的信息，包括pid,name,pgd
list_kernel_modules		//查看kernel进程的模块信息，包括name,base,size
list_modules_by_pid 		//根据pid查看某进程的模块信息，包括name,base,size
```

### Taint mark

FirmDTA在e1000.c文件里内联了污点源标记模块，在monitor命令行中可使用命令mark_taint_msg提供标记需求，命令的格式为：

```
mark_taint_msg [url] [flag] [start] [len]

For example:
mark_taint_msg /sys/system.cgi ipaddr= 0 16
将向/sys/system.cgi发送的数据包中字符串"ipaddr="后的第0个字节到第16个字节标记成污点。
```

### Taint propagation

FirmDTA提供了污点传播功能的开启和关闭指令：

```
enable_taint
disable_taint
```

允许使用者根据情况自行开启或关闭污点传播功能。

### Taint log

FirmDTA在TCG的跳转处理函数部分进行污点检测，若存有跳转地址的寄存器被污染，在monitor界面将会打印：

```
PC HAS BEEN TAINTED!
```

污点传播会自动停止。相关日志默认在/home/下，有三个文件guest_ins_flow_log、guest_taint_log、guest_tcg_log。

### Taint analysis

FirmDTA提供了对污染信息的回溯追踪，相关工具在/FirmDTA/shared/analysis_tools中，目前有两个工具：

```
fireware_elf_parser.py
taint_ana.py
```

使用方法如下：

```
binwalk -Me fireware
sudo cp -rf fireware_extracted /FirmDTA/shared/analysis_tools/
python fireware_elf_parser.py fireware_extracted

sudo cp /home/guest_ins_flow_log /home/guest_taint_log /home/guest_tcg_log /FirmDTA/shared/analysis_tools/
python taint_ana.py
```

fireware_elf_parser.py会生成符号表文件symbol_table。这个文件会在taint_ana.py中用到，所以要先生成。

taint_ana.py会生成一个污点传播轨迹图，记录了污点信息在各个进程之间的传播流程。
