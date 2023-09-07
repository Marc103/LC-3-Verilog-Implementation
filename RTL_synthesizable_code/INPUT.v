module INPUT (input clk,
              input [15:0] kbsr,
              input done,
              output reg recieve = 0,
              output reg [15:0] status = 16'h0000,
              output reg ld_kbsr_ext = 0);
    
    reg [3:0] cstate = 0;
    reg [3:0] nstate = 0;
    
    always@(*)
        begin
            recieve = 0;
            ld_kbsr_ext = 0;
            nstate = 0;
            case(cstate)
            0:
                if(kbsr == 1) begin recieve = 1; nstate = 1; end
                else nstate = 0;
            1:
                if(!done) begin recieve = 1; nstate = 1; end
                else nstate = 2;
            2:
                begin ld_kbsr_ext = 1; nstate = 3; end
            3:
                begin ld_kbsr_ext = 0; nstate = 4; end
            4:
                nstate = 0;
                  
            endcase
        end
        
    always@(posedge clk)
        begin
            cstate <= nstate;
        end
    
endmodule