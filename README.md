# ASM-GameOfLife
<a href="https://github.com/PyvesB/ASM-GameOfLife/blob/master/LICENSE">
<img src ="https://img.shields.io/github/license/PyvesB/ASM-GameOfLife.svg" />
</a>
<a href="https://github.com/PyvesB/ASM-GameOfLife/issues">
<img src ="https://img.shields.io/github/issues/PyvesB/ASM-GameOfLife.svg" />
</a>
<a href="https://github.com/PyvesB/ASM-GameOfLife/stargazers">
<img src ="https://img.shields.io/github/stars/PyvesB/ASM-GameOfLife.svg" />
</a>
<a href="https://github.com/PyvesB/ASM-GameOfLife/network">
<img src ="https://img.shields.io/github/forks/PyvesB/ASM-GameOfLife.svg" />
</a>

**An assembly implementation of Conway's Game of Life, using the NASM assembler and targeting Linux x86-64.**

<p align="center">
<img src ="https://github.com/PyvesB/asm-game-of-life/blob/master/screenshot.png?raw=true" />
<br/>
<i><sub>Screenshot from a Fedora workstation terminal. Have a close look and you'll be able to spot some gliders!</sub></i>
</p>

# Getting started

#### :heavy_check_mark: Requirements

To compile and run this project, you will need:
- the NASM assembler
- the GNU linker
- a Linux x64 operating system

The program can easily be modified to accommodate other operating system or assembler requirements.

#### :page_facing_up: Implementation notes

The initial cell pattern is generated using ideas from *Middle Square Weyl Sequence RNG*, published by Bernard Widynski on 4th April 2017. 

The implementation relies on a finite grid, all cells outside the grid boundaries are considered as dead.

#### :cd: Running the code

Simply use the following commands in a terminal:
```
git clone https://github.com/PyvesB/ASM-GameOfLife.git
cd ASM-GameOfLife
make
./life
```

#### :earth_americas: Useful links

The following pages may be of interest:
- [NASM manual](http://www.nasm.us/xdoc/2.13.01/html/nasmdoc0.html)
- [Game Of Life rules](https://en.wikipedia.org/wiki/Conway%27s_Game_of_Life)

# Contributing

#### `$ code`

Want to make ASM-GameOfLife better, faster, stronger? Contributions are more than welcome, open a **pull request** and share your code! Simply **fork** the repository by clicking on the icon on the top right of this page and you're ready to go!

#### :speech_balloon: Support

Thought of a cool idea? Found a problem or need some help? Simply open an [**issue**](https://github.com/PyvesB/ASM-GameOfLife/issues)!

#### :star: Thanks

Find the project useful, fun or interesting? **Star** the repository by clicking on the icon on the top right of this page!

# License 

GNU General Public License v3.0
