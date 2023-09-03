module MEMORY(input i_Clk,
              input RW,
              input MEM_EN,
              input [15:0] MAR_OUT,
              input [15:0] MDR_OUT,
              output [15:0] OUT ,
              output reg R = 0,
              input R_MMIO);
    // Basys 3 has 1,800 Kbits of BRAM
    // this is 1834200 bits in total
    // % 6, gives 115200 16-bit instructions
    // so lets use a quarter of it

    reg [15:0] ram [32768:0];
    reg [15:0] tmp = 16'h0000;
    reg [2:0] mmio_ticks = 0;
            
    // we should also include the .mem init
    // somewhere here so that we can load our program
    initial 
        begin
            ram[0] = 16'b0111000001000010;
            ram[1] = 16'b0111010001000011;
            ram[2] = 16'b0110011001000011;
            ram[3] = 16'b0000001111111110;
            ram[4] = 16'b0100111111111011;
            
        end

    always @(posedge i_Clk)
        begin
            if (MEM_EN & RW)
                begin
                    ram[MAR_OUT] = MDR_OUT;     // purposefully using blocking
                    R = 1;
                                         // to ensure R is 1 when done
                end
            else if (MEM_EN & !RW)
                begin
                    tmp = ram[MAR_OUT];
                    R = 1;
                end
                
            else if (!MEM_EN & R_MMIO) begin
                if(mmio_ticks == 2)
                    begin
                    R = 1;
                    mmio_ticks = 0;
                    end
                else
                    mmio_ticks = mmio_ticks + 1;
            end
            
            else                  R = 0;
            
                
        end

    assign OUT = tmp;
endmodule
// RW -> 1 means write, 0 means read
// Memory mapped IO
// xFF00 -> KBDR
// xFF01 -> KBSR
// xFF02 -> DDR
// xFF03 -> DSR
module  ADDR_CTRL(input [15:0] mar_out,
                  input MIO_EN,
                  input RW,
                  output reg MEM_EN,
                  output reg [1:0] INMUX_SEL = 2'b11,
                  output reg LD_KBSR = 0,
                  output reg LD_DSR = 0,
                  output reg LD_DDR = 0,
                  output reg R_MMIO = 0);

    always @(*)
        begin
            MEM_EN = 0;
            INMUX_SEL = 2'b11;
            LD_KBSR = 0;
            LD_DDR = 0;
            LD_DSR = 0;
            R_MMIO = 0;
            
            if(MIO_EN)
                begin
                    if      (mar_out == 16'hFF00 & !RW) begin INMUX_SEL = 2'b00; R_MMIO = 1; end
                    else if (mar_out == 16'hFF01 & !RW) begin INMUX_SEL = 2'b01; R_MMIO = 1; end 
                    else if (mar_out == 16'hFF03 & !RW) begin INMUX_SEL = 2'b10; R_MMIO = 1; end
                    else if (mar_out == 16'hFF01 &  RW) begin LD_KBSR = 1;       R_MMIO = 1; end 
                    else if (mar_out == 16'hFF02 &  RW) begin LD_DDR = 1;        R_MMIO = 1; end
                    else if (mar_out == 16'hFF03 &  RW) begin LD_DSR = 1;        R_MMIO = 1; end
                    else MEM_EN = 1;   
                end
            else
                    MEM_EN = 0;
        end

endmodule  


