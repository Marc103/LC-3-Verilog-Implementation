module OUTPUT(input clk,
              input [15:0] dsr,
              input done,
              output reg send = 0,
              output reg [15:0] status = 16'h0000,
              output reg ld_dsr_ext = 0);
    
    reg [3:0] cstate = 0;
    reg [3:0] nstate = 0;
    
    always@(*)
        begin
            send = 0;
            ld_dsr_ext = 0;
            nstate = 0;
            case(cstate)
            0:
                if(dsr == 1) begin send = 1; nstate = 1; end
                else nstate = 0;
            1:
                begin send = 0; nstate = 2; end
            2:
                if(!done)  nstate = 2;
                else nstate = 3;
            3:
                begin ld_dsr_ext = 1; nstate = 4; end
            4:
                begin ld_dsr_ext = 0; nstate = 5; end
            5:
                nstate = 0;
                  
            endcase
        end
        
    always@(posedge clk)
        begin
            cstate <= nstate;
        end
    
endmodule