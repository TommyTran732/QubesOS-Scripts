## Thinkpad P53

My personal setup for the Thinkpad P53

## Hardware
- **CPU**: Intel® Core™ i9-9980H Processor
- **GPU**: NVIDIA Quadro RTX 4000 Mobile
- **RAM**: 2x 16GB Samsung DDR4-2666 (M471A2K43DB1-CTD) + 2x Micron 32GB DDR4-3200 (MTA16ATF4G64HZ-3G2E2)
- **Drive 0**: Micron 3500 1TB (MTFDKBA1T0TGD-1BK1AABYYR)
- **Drive 1**: Micron 3500 1TB (MTFDKBA1T0TGD-1BK1AABYYR)
- **Drive 2**: Micron 3500 1TB (MTFDKBA1T0TGD-1BK1AABYYR)

**Notes**: 

As of this writing, the Micron 2500, 2650, and 3500 are the only client SSDs advertising [firmware verification](https://www.micron.com/content/dam/micron/global/public/documents/products/product-flyer/micron-ssd-secure-foundation-flyer.pdf). I am not sure how secure the implementation is, but I guess it is better than nothing.

There are other enterprise SSDs from Micron with firmware verification, but I am not using them here due to heat and power constraints.

Unlike the likes of WD and Samsung who make life extremely difficult unless you buy an OEM drive, Micron [provides firmware updates on their website and also includes an update utility for Linux](https://www.micron.com/products/storage/ssd/micron-ssd-firmware#accordion-e6c186b05b-item-2ebc81f38a). There is no need to look for the Dell or Lenovo version of a drive to get updates via LVFS.

## Firmware notes:
- Update all firmware on Windows before installing Qubes. Lenovo doesn't upload all of the firmware updates on LVFS for some reason. They probably just forgot to.
- TXT needs Hyperthread to be enabled in firmware settings. Just let Qubes disable Hyperthread in the OS instead.

## IOMMU groups:

```
IOMMU Group 0:
	00:02.0 VGA compatible controller [0300]: Intel Corporation CoffeeLake-H GT2 [UHD Graphics 630] [8086:3e9b] (rev 02)
IOMMU Group 1:
	00:00.0 Host bridge [0600]: Intel Corporation Device [8086:3e20] (rev 0d)
IOMMU Group 2:
	00:01.0 PCI bridge [0604]: Intel Corporation 6th-10th Gen Core Processor PCIe Controller (x16) [8086:1901] (rev 0d)
	01:00.0 VGA compatible controller [0300]: NVIDIA Corporation TU104GLM [Quadro RTX 4000 Mobile / Max-Q] [10de:1eb6] (rev a1)
	01:00.1 Audio device [0403]: NVIDIA Corporation TU104 HD Audio Controller [10de:10f8] (rev a1)
	01:00.2 USB controller [0c03]: NVIDIA Corporation TU104 USB 3.1 Host Controller [10de:1ad8] (rev a1)
	01:00.3 Serial bus controller [0c80]: NVIDIA Corporation TU104 USB Type-C UCSI Controller [10de:1ad9] (rev a1)
IOMMU Group 3:
	00:04.0 Signal processing controller [1180]: Intel Corporation Xeon E3-1200 v5/E3-1500 v5/6th Gen Core Processor Thermal Subsystem [8086:1903] (rev 0d)
IOMMU Group 4:
	00:08.0 System peripheral [0880]: Intel Corporation Xeon E3-1200 v5/v6 / E3-1500 v5 / 6th/7th/8th Gen Core Processor Gaussian Mixture Model [8086:1911]
IOMMU Group 5:
	00:12.0 Signal processing controller [1180]: Intel Corporation Cannon Lake PCH Thermal Controller [8086:a379] (rev 10)
IOMMU Group 6:
	00:14.0 USB controller [0c03]: Intel Corporation Cannon Lake PCH USB 3.1 xHCI Host Controller [8086:a36d] (rev 10)
	00:14.2 RAM memory [0500]: Intel Corporation Cannon Lake PCH Shared SRAM [8086:a36f] (rev 10)
IOMMU Group 7:
	00:15.0 Serial bus controller [0c80]: Intel Corporation Cannon Lake PCH Serial IO I2C Controller #0 [8086:a368] (rev 10)
	00:15.1 Serial bus controller [0c80]: Intel Corporation Cannon Lake PCH Serial IO I2C Controller #1 [8086:a369] (rev 10)
IOMMU Group 8:
	00:16.0 Communication controller [0780]: Intel Corporation Cannon Lake PCH HECI Controller [8086:a360] (rev 10)
IOMMU Group 9:
	00:1b.0 PCI bridge [0604]: Intel Corporation Cannon Lake PCH PCI Express Root Port #17 [8086:a340] (rev f0)
IOMMU Group 10:
	00:1b.4 PCI bridge [0604]: Intel Corporation Cannon Lake PCH PCI Express Root Port #21 [8086:a32c] (rev f0)
IOMMU Group 11:
	00:1c.0 PCI bridge [0604]: Intel Corporation Cannon Lake PCH PCI Express Root Port #1 [8086:a338] (rev f0)
IOMMU Group 12:
	00:1c.5 PCI bridge [0604]: Intel Corporation Cannon Lake PCH PCI Express Root Port #6 [8086:a33d] (rev f0)
IOMMU Group 13:
	00:1c.7 PCI bridge [0604]: Intel Corporation Cannon Lake PCH PCI Express Root Port #8 [8086:a33f] (rev f0)
IOMMU Group 14:
	00:1d.0 PCI bridge [0604]: Intel Corporation Cannon Lake PCH PCI Express Root Port #9 [8086:a330] (rev f0)
IOMMU Group 15:
	00:1e.0 Communication controller [0780]: Intel Corporation Cannon Lake PCH Serial IO UART Host Controller [8086:a328] (rev 10)
IOMMU Group 16:
	00:1f.0 ISA bridge [0601]: Intel Corporation Cannon Lake LPC Controller [8086:a30e] (rev 10)
	00:1f.3 Audio device [0403]: Intel Corporation Cannon Lake PCH cAVS [8086:a348] (rev 10)
	00:1f.4 SMBus [0c05]: Intel Corporation Cannon Lake PCH SMBus Controller [8086:a323] (rev 10)
	00:1f.5 Serial bus controller [0c80]: Intel Corporation Cannon Lake PCH SPI Controller [8086:a324] (rev 10)
	00:1f.6 Ethernet controller [0200]: Intel Corporation Ethernet Connection (7) I219-LM [8086:15bb] (rev 10)
IOMMU Group 17:
	02:00.0 Non-Volatile memory controller [0108]: Micron Technology Inc 3500 NVMe SSD [1344:5415] (rev 01)
IOMMU Group 18:
	03:00.0 Non-Volatile memory controller [0108]: Micron Technology Inc 3500 NVMe SSD [1344:5415] (rev 01)
IOMMU Group 19:
	04:00.0 PCI bridge [0604]: Intel Corporation JHL7540 Thunderbolt 3 Bridge [Titan Ridge 4C 2018] [8086:15ea] (rev 06)
IOMMU Group 20:
	05:00.0 PCI bridge [0604]: Intel Corporation JHL7540 Thunderbolt 3 Bridge [Titan Ridge 4C 2018] [8086:15ea] (rev 06)
IOMMU Group 21:
	05:01.0 PCI bridge [0604]: Intel Corporation JHL7540 Thunderbolt 3 Bridge [Titan Ridge 4C 2018] [8086:15ea] (rev 06)
IOMMU Group 22:
	05:02.0 PCI bridge [0604]: Intel Corporation JHL7540 Thunderbolt 3 Bridge [Titan Ridge 4C 2018] [8086:15ea] (rev 06)
IOMMU Group 23:
	05:04.0 PCI bridge [0604]: Intel Corporation JHL7540 Thunderbolt 3 Bridge [Titan Ridge 4C 2018] [8086:15ea] (rev 06)
IOMMU Group 24:
	06:00.0 System peripheral [0880]: Intel Corporation JHL7540 Thunderbolt 3 NHI [Titan Ridge 4C 2018] [8086:15eb] (rev 06)
IOMMU Group 25:
	2c:00.0 USB controller [0c03]: Intel Corporation JHL7540 Thunderbolt 3 USB Controller [Titan Ridge 4C 2018] [8086:15ec] (rev 06)
IOMMU Group 26:
	52:00.0 Network controller [0280]: Intel Corporation Wi-Fi 6 AX200 [8086:2723] (rev 1a)
IOMMU Group 27:
	54:00.0 Unassigned class [ff00]: Realtek Semiconductor Co., Ltd. RTS525A PCI Express Card Reader [10ec:525a] (rev 01)
IOMMU Group 28:
	55:00.0 Non-Volatile memory controller [0108]: Micron Technology Inc 3500 NVMe SSD [1344:5415] (rev 01)
```

## Legacy boot workaround

Check [this issue](https://github.com/QubesOS/qubes-issues/issues/8732).

This is the `/etc/grub.d/42_custom` file I use for Qubes 4.2.3:

```
#!/usr/bin/sh
exec tail -n +3 $0
# This file provides an easy way to add custom menu entries.  Simply type the
# menu entries you want to add after this comment.  Be careful not to change
# the 'exec tail' line above.

### BEGIN /etc/grub.d/42_custom ###

set gfxpayload=keep
insmod gzio
insmod part_gpt
insmod part_msdos
insmod ext2
insmod chain

search --no-floppy --set=root -l 'QUBES-R4-2-3-X86-64'

submenu 'Qubes OS R4-2-3 external installer' {
menuentry 'Install Qubes OS R4.2.3' --class qubes --class gnu-linux --class gnu --class os {
    multiboot2 /images/pxeboot/xen.gz console=none
    module2 /images/pxeboot/vmlinuz inst.repo=hd:LABEL=QUBES-R4-2-3-X86-64 plymouth.ignore-serial-consoles quiet
    module2 /images/pxeboot/initrd.img
}

menuentry 'Test media and install Qubes OS R4.2.3' --class qubes --class gnu-linux --class gnu --class os {
    multiboot2 /images/pxeboot/xen.gz console=none
    module2 /images/pxeboot/vmlinuz inst.repo=hd:LABEL=QUBES-R4-2-3-X86-64 plymouth.ignore-serial-consoles rd.live.check quiet
    module2 /images/pxeboot/initrd.img
}

menuentry 'Troubleshooting - verbose boot and Install Qubes OS R4.2.3' --class qubes --class gnu-linux --class gnu --class os {
    multiboot2 /images/pxeboot/xen.gz loglvl=all
    module2 /images/pxeboot/vmlinuz inst.repo=hd:LABEL=QUBES-R4-2-3-X86-64
    module2 /images/pxeboot/initrd.img
}

menuentry 'Rescue a Qubes OS system' --class qubes --class gnu-linux --class gnu --class os {
    multiboot2 /images/pxeboot/xen.gz console=none
    module2 /images/pxeboot/vmlinuz inst.repo=hd:LABEL=QUBES-R4-2-3-X86-64 inst.rescue quiet
    module2 /images/pxeboot/initrd.img
}

menuentry 'Install Qubes OS R4.2.3 using kernel-latest' --class qubes --class gnu-linux --class gnu --class os {
    multiboot2 /images/pxeboot/xen.gz console=none
    module2 /images/pxeboot/vmlinuz-latest inst.repo=hd:LABEL=QUBES-R4-2-3-X86-64 plymouth.ignore-serial-consoles quiet
    module2 /images/pxeboot/initrd-latest.img
}
}
### END /etc/grub.d/42_custom ###
```

## Partitioning

Drive 0 stores the host OS and less important VMs. Drive 1 and 2 run in btrfs RAID 1 and store VMs where redundancy is required. All drives will be encrypted with LUKS, and BTRFS checksum with Blake2b will provide integrity checking.

Open the shell with Control + Alt + F2 to get to the tty.

Do `ls /dev/disk/by-id` to check the serial numbers and find the correct drive. Anaconda, for whatever reason, may have different drive numbering than your firmware.

```bash
sudo fdisk /dev/nvme0n1
[Make 2 partitions. The first one with 1G and the second one with the remaining space.]
sudo cryptsetup luksFormat /dev/nvme0n1p2
sudo cryptsetup open --allow-discards --persistent /dev/nvme0n1p2 cryptroot
sudo mkfs.btrfs --csum blake2b -L qubes_dom0 /dev/mapper/cryptroot
```

Use Control + Alt + F6 to get back to Anaconda.

Install destination -> Choose the drive -> Advanced Custom (Blivet-GUI) -> Hit refresh at the bottom right -> Rescan Disks -> Done

Format the first partition as ext4, mountpoint `/boot` <br />
Btrfs subvolumes -> create new -> name root, mountpoint `/`

Finish the rest of the installation as normal.

## Post install

### BTRFS optimizations

Edit `/etc/fstab` and add the following options for the `/` mountpoint:

```
ssd,noatime,compress=zstd
```

Reboot to apply the optimizations.

### xen-pciback.hide

Add this to the Linux karg:

```
xen-pciback.hide=(01:00.0)(01:00.1)(01:00.2)(01:00.3)(00:14.0)(00:1f.6)(2c:00.0)(54:00.0)
```

### Memory configuration

Default Qubes allocates 4GB to dom0, and creates a 4GB SWAP partition. Since I have much better hardware, I opt to allocate 8GB to dom0 and use ZRAM instead.

Increase dom0 memory by editing `/etc/default/grub` and changing dom0_mem=max:8192M.

To use zram:
- `sudo qubes-dom0-update zram-generator`
- Type the following file to `/etc/systemd/zram-generator`: https://raw.githubusercontent.com/TommyTran732/Linux-Setup-Scripts/main/etc/systemd/zram-generator.conf

Reboot to apply the changes.

### Redundant VM storage

Make encrypted partition `/dev/nvme1n1p1` and `/dev/nvme2n1p1`. If the same passphrase as `/dev/nvme0n1p1` is used for encryption, all 3 drives will be unlocked with just 1 prompt during boot.

To get the filesystem UUIDs of of the 2 CRYPTO_LUKS filesystems, run

```bash
lsblk -o NAME,UUID
```

Add the following to `/etc/cryttab`:

```
cryptdata1 UUID=PUT_THE_CORRESPONDING_UUID_HERE
cryptdata2 UUID=PUT_THE_CORRESPONDING_UUID_HERE
```

Update the initramfs:

```bash
sudo dracut --regenerate-all --force
```

Make the new RAID 1 BTRFS filesystem:

```bash
sudo cryptsetup --allow-discards --persistent open /dev/nvme1n1p1 cryptdata1
sudo cryptsetup --allow-discards --persistent open /dev/nvme2n1p1 cryptdata2
sudo mkfs.btrfs --csum blake2b -m raid1 -d raid1 /dev/mapper/cryptdata1 /dev/mapper/cryptdata2
```

**Take note of the UUID**.

Run:

```bash
sudo mkdir -p /var/lib/qubes2
sudo mount /dev/disk/by-id/PUT_THE_CORRESPONDING_UUID_HERE /var/lib/qubes2
sudo btrfs subvolume create /var/lib/qubes2/data
sudo umount /var/lib/qubes2/
```

Add the following to `/etc/fstab`:
```
UUID=PUT_THE_CORRESPONDING_UUID_HERE /var/lib/qubes2 		btrfs	subvol=data,x-systemd.requires=cryptsetup.target,discard,ssd,noatime,compress=zstd 0 0
```

Finally, add the storage pool:

```bash
sudo qvm-pool add varlibqubes2 file-reflink -o dir_path=/var/lib/qubes2
```
