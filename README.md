# ASM-GameOfLife
An assembly implementation of Conway's Game of Life, using the NASM assembler and targeting Linux x86-64.

The rules of Game Of Life can be found on [Wikipedia](https://en.wikipedia.org/wiki/Conway%27s_Game_of_Life). The initial cell pattern is generated using ideas from *Middle Square Weyl Sequence RNG*, published by Bernard Widynski on 4th April 2017. The implementation relies on a finite grid, all cells outside the grid boundaries are considered as dead.

You will need to install the NASM assembler, run `make` to compile the program and simply type `./life` to launch it.

[![ASM Game Of Life](http://images.jupload.fr/1492200371.png)]


