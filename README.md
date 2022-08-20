Glitch Works AIM-65 Memory Test
-------------------------------

ROM-resident memory test for the Rockwell AIM-65 single-board computer.

Builds using CC65's CA65 assembler. The program automatically runs from ROM at address `0xF000`.

Pre-programmed EPROMs are available through [our Tindie store](https://www.tindie.com/products/27742/).

### Usage

Assemble the test by running `make` from the repository's directory. A Perl script will calculate and update the ROM checksum automatically. Burn the resulting binary to a 2532 EPROM, or to a 2732 EPROM if using a revision 4 or 5 AIM-65 jumpered to support it. Insert the ROM into ROM socket Z22 (`0xF000`) and power on the machine. The ROM will perform the following tests:

* ROM checksum
* Stack page quick write presence
* Zero page quick write presence
* RIOT single-pass memory test
* Full system memory test

### Stack Page Quick Write Presence

This test ensures that the stack page in low RAM is present and functional enough to run the rest of the tests. If this test fails, ensure that the low RAM ICs are installed and are good. The test operates in the following way: `0x00` is written to and then read back from addresses `0x0100` to `0x01FF`. If anything except for `0x00` is read back, the test fails and a message is displayed. `0xFF` is then written to the same range and checked. If anything except for `0xFF` is read back, the test fails with the same error.

### Zero Page Quick Write Presence

This test ensures that the zero page in low RAM is present and functional enough to run the rest of the tests. If this test fails, and the stack page test passes, the low RAM ICs are at fault. The operation of this test is identical to the stack page quick test, except that it operates in the range of `0x0000` to `0x00FF` as opposed to `0x0100` to `0x01FF`.

### RIOT Single-Pass Memory Test

This test checks the RAM of the RIOT separately. The RIOT's RAM is present at a higher memory address that is isolated from the main system memory, necessitating the use of this separate test. The RIOT's function is not needed for the main system memory test, but it is needed for the AIM-65 monitor ROM set. The test operates identically to the main system memory test (which is described in the next test description), with the exception that only the address range of `0xA400` to `0xA47F` is tested, and only one pass is performed.

### Full System Memory Test

This test tests the entire main system memory with the exception of zero page and the stack page. Before the test is run, a memory sizing routine is called which automatically determines the top of memory for the following test to test up to. The test itself then starts. The test display is shown as:

```
0200-XXXX P=YY C=ZZ
```

* `0200`: The starting address of the test. Set to `0x0200` for the full test, as this is where main memory starts. For the RIOT single-pass test, this is set to `0xA400`. Each memory test cycle starts at this address.
* `XXXX`: The ending address of the test. Set based on the autosizing routine. For the RIOT single-pass test, this is set to `0xA47F`. Each memory test cycle ends at this address before starting over for the next cycle.
* `P=YY`: The pass counter. Each pass takes 256 cycles. After 256 cycles, the pass counter increments by one. For the RIOT single-pass test, only one pass is performed.
* `C=ZZ`: The cycle counter. The cycle counter is incremented every time the memory test works its way from the starting address to the ending address. The cycle count itself is used as part of the memory test to "seed" the pattern used during that cycle. Each cycle will therefore test every single bit pattern in every byte.

If an error is encountered during the memory test, it will be displayed in the following format:

```
ERROR@XXXX E=YY R=ZZ
```

* `XXXX`: The address where the error was encountered.
* `E=YY`: The byte that was expected to be read from the address.
* `R=ZZ`: The byte that was actually read from the address.

### `checksum.pl`

This file is a Perl script that checksums generated ROM images:

```
./checksum.pl memtest.bin
```

The checksum will be displayed on the command line. If the low byte of the checksum is `0x00` the return value will be `0`; otherwise, the script will return `-1`.

If the name of a source file is provided:

```
./checksum.pl memtest.bin memtest.a65
```

...and the checksum is nonzero, the Perl script will make a backup of the ASM source file. It will then find and replace the current `SUMVAL` to correct the ROM image to a zero checksum, after reassembly. The `Makefile` handles all of this automatically.
