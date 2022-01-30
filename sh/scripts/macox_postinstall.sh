# QEmu
brew install qemu


install_packages(){

brew install wget
brew install qemu
brew install tree
brew install ranger
brew install wechat 
brew install docker
brew install git
brew install microsoft-remote-desktop
brew install --cask microsoft-teams
# install terminal
brew install kitty

mkdir ~/qemu

}

install_qemu (){
# Home for out tests
mkdir ~/arm-emu
cd ~/arm-emu

# Download initrd and kernel
wget http://ftp.de.debian.org/debian/dists/jessie/main/installer-armel/current/images/versatile/netboot/initrd.gz

#wget http://ftp.de.debian.org/debian/dists/jessie/main/installer-armel/current/images/versatile/netboot/vmlinuz-3.16.0-6-versatile
wget http://ftp.de.debian.org/debian/dists/jessie/main/installer-armel/current/images/versatile/netboot/vmlinuz-3.16.0-6-versatile 

# Creating disk
qemu-img create -f qcow2 armdisk.img 1G

# Running
qemu-system-arm -M versatilepb \
-kernel vmlinuz-3.16.0-6-versatile \
-initrd initrd.gz \
-hda armdisk.img \
-append "root=/dev/ram" \
-m 256
}

install_ubuntu (){


mainPath=~/data/qemu/arm-ubuntu
mkdir -p $mainPath
diskName=diskarm.img

cd  $mainPath
ubuntuRelease=ubuntu-20.04.3-live-server-arm64.iso
#ubuntu_url=https://releases.ubuntu.com/20.04/ubuntu-20.04.3-live-server-arm64.iso
ubuntu_url=https://cdimage.ubuntu.com/releases/20.04/release/$ubuntuRelease
wget -nc $ubuntu_url

# Download initrd and kernel
wget -nc http://ports.ubuntu.com/ubuntu-ports/dists/xenial/main/installer-armhf/current/images/generic-lpae/netboot/initrd.gz

wget -nc http://ftp.de.debian.org/debian/dists/jessie/main/installer-armel/current/images/versatile/netboot/vmlinuz-3.16.0-6-versatile 
wget -nc http://ftp.de.debian.org/debian/dists/jessie/main/installer-armel/current/images/versatile/netboot/vmlinuz-3.2.0-4-vexpress 

# Create disk
qemu-img create -f qcow2 $diskName 8G

#qemu-system-arm -M vexpress-a9 \
#-m 1024M \
#-boot d \
#-cdrom $mainPath/$ubuntuRelease \
#-drive file=$mainPath/$diskName,if=virtio \
#-kernel vmlinuz-3.16.0-6-versatile \
#-initrd initrd.gz \
#-append "root=/dev/ram"

#qemu-system-arm -m 1024M -sd $diskName \
#                -M vexpress-a9 -cpu cortex-a9 \
#                -kernel vmlinuz-3.16.0-6-versatile -initrd initrd.gz \
#                -append "root=/dev/ram"  -no-reboot


ISO=debian-10.0.0-armhf-netinst.iso 
ISO=ubuntuRelease
HDA=hda.qcow2
qemu-system-arm -M virt -m 1024 \
  -bios QEMU_EFI.fd \
# if using -bios option above does't work you can try to extract the img file and use the -pflash option
#  -pflash QEMU_EFI.img 
  -drive file=$ISO,id=cdrom,if=none,media=cdrom \
  -device virtio-scsi-device -device scsi-cd,drive=cdrom \
  -drive if=none,file=$HDA,format=qcow2,id=hd \
  -device virtio-blk-device,drive=hd \
  -netdev user,id=mynet \
  -device virtio-net-device,netdev=mynet


# run (unmount CDROM)
#qemu-system-x86-arm -m 2048 -vga virtio -usb -device usb-tablet -enable-kvm -drive file=$mainPath/$ubuntuRelease.qcow2,if=virtio -accel hvf -cpu host


}

init_qemu (){

mainPath=~/data/qemu/arm-ubuntu
mkdir -p $mainPath
diskName=diskarm.img

cd  $mainPath


wget -nc https://cloud-images.ubuntu.com/releases/16.04/release/ubuntu-16.04-server-cloudimg-arm64-uefi1.img
wget -nc  https://releases.linaro.org/components/kernel/uefi-linaro/latest/release/qemu64/QEMU_EFI.fd

dd if=/dev/zero of=flash0.img bs=1m count=64
dd if=QEMU_EFI.fd of=flash0.img conv=notrunc
dd if=/dev/zero of=flash1.img bs=1m count=64


docker run --rm -it -v $(pwd):$(pwd) -w $(pwd) ubuntu -- apt-get update && apt-get -y install cloud-utils && cloud-localds --disk-format qcow2 cloud.img cloud.txt



}


 
install_packages
#install_qemu
#install_ubuntu
init_qemu
