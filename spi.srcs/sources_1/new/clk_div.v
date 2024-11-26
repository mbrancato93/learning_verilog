`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/23/2024 05:26:25 PM
// Design Name: 
// Module Name: clk_div
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


module clk_div#
(
    parameter   integer     START_VAL   =   0,
    parameter   integer     RESET_HIGH  =   1
)(
    input           clk,
    input [ 31:0 ]  divisor,
    input           rst,
    output reg      divd,
    output          rising,
    output          falling
);

    reg [ 31:0 ]    counter;
    reg             divd_lat;
    
    initial begin
        counter     =   0;
        divd        =   START_VAL;
        divd_lat    =   START_VAL;
    end
    
    always @( posedge clk ) begin
        if ( ( rst & RESET_HIGH ) | ( ~rst & !RESET_HIGH ) ) begin
            divd_lat    =   START_VAL;
            divd        =   START_VAL;
            counter     =   0;
        end else begin
            divd_lat    =   divd;
            if ( counter    ==  0 ) begin
                divd    =   ~divd;
            end
            counter     =   counter + 1;
            if ( counter > divisor ) begin
                counter =   0;
            end
        end 
    end
    
    assign  rising  =   ( counter == 1 ) & ( divd_lat == 0 );
    assign  falling =   ( counter == 1 ) & ( divd_lat == 1 );
endmodule
