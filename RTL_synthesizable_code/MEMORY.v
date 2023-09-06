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
            ram[0] = 16'b0001000000100111; // ADD R0 R0  7
            ram[1] = 16'b0000110111111110; // BR 110 -1
            ram[2] = 16'b0001000000110000; // ADD R0 R0 -2^4
            ram[3] = 16'b0000110111111100; // BR 110 -4
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

