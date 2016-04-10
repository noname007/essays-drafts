# 下载内核源代码编译内核

mdir:
	sudo apt-get install libncurses5-dev
	#test -d 'LinuxKernel' || mkdir LinuxKernel 

linux: mdir
	#cd LinuxKernel &&\
	test -d 'linux-3.18.6' || test -f 'linux-3.18.6.tar' || test -f 'linux-3.18.6.tar.xz' || wget https://www.kernel.org/pub/linux/kernel/v3.x/linux-3.18.6.tar.xz
	test -d 'linux-3.18.6' || test -f 'linux-3.18.6.tar' || xz -d linux-3.18.6.tar.xz
	test -d 'linux-3.18.6' || tar -xvf linux-3.18.6.tar
	cd linux-3.18.6  &&\
	make i386_defconfig &&\
	make menuconfig &&\
	make # 一般要编译很长时间，少则20分钟多则数小时 \

menu: mdir
	#cd LinuxKernel &&\
	test -d 'menu' || git clone https://github.com/noname007/menu.git
clean:
	rm -fr linux-3.18.6/
install: menu linux
.PHONY: linux menu clean

