`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Chrzan
// 
// Create Date: 17.03.2020 17:34:27
// Design Name: 
// Module Name: Receiver
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


module Receiver(
    input clk,
    input rst,
    input RXr,          //dane przychodzace
    output [9:0] TXr,   //dane wystawiane do nadajnika
    input confirm,      //sygnal potwierdzajacy przyjecie danych przez nadajnik (1 -> potwierdzenie)
    output rdy          //sygnal dla nadajnika, mowiacy o gotowosci danych (1 -> dane gotowe do wyslania w swiat)
    );
    
    integer counter = 0;
    reg [7:0] data = 8'b11111111;
    reg [13:0] div = 0;
    reg [12:0] div_2 = 0;
    reg [7:0] add = 8'b00100000;
    reg state = 1'b0;
    reg ready = 1'b0;
    
    assign TXr = {1'b1,data,1'b0};
    assign rdy = ready;
    
    always @ (posedge clk or posedge rst)
    begin
//reset asynchroniczny
       if(rst == 1'b1)
       begin
          data <= 8'b11111111;
          counter <= 0;
          state <= 1'b0;
          div <= 0;
          div_2 <= 0;
          ready <= 1'b0;
       end
       else
       begin
//potwierdzenie przyjecia danych do wyslania
          if (confirm == 1'b1)
            ready <= 1'b0;
// przyjecie bitu startu
          if(RXr == 1'b0 && state == 1'b0)
          begin
             div_2 = div_2 + 1;
             if(div_2 == 5208)  //5208
             begin
                div_2 <= 0;
                state <= 1'b1;
             end
          end
// przyjecie danych          
          if (state == 1'b1 && counter <8)
          begin
             div_2 <= 0;
             div <= div + 1;
             if (div == 10416) //10416
             begin
                div <= 0;
                data[counter] <= RXr;
                counter = counter + 1;
             end
          end
 //wystawienie danych do wyslania (wraz z bitem startu/stopu i dodana liczba "20h")         
          if(state == 1'b1 && counter == 8)
          begin
            div_2 = div_2 + 1;
             if(div_2 == 5208)    //5208
             begin
                counter <= 0;
                data <= data + add;
                ready <= 1'b1;
                state <= 1'b0;
                div <= 0;
                div_2 <=0;
             end
          end
       end
    end
endmodule


