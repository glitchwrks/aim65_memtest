# R6501 Memory Test

Memory Test for Rockwell R6501 CPUs

Builds using CC65's CA65 assembler. The program loads in at address $0200.

## Usage

Commands are: T, L, C

### [T] Test Memory

**Usage:** `T:<start>,<end>`

**Example:** `T04002000` to test RAM from 0400 to 1FFF

Address will count up, for each loop that completes successfully an X will be displayed on the screen. If an error is encountered, the address will be displayed with the written content and the read content. Press `<CR>` to restart the program.

The test pattern uses a value derived from the current address and the current memory test pass. The function is: `xor( xor( ADDRESS_LOW, ADDRESS_HIGH ), PASS_COUNT )`

### [L] Load Memory

**Usage:** `L:<start>,<end>=<data>`

**Example:** `L04002000FF` to fill 0400 to 1FFF with FF

A "\*" is printed when complete. Press `<CR>` to restart the program.

### [C] Compare Memory

**Usage:** `C:<start>,<end>=<data>`

**Example:** `C04000500FF` to check 0400-04FF for FF

A "\*" is printed when complete. If an error is encountered, the address will be displayed with the expected content and the read content. Press `<CR>` to restart the program.
