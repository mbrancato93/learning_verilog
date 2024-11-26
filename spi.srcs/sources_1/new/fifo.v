`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/23/2024 05:37:05 PM
// Design Name: 
// Module Name: fifo
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


module fifo#
(
    parameter   integer DATA_WIDTH  =   8,
    parameter   integer DEPTH       =   8
)(
    input                           clk,
    input                           rst_n,
    input   [ (DATA_WIDTH-1):0 ]    w_data,
    input                           we,
    input                           re,
    output reg [ (DATA_WIDTH-1):0 ] r_data,
    output                          full,
    output                          empty
);

    reg [ 1:0 ]                     we_hist;
    reg [ 1:0 ]                     re_hist;

    reg [ ($clog2(DEPTH)-1):0 ]     w_ptr;
    reg [ ($clog2(DEPTH)-1):0 ]     r_ptr;
    
    reg [ (DATA_WIDTH-1):0 ]        mem[0:DEPTH];
    
    localparam  [ 1:0 ]             RISING_EDGE =   2'b01;
    
    `define FIFO_RESET()            \
            w_ptr   =   0;          \
            r_ptr   =   0;          \
            r_data  =   0;          \
            we_hist =   0;          \
            re_hist =   0;          
            
    initial begin
        `FIFO_RESET
    end        
            
    always @( posedge clk ) begin
        if ( ~rst_n ) begin
            `FIFO_RESET
        end else begin
            we_hist             =   ( we_hist << 1 ) | we;
            re_hist             =   ( re_hist << 1 ) | re;
            if ( we_hist == RISING_EDGE && !full ) begin
                mem[w_ptr]      <=  w_data;
                w_ptr           <=  w_ptr + 1;
            end
            
            if ( re_hist == RISING_EDGE && !empty ) begin
                r_data          <=  mem[r_ptr];
                r_ptr           <=  r_ptr + 1;
            end
        end
    end
    
    assign full                 =   ( (w_ptr+1'b1) == r_ptr );
    assign empty                =   ( w_ptr == r_ptr );
    
endmodule
