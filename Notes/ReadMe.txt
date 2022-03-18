This is an updated version of the Memory Test program from the OSI Small System Journal Vol 1, No.3, Sept 1977
This version will run on both serial and video system with standard OSI ROMS and with Cegmon. 
It should run on all C1/Superboard, C2/C4/C8, OSI 400 Ascii & Serial and C3 systems
Usage is the same. It now occupies space from $0236 to $03FF, with additional bits at $0129 and $0134
for the 65A prom monitor 'G' command.

Loading:
For video based 65V monitor & cegmon systems:
Reset the OSI, press 'M', then 'L'. Send the MemTest.lod file via the serial port. The program should run when finished.  It can be restarted after an OSI Reset by entering the Monitor and typing .0236G

For serial based 65A monitor systems:
Reset the OSI, press 'M' then 'L'. (Remember all OSI commands are upper case)
Send the MemTest.ser file via the serial port, raw ASCII.
When the program finishes loading it should start, if not press 'R' to stop loading, then press 'G' to begin execution.  It can be restarted after reset from the Monitor using the 'G' command.
The 65A ROM monitor uses locations $0129 to $012F to store 6502 register and jump location information needed to point the G command to the program start at $0236.

Usage Summary:
The minimum starting address is $0400, as the program resides below that. The program tests to (end address-1) thus a 2000 entered below will test up to address 1FFF

Upon starting, you will be prompted with a '?' it expects one of the commands T, L, or C.

The T (Test) command expects 2 hex address arguments the starting address and ending address.
for example enter T04002000 you will see "T:0400,2000>>" and a number counting. It will stop on memory error. For every successful pass you will see an additional X added to the screen.
If an error is encountered it will print the address written value and read value and stop.

The L (Load) command fills the specified range of memory with a hex value. It expects two hex addresses for starting and ending locations plus a 1 byte fill character.
For example enter L04002000FF you will see "L:0400,2000=FF" it will place a '*' on the line when finished.

The C (Compare) command checks the specified range of memory for a hex value. It expects two hex addresses for starting and ending locations plus a 1 byte compare character.
For example enter C04002000FF you will see "C:0400,2000=FF" it will place a '*' on the line when finished. 
If an error is encountered it will print the address written value and read value and stop.

See the accompanying original documentation for more detailed instructions.


  -Mark Spankus