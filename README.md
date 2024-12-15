# QubesOS-Scripts

[![ShellCheck](https://github.com/TommyTran732/QubesOS-Scripts/actions/workflows/shellcheck.yml/badge.svg)](https://github.com/TommyTran732/QubesOS-Scripts/actions/workflows/shellcheck.yml)

My scripts for setting up QubesOS. 

For each OS, run the script associated with them to trim down the templates provided by Qubes first. For example, for Fedora, run the `fedora-gnome.sh` script. After the base templates have been trimmed down, run other scripts in templates based on them to create their respective TemplateVMs.

If you want to install Flatpak packages, install them inside of an AppVM as a **user Flatpak** and enable the update-user-flatpaks.service as a **user** systemd service for automatic updates.

It is recommended that you follow the docs [here](https://www.qubes-os.org/doc/vm-sudo/#replacing-passwordless-root-access-with-dom0-user-prompt) to make a prompt for root access on non-minimal VMs. dom0.sh already takes care of dom0 so you only need to worry about the guests. Skip whonix-gateway as it will create an annoying prompt every time a VM attached to it boots.

## Laptop Recommendations

Qubes AEM currently still requires legacy boot. While the last generation of Intel CPUs with VBIOS to support legacy boot is Coffee Lake officially, I have found that certain Comet Lake Thinkpads still have legacy support. Unfortunately, all of them seems to only support U series CPU. You can check [Lenovo's BIOS simulator](https://download.lenovo.com/bsco/index.html#/) for models with legacy boot support.

Alternatively, you should consider Coffee Lake mobile workstation Thinkpads. These have the longest support life cycle outside of the Comet Lake Thinkpads, and they support much more powerful H series CPUs. Perrsonally, I am using a P53 with an i9-9880H.

### Thinkpad P53 IOMMU groups:

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

### Lenovo ePrivacy

Lenovo ePrivacy can be controlled through `/proc/acpi/ibm/lcdshadow`. I use the following shortcuts:

- F5: `sudo bash -c 'echo 1 > /proc/acpi/ibm/lcdshadow'`
- F6: `sudo bash -c 'echo 0 > /proc/acpi/ibm/lcdshadow'`
