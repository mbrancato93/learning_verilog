`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/23/2024 09:33:51 PM
// Design Name: 
// Module Name: bd_test
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


module bd_test();

reg clk, ss, mosi, sclk;

initial begin
    clk = 0;
    
    forever begin
        #10 clk = ~clk;
    end
end

design_1_wrapper w( .clk(clk), .ck_io0(ss), .ck_io1(sclk), .ck_io2(mosi) );

endmodule
