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
            //ram[0] = 16'h0040;
            //ram[1] = 16'b0010000111111110;
            //ram[2] = 16'b0100100011000101;
            
            ram[0] = 16'b01001000000011; // JSR 3
            ram[1] = 16'h01F4; // String pointer (500)
            ram[2] = 16'h0008; // Return pointer
            ram[3] = 16'h00C8; // DisplayChar function pointer
            ram[4] = 16'b0010001111111100; // LD R1 -4 *load R1 with string pointer
            ram[5] = 16'b0010010111111100; // LD R2 -4 *load R2 with return pointer
            ram[6] = 16'b0010011111111100; // LD R3 -4 *load R3 with DisplayChar function pointer
            ram[7] = 16'b0100100100100100; // JSR 292  * JSR to DisplayString function (at 300)
            
            
            // Input Char code
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
            
            
            // Display Char code
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
            
            // Display String
            ram[300] = 16'b0110000001000000; // LDR R0 R1 0
            ram[301] = 16'b0000010000000011; // BR 010 3
            ram[302] = 16'b0100000011000000; // JSRR R3
            ram[303] = 16'b0001001001100001; // ADD R1 R1 1
            ram[304] = 16'b0000111111111011; // BR 111 -5
            ram[305] = 16'b1100000010000000; // JMP R2 
            
            ram[500] = 16'h0048; // H
            ram[501] = 16'h0065; // e
            ram[502] = 16'h006C; // l
            ram[503] = 16'h006C; // l
            ram[504] = 16'h006F; // o
            ram[505] = 16'h0020; // Space 
            ram[506] = 16'h0057; // W
            ram[507] = 16'h006F; // o 
            ram[508] = 16'h0072; // r 
            ram[509] = 16'h006C; // l 
            ram[510] = 16'h0064; // d 
            ram[511] = 16'h0021; // ! 
            ram[512] = 16'h0000; // null terminating
            
            
            
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

