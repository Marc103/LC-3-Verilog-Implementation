module MEMORY(input i_Clk,
              input RW,
              input MEM_EN,
              input [15:0] MAR_OUT,
              input [15:0] MDR_OUT,
              output [15:0] OUT ,
              output reg R = 0);
    // Basys 3 has 1,800 Kbits of BRAM
    // this is 1834200 bits in total
    // % 6, gives 115200 16-bit instructions
    // so lets use a quarter of it

    reg [15:0] ram [28800:0];
    reg [15:0] tmp = 16'h0000;
            
    // we should also include the .mem init
    // somewhere here so that we can load our program
    initial 
        begin
            ram[0] = 16'b0101011001000010; //5642
            ram[1] = 16'b1001100001000000;
            ram[2] = 16'b0010000000000111;
            ram[3] = 16'b0010010111111100;
            ram[4] = 16'b0110101001111011;
            ram[5] = 16'b1110111011110010;
            ram[10] = 16'hBEEF;
            
        end

    always @(posedge i_Clk)
        begin
            if (MEM_EN & RW)
                begin
                    ram[MAR_OUT] = MDR_OUT;     // purposefully using blocking
                    R = 1;
                                         // to ensure R is 1 when done
                end
            if (MEM_EN & !RW)
                begin
                    tmp = ram[MAR_OUT];
                    R = 1;
                end
            if (!MEM_EN)
                begin
                    R = 0;
                end
        end

    assign OUT = tmp;
endmodule
// RW -> 1 means write, 0 means read
// Memory mapped IO
// xFE00 -> KBDR
// xFE01 -> KBSR
// xFE02 -> DDR
// xFE03 -> DSR
module  ADDR_CTRL(input [15:0] mar_out,
                  input MIO_EN,
                  input RW,
                  output reg MEM_EN,
                  output reg [1:0] INMUX_SEL = 2'b11,
                  output reg LD_KBSR,
                  output reg LD_DSR,
                  output reg LD_DDR);

    always @(*)
        begin
            MEM_EN = 0;
            INMUX_SEL = 2'b11;
            LD_KBSR = 0;
            LD_DDR = 0;
            LD_DSR = 0;
            
            if(MIO_EN)
                begin
                    if      (mar_out == 16'hFF00 & !RW) INMUX_SEL = 2'b00;
                    else if (mar_out == 16'hFF01 & !RW) INMUX_SEL = 2'b01; 
                    else if (mar_out == 16'hFF03 & !RW) INMUX_SEL = 2'b10;
                    else if (mar_out == 16'hFF01 &  RW) LD_KBSR = 1; 
                    else if (mar_out == 16'hFF02 &  RW) LD_DDR = 1;
                    else if (mar_out == 16'hFF03 &  RW) LD_DSR = 1;
                    else MEM_EN = 1;     
                end
            else
                    MEM_EN = 0;
        end

endmodule  


