`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 24.04.2020 11:13:25
// Design Name: 
// Module Name: TOP
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


module TOP(
    input clk,
    input rst,
    input RXd,
    output TXd
    );
    
    wire [9:0] tx;
    wire confirm;
    wire rdy;
    
    Receiver RX(
        .clk (clk),
        .rst (rst),
        .RXr (RXd),
        .TXr (tx),
        .confirm (confirm),
        .rdy (rdy)
    );
    
    Transmitter TX(
        .clk (clk),
        .rst (rst),
        .Rxt (tx),
        .rdy (rdy),
        .Txt (TXd),
        .confirm (confirm)
    );
endmodule
