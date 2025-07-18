#!/bin/bash
# show decimal disassembly
pasmo -o - src/Z80FC.asm | od -An -t u1 | tr -s ' ' ',' | sed 's/^,//' | sed 's/,$//'
# create TAP
zmakebas -a10 -o dist/Z80FC.tap src/Z80FC.bas
# create TZX
tap2tzx dist/Z80FC.tap
