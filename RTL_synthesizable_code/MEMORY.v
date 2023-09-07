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
            ram[0]  = 16'b0100100000000001; // JSR 1
            ram[1]  = 16'h03F0;
            ram[2]  = 16'b0010110111111110; // LD R6 -2
            ram[3]  = 16'b0001101101100001; // ADD R5 R5 1
            ram[4]  = 16'b0111101110000001; // STR R5 R6 1
            ram[5]  = 16'b0110101110000001; // LDR R5 R6 1
            ram[6]  = 16'b0000001111111110; // BR 001 -2
            ram[7]  = 16'b0110000110000000; // LDR R0 R6 0
            ram[8]  = 16'b0111000110000010; // STR R0 R6 2
            ram[9]  = 16'b0001101101100001; // ADD R5 R5 1
            ram[10] = 16'b0111101110000011; // STR R5 R6 3
            ram[11] = 16'b0110101110000011; // LDR R5 R6 3
            ram[12] = 16'b0000001111111110; // BR 001 -2
            ram[13] = 16'b0100111111110010; // JSR -14
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

