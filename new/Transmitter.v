`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 21.04.2020 21:29:01
// Design Name: 
// Module Name: Transmitter
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module Transmitter(
    input rst,
    input clk,
    input [9:0] Rxt,
    input rdy,
    output reg Txt,
    output reg confirm
    );
    
    reg [3:0] counter = 4'b0000;
    reg [13:0] div = 0; //max 10416
    reg state = 1'b0;
    
    always @(posedge clk or posedge rst)
    begin
        if(rst == 1'b1)
        begin
            counter <= 4'b0000;
            state <= 1'b0;
            div <= 5'd00000;
        end      
        else
        begin
            case(state)
            0 : begin
                    Txt <= 1'b1;
                    if(rdy == 1'b1)
                    begin
                        state <= 1'b1;
                        confirm <= 1'b1;
                    end
                end
            1 : begin
                    confirm <= 1'b0;
                    div <= div + 1;
                    if(div == 10416) //10416
                    begin
                        Txt <= Rxt[counter];
                        counter <= counter + 1;
                        div <= 0;
                        if(counter == 10)
                        begin
                            counter <= 0;
                            state <= 1'b0;
                        end
                    end
                end
            default :  state <= 1'b0;
            endcase
        end
    end
    
endmodule
