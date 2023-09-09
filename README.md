# LC-3-Verilog-Implementation
I will be implementing the LC-3 ISA specifications in Verilog.
the LC-3 ISA can be found at "introduction to computing systems" by Yale N. Patt and Sanjay J. Patel.

This project was inpsired by Professor Kyle Hale's course that I took at Illinois Instititute of technology
called 'Computer Organisation and Assembly Language Programming" in Spring 2021 where he implemented the LC-3 
in another hardware design language called Chisel, see https://github.com/khale/iit3503-starter.

Other key resources I used for learning includes:
 - Basics on Verilog and FPGA, and UART modules from "https://nandland.com/" by Russel Merrick.
 - "The Verilog Hardware Description Language" fifth edition by Donald E. Thomas and Philip R. Moorby
 - Professor Adam Teman's Digital VLSI Design playlist at https://www.eng.biu.ac.il/temanad/digital-vlsi-design/ 

I would also like to give thanks to my buddy Tochi Ukegbu for writing an LC-3 assembler, 
which can be found at https://github.com/tochiu/lc3-assembler

In order to have a full understanding of the LC-3, I thought it would be a good idea
to do a fresh implementation using Verilog from scratch. The end goal is to synthesize
the verilog onto an FPGA and have a program (written in LC-3 assembly) display
"hello world" on the screen.

-- Update 01/01/2023 --
 - To simplify this project, there will be no ACV or interrupts, just branching for looping
 - the character to output will be a hardcoded opcode 
 so the functioning of this implementation will be only output (of a single char at a time)
 and the input (implicity) will be the program that the memory is initialized with (no input)

-- Update 07/01/2023 --
 - Nevermind about hardcoding output, definitely doable 
 - actually everything is looking quite feasible

-- Final Update 09/09/2023 --
 - Project is complete! The LC-3 ISA has been implemented see more details under the journey...
 - Everything was successfully implemented except for Trap routines and interrupts, which I decided wasn't needed with respect to my goal.
   That being said, it is definitely doable and might code it sometime in the future

## The Journey
When I first started writing the verilog modules, I followed the Datapath outlined in the LC-3 book and progress was smooth.
However, since it was my first time writing verilog, there were quite a few mistakes I made and so when I imported it into
Vivado IDE there were many errors. This is when (around May 2023) I decided to read the "The Verilog Hardware Description Language"
book and became somewhat proficient in verilog. Fast forward 3 months later (I was busy with a summer internship), I wrote the FSM,
Testbench and my simulations were working. I fixed up any issues that the synthesizer found and put it on my FPGA (Xilinx Basys3).
Results? Nothing, no output, no activity and using the ILA (Integrated Logic Analyzer) so I could analyze waveforms from the actual
hardware was proving futile.

What happened? I was naive and made the big (but probably classic) beginner FPGA user mistake of thinking that HDLs were magical in the sense 
that you could just code and the synthesizer would take care of the rest. Back to the drawing board... '
I knew that conceptually my understanding of the LC3 was solid but i didn't have a deep enough understanding of how the hardware works. 
So what if I had 25 latches inferred? Or that I used blocking statements in sequential logic? Or that I didn't separate my sequential and
combinational logic? It works in the behavioural simulations, why not on hardware?

All my questions were answered when I learned of RTL (Register Transfer Level) synthesizable code from Prof. Teman's VSLI Design 
playlist. Everything started clicking: combinational vs sequential logic, notion of state, flips flops vs latches, 'glitches' aka
delay propagation, how everything interacts with clock and how combinational logic feeds into the sequential logic to model, for
example, a finite state machine. At this point I fully understood how the circuitry works and rewrote basically all my code. I kept
my old code in 'OLD_dont_use' folder for history sake.

After going through the entire writing, debugging and simulating phases again (albeit at a much faster pace since conceptually I undestood
LC-3 quite well), I once again programmed my FPGA. Results? Success! I wrote a simple program that outputs of a single character on the screen.
Then I wrote another small program that inputs a single character then outputs it, which also worked. Input/Output is working, the simulations
are reflective of whats actually happening in hardware. I continued writing more assembly code and used the  assembler provided by my friend 
to translate it to machine code (otherwise shortly before I was doing it manually by hand) and eventually ended with a program that does this:

![image](https://github.com/Marc103/LC-3-Verilog-Implementation/assets/78170299/c8b2c04f-68d9-4710-adbe-f65bdd2d1aa1)
* Soon I will upload a video of it in action.

At which point I was more then satisfied and concluded the project. Initially this might seem very simple but if you want to see the machine code
look at LC-3-Verilog-Implementation\RTL_synthesizable_code\Programs\CompleteHelloWorld file. I could write more programs that do more 
complicated things if I wanted to but there's no point, my LC-3 implementation has been proven to be correct, that is, with the exception 
that I didn't implement trap routines and interrupts. Why? it's not necessary to create a Turing complete computer. However, it would
be nice if someone could implement it because I know it is definitely doable...

## General Screenshots

### Simulation Waveforms 1
![image](https://github.com/Marc103/LC-3-Verilog-Implementation/assets/78170299/eb75fb78-7fd0-49a0-a559-1ef5e573ca56)

### Simulation Waveforms *continued
![image](https://github.com/Marc103/LC-3-Verilog-Implementation/assets/78170299/86ed74e1-0239-46fd-a77c-4ab2efb73d25)

*It's hard to screenshot the synthesized designs because they are quite big, but if you have the Vivado IDE, you can open up my
project and see it there.

### Synthesized Design - Overview
![image](https://github.com/Marc103/LC-3-Verilog-Implementation/assets/78170299/d6da846a-0aed-488f-a1e4-2fa54f243292)

### Synthesized Design - Finite State Machine
![image](https://github.com/Marc103/LC-3-Verilog-Implementation/assets/78170299/e3587223-ece6-4b22-a6f2-0d9b9895cfe7)

### Synthesized Design - Datapath
![image](https://github.com/Marc103/LC-3-Verilog-Implementation/assets/78170299/20ebbd01-35e3-4e56-8184-9a00d98c02a8)

### Synthesized Design - Input/Output
![image](https://github.com/Marc103/LC-3-Verilog-Implementation/assets/78170299/9052a5ec-a2c6-43fb-96c8-f0159e963cbc)

### Initializing RAM with instructions
![image](https://github.com/Marc103/LC-3-Verilog-Implementation/assets/78170299/27076a72-66b2-41a4-a582-f4d64d1918eb)














