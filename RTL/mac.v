`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10.04.2026 20:04:39
// Design Name: 
// Module Name: conv
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


module conv(
input        i_clk,
input [71:0] i_pixel_data,
input        i_pixel_data_valid,
output reg [7:0] o_convolved_data,
output reg   o_convolved_data_valid
    );
   parameter BRIGHTNESS = 40; 
integer i; 
reg [7:0] kernel [8:0];
reg [15:0] multData[8:0];
reg [15:0] sumDataInt;
reg [15:0] sumData;
reg multDataValid;
reg sumDataValid;
reg convolved_data_valid;

initial
begin
       kernel[0]=0; 
       kernel[1]=0;
       kernel[2]=0;
       kernel[3]=0;
       kernel[4]=1;
       kernel[5]=0;
       kernel[6]=0; 
       kernel[7]=0;
       kernel[8]=0;
end    
    
always @(posedge i_clk)
begin
    for(i=0;i<9;i=i+1)
    begin
        multData[i] <= kernel[i]*i_pixel_data[i*8+:8];
    end
    multDataValid <= i_pixel_data_valid;
end


always @(*)
begin
    sumDataInt = 0;
    for(i=0;i<9;i=i+1)
    begin
        sumDataInt = sumDataInt + multData[i];
    end
end

always @(posedge i_clk)
begin
    sumData <= sumDataInt;
    sumDataValid <= multDataValid;
end
    
//always @(posedge i_clk)
//begin
//    o_convolved_data <= sumData;
//    o_convolved_data_valid <= sumDataValid;
//end


always @(posedge i_clk) 
begin
    if(sumDataValid) begin
        if(sumData - BRIGHTNESS < 0)
            o_convolved_data <= 0;
        else
            o_convolved_data <= sumData - BRIGHTNESS;  // darken
    end
    o_convolved_data_valid <= sumDataValid;
end
    
endmodule
