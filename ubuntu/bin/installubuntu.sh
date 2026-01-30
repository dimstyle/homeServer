#! /usr/bin/bash
cd $(dirname "${BASH_SOURCE[0]}")/..

xorriso -as mkisofs -V CIDATA -R -J seed/ -o seed.iso
WRONG=false

while [[ $# -gt 0 ]]; do
    case $1 in
        -m|--memory)
            WRONG=false
            MEMORY=$2
            shift 2
            ;;
        -c|--cpu)
            WRONG=false
            CPU=$2
            shift 2
            ;;
        -b|--base)
            WRONG=false
            BASE=$2
            shift 2
            ;;
        -s|--serial)
            WRONG=false
            SERIAL=$2
            shift 2
            ;;
        -cd|--cdrom)
            WRONG=false
            CDROM=$2
            shift 2
            ;;
        -r|--root)
            WRONG=false
            ROOT=$2 
            shift 2
            ;;
        *) 
            WRONG=true
            ;;
    esac
done

if $WRONG ; then
    exit 1
fi

sudo qemu-system-x86_64 \
-m $MEMORY \
-smp $CPU \
-enable-kvm \
-drive if=pflash,format=raw,file=/usr/share/OVMF/OVMF_CODE.fd \
-drive if=pflash,format=raw,file=$ROOT/$BASE/OVMF_VARS.fd \
-drive file=$(pwd)/seed.iso,format=raw,if=virtio \
-drive file=$ROOT/cdrom/$CDROM,format=raw,if=virtio \
-drive file=$ROOT/$BASE/$BASE.qcow2,format=qcow2,if=none,id=drive0 \
-device virtio-blk-pci,drive=drive0,serial=$SERIAL \
-display spice-app
