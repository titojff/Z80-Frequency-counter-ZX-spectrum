#!/bin/bash
# show decimal disassembly
pasmo -o - Z80FC.asm | od -An -t u1 | tr -s ' ' ',' | sed 's/^,//' | sed 's/,$//'
# create TAP
zmakebas -a10 -o Z80FC.tap Z80FC.bas
# create TZX
tap2tzx Z80FC.tap
