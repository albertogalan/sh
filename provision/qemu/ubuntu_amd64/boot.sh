#!/bin/bash
qemu-system-x86_64 -m 2048 -smp 4 -hda /tmp/ubuntuqemuboot/images/focal-server-cloudimg-amd64.img -cdrom /tmp/ubuntuqemuboot/cloudinitmetadata/cidata.iso -device e1000,netdev=net0 -netdev user,id=net0,hostfwd=tcp::2222-:22 -nographic
