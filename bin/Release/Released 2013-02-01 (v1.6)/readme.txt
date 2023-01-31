1. Overview

	VDK-80 is the short for "TRS-80 Virtual Disk Kit". This program is capable of performing
 	a series of operations (Read, Write, Rename, Delete etc.) on TRS-80 virtual disk images.

	A virtual disk image is the conversion of a real floppy disk into a PC file. There are 
	three standards being used for such conversions and all of them are supported by VDK-80.

	The data structures in a disk differ from DOS to DOS. VDK-80 takes them all into account,
	allowing manipulation of files and other disk areas.

	The ultimate goal of this project is to have the entire matrix of known TRS-80 I/III/4 
	Disk Operating Systems covered in VDK-80. We're almost there!

2. Supported Operations

	- Read and Write files from/to disk images
	- Rename or Delete existing files
	- Dump file and/or disk contents

3. Supported Operating Systems

	- All known TRS-80 model I/III/4 Operating Systems are supported, except CP/M.

4. Known limitations

	- Some *data* disks aren't recognized by VDK-80
	- The program lacks a graphical user interface
	- CP/M support is still under development

5. Known bugs

	- A file written to a TRSDOS 1.1 or 1.2 disk will have an incorrect Records count (one less than the right number).
	- A file written to an Esoteric DOS disk will be inaccessible, maybe due to password algorithm differences.

6. Contact

	I'd be glad to hear from you! Send me a message at mdutra@mdutra.com.

	Miguel Dutra
