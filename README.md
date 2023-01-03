# LC-3-Verilog-Implementation
I will be implementing the LC-3 ISA specifications in Verilog.
the LC-3 ISA can be found at "introduction to computing systems" by Yale N. Patt and Sanjay J. Patel.

This project was inpsired by Professor Kyle Hale's LC-3 implementation in
another hardware design language called Chisel, see https://github.com/khale/iit3503-starter.

In order to have a full understanding of the LC-3, I thought it would be a good idea
to do a fresh implementation using Verilog from scratch. The end goal is to synthesize
the verilog onto an FPGA and have a program (written in LC-3 assembly) display
"hello world" on the screen.

Also i learnt a lot of FPGA stuff from "https://nandland.com/" by Russel Merrick.

-- Update 01/01/2023 --
 - To simplify this project, there will be no ACV or interrupts, just branching for looping
 - the character to output will be a hardcoded opcode 
 so the functioning of this implementation will be only output (of a single char at a time)
 and the input (implicity) will be the program that the memory is initialized with (no input)


