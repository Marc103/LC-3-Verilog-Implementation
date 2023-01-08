module MEMORY(input i_Clk,
              input RW,
              input MEM_EN,
              input [15:0] MAR_OUT,
              input [15:0] MDR_OUT,
              output [15:0] OUT,
              output R);
    // Basys 3 has 1,800 Kbits of BRAM
    // this is 1834200 bits in total
    // % 6, gives 115200 16-bit instructions
    // so lets use a quarter of it

    reg [15:0] ram [28800];
    reg [15:0] tmp;

    // we should also include the .mem init
    // somewhere here so that we can load our program

    always @(posedge i_Clk)
        begin
            if (MEM_EN & RW)
                begin
                    ram[MAR_OUT] = MDR_OUT;     // purposefully using blocking
                    R = 1;                      // to ensure R is 1 when done
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

    assign OUT = ram[MAR_OUT];
endmodule

        

