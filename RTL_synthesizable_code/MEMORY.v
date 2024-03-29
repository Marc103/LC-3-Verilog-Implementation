module Sram(input clk,
            input [15:0] data,
	        input [15:0] addr,
	        input mem_en, 
            input rw,
            output reg r = 0, 
	        output [15:0] out);

	reg [15:0] ram[1023:0];
	reg [15:0] addr_reg = 0;

    // Initialize RAM contents here
    initial
        begin
            ram[0]  = 16'b0100100000000011; // JSR 3
            ram[1]  = 16'h01F4; // String pointer (500)
            ram[2]  = 16'h0008; // Return pointer
            ram[3]  = 16'h00C8; // DisplayChar function pointer
            ram[4]  = 16'b0010001111111100; // LD R1 -4 *load R1 with string pointer
            ram[5]  = 16'b0010010111111100; // LD R2 -4 *load R2 with return pointer
            ram[6]  = 16'b0010011111111100; // LD R3 -4 *load R3 with DisplayChar function pointer
            ram[7]  = 16'b0100100100100100; // JSR 292  * JSR to DisplayString function (at 300)
            
            ram[8]  = 16'b0100100000000011; // JSR 3
            ram[9]  = 16'h0258; // String pointer (600)
            ram[10] = 16'h0012; // Return pointer
            ram[11] = 16'h0064; // InputChar function pointer
            ram[12] = 16'h00C8; // DisplayChar function pointer
            ram[13] = 16'b0010001111111011; // LD R1 -5
            ram[14] = 16'b0010010111111011; // LD R2 -5
            ram[15] = 16'b0010011111111011; // LD R3 -5
            ram[16] = 16'b0010100111111011; // LD R4 -5
            ram[17] = 16'b0100100101111110; // JSR 382 * JSR to InputString function (at 400)
            
            ram[18] = 16'b0100100000000011; // JSR 3
            ram[19] = 16'h0213;  
            ram[20] = 16'h001A; 
            ram[21] = 16'h00C8;
            ram[22] = 16'b0010001111111100; // LD R1 -4
            ram[23] = 16'b0010010111111100; // LD R2 -4
            ram[24] = 16'b0010011111111100; // LD R3 -4
            ram[25] = 16'b0100100100010010; // JSR 274
            
            ram[26] = 16'b0100100000000011; // JSR 3
            ram[27] = 16'h0258;
            ram[28] = 16'h0022;
            ram[29] = 16'h00C8;
            ram[30] = 16'b0010001111111100; // LD R1 -4
            ram[31] = 16'b0010010111111100; // LD R2 -4
            ram[32] = 16'b0010011111111100; // LD R3 -4
            ram[33] = 16'b0100100100001010; // JSR 266
            
            ram[34] = 16'b0100100000000011; // JSR 3
            ram[35] = 16'h021D;
            ram[36] = 16'h002A;
            ram[37] = 16'h00C8;
            ram[38] = 16'b0010001111111100; // LD R1 -4
            ram[39] = 16'b0010010111111100; // LD R2 -4
            ram[40] = 16'b0010011111111100; // LD R3 -4
            ram[41] = 16'b0100100100000010; // JSR 258
            
            ram[42] = 16'b0000111111111111; // BR NZP -1 (Basically halt)
            
            // Input Char function
            ram[99]  = 16'h03F0;
            // JSR down below
            ram[100] = 16'b0101101101100000; // AND R5 R5 0 * clear R5
            ram[101] = 16'b0001101101100001; // ADD R5 R5 1 * set R5
            ram[102] = 16'b0010110111111100; // LD R6 -4    * set R6 to point to mmio
            ram[103] = 16'b0111101110000001; // STR R5 R6 1 * KBSR set
            ram[104] = 16'b0110101110000001; // LDR R5 R6 1 * poll KBSR
            ram[105] = 16'b0000001111111110; // BR 001 -2   * wait
            ram[106] = 16'b0110000110000000; // LDR R0 R6 0 * load input into R0
            ram[107] = 16'b1100000111000000; // JMP R7      * return from JSR
            
            
            // Display Char function
            ram[199] = 16'h03F0;
            // JSR down below
            ram[200] = 16'b0101101101100000; // AND R5 R5 0 * clear R5
            ram[201] = 16'b0001101101100001; // ADD R5 R5 1 * set R5
            ram[202] = 16'b0010110111111100; // LD R6 -4    * set R6 to point to mmio
            ram[203] = 16'b0111000110000010; // STR R0 R6 2 * DDR loaded
            ram[204] = 16'b0111101110000011; // STR R5 R6 3 * DSR set
            ram[205] = 16'b0110101110000011; // LDR R5 R6 3 * poll DSR
            ram[206] = 16'b0000001111111110; // BR 001 -2   * wait till finish
            ram[207] = 16'b1100000111000000; // JMP R7      * return from JSR
            
            // Display String function
            ram[300] = 16'b0110000001000000; // LDR R0 R1 0 
            ram[301] = 16'b0000010000000011; // BR 010 3
            ram[302] = 16'b0100000011000000; // JSRR R3
            ram[303] = 16'b0001001001100001; // ADD R1 R1 1
            ram[304] = 16'b0000111111111011; // BR 111 -5
            ram[305] = 16'b1100000010000000; // JMP R2 
            
            // Input String function
            ram[399]  = 16'hFFF3;             //                * negative value of 'enter' (aka carraige return) ascii code, -13 
            ram[400]  = 16'b0100000011000000; // JSRR R3        * Input char
            ram[401]  = 16'b0010101111111101; // LD R5 -3       * Very important to do this AFTER input (InputChar uses R5)
            ram[402]  = 16'b0101110110100000; // AND R6 R6 0    * clear R6
            ram[403]  = 16'b0001110000000101; // ADD R6 R0 R5   * 
            ram[404]  = 16'b0000010000000100; // BR Z 4         * Check if 'enter' ascii code
            ram[405]  = 16'b0111000001000000; // STR R0 R1 0    * Store char at pointer
            ram[406]  = 16'b0001001001100001; // ADD R1 R1 1    * increment pointer
            ram[407]  = 16'b0100000100000000; // JSRR R4        * Display char
            ram[408]  = 16'b0000111111110111; // BR NZP -9      * Loop back to input char
            ram[409]  = 16'b0101000000100000; // AND R0 R0 0    *
            ram[410]  = 16'b0111000001000000; // STR R0 R1 0    * Store null terminating value
            ram[411]  = 16'b1100000010000000; // JMP R2         * return from subroutine
            
            // String "Hello World!\nEnter your name:"
            ram[500] = 16'h0048; // H
            ram[501] = 16'h0065; // e
            ram[502] = 16'h006C; // l
            ram[503] = 16'h006C; // l
            ram[504] = 16'h006F; // o
            ram[505] = 16'h0020; // space 
            ram[506] = 16'h0057; // W
            ram[507] = 16'h006F; // o 
            ram[508] = 16'h0072; // r 
            ram[509] = 16'h006C; // l 
            ram[510] = 16'h0064; // d 
            ram[511] = 16'h0021; // !
            ram[512] = 16'h000D; // CR (and implicit newline interpretation) 
            ram[513] = 16'h0045; // E
            ram[514] = 16'h006E; // n
            ram[515] = 16'h0074; // t
            ram[516] = 16'h0065; // e
            ram[517] = 16'h0072; // r
            ram[518] = 16'h0020; // space
            ram[519] = 16'h0079; // y
            ram[520] = 16'h006F; // o
            ram[521] = 16'h0075; // u
            ram[522] = 16'h0072; // r
            ram[523] = 16'h0020; // space 
            ram[524] = 16'h006E; // n 
            ram[525] = 16'h0061; // a 
            ram[526] = 16'h006D; // m 
            ram[527] = 16'h0065; // e
            ram[528] = 16'h003A; // :  
            ram[529] = 16'h0020; // space 
            ram[530] = 16'h0000; 
            
            // String "\nWelcome "
            ram[531] = 16'h000D; // CR
            ram[532] = 16'h0057; // W
            ram[533] = 16'h0065; // e
            ram[534] = 16'h006C; // l
            ram[535] = 16'h0063; // c
            ram[536] = 16'h006F; // o
            ram[537] = 16'h006D; // m 
            ram[538] = 16'h0065; // e
            ram[539] = 16'h0020; // space 
            ram[540] = 16'h0000;
            
            // String ", to LC-3."
            ram[541] = 16'h002C; // ,
            ram[542] = 16'h0020; // space
            ram[543] = 16'h0074; // t
            ram[544] = 16'h006F; // o
            ram[545] = 16'h0020; // space
            ram[546] = 16'h004C; // L
            ram[547] = 16'h0043; // C
            ram[548] = 16'h002D; // -
            ram[549] = 16'h0033; // 3
            ram[550] = 16'h002E; // .
            ram[551] = 16'h0000;
                 
        end
    
	
	always @ (posedge clk)
	    begin
		    if (rw & mem_en) begin
			    ram[addr] <= data;
                r <= 1;
            end
            else if (!rw & mem_en) begin
                addr_reg <= addr;
                r <= 1;
            end
            else
                r <= 0;
	    end
		
	assign out = ram[addr_reg];

endmodule

// Memory Mappend IO, starting from 03F0 (1008)
// 03F0 - KBDR (input)
// 03F1 - KBSR
// 03F2 - DDR  (output)
// 03F3 - DSR

module AddrCtrl(input [15:0] mar,
                input mio_en,
                input rw,
                output mem_en,
                output reg [1:0] inmux_sel,
                output reg ld_kbsr,
                output reg ld_ddr,
                output reg ld_dsr);

    always@(*)
        begin
            ld_kbsr = 0;
            ld_ddr = 0;
            ld_dsr = 0;
            inmux_sel = 2'b11;
            if(mio_en)
                case(mar)
                    16'h03F0: inmux_sel = 2'b00;
                    16'h03F1: // Input - Keyboard status register
                            if(rw) ld_kbsr = 1;
                            else inmux_sel = 2'b01;
                    16'h03F2: 
                            if(rw) ld_ddr = 1;
                    16'h03F3:  // Output - Data status register
                            if(rw) ld_dsr = 1;
                            else inmux_sel = 2'b10;
                    default:;
                endcase
         end
        
        assign mem_en = mio_en;
        
endmodule

