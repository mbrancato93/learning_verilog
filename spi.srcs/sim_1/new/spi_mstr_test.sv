`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/23/2024 06:35:40 PM
// Design Name: 
// Module Name: spi_mstr_test
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


module spi_mstr_test();

reg clk, rst, we, ss, sclk, o, rx_data_fifo_empty, rx_data_fifo_r;
reg [ 31:0 ] counter;
reg [ 7:0 ] word;
reg [ 7:0 ] red, rx_fifo_data;
reg         red_r;

initial begin
    clk     =   0;
    rst     =   0;
    we      =   0;
    counter =   0;
    word    =   8'h41;
    rx_data_fifo_r = 0;
    
    forever begin
        #8 clk = ~clk;
    end
end

always @( posedge clk ) begin
    counter = counter + 1;
    if ( counter > 4 && ~rst ) begin
        counter = 0;
        rst = 1;
    end
    
    if ( counter > 4 && rst ) begin
        we  =   1;
        @(clk) we = 0;
        counter = 0;
        #10000 we = 0;
    end
    
    if ( ~rx_data_fifo_empty ) begin
        rx_data_fifo_r = 1;
        #16 rx_data_fifo_r = 0;
    end
end

spi_mstr_ #( .CLK_DIV(4), .BIG_ENDIAN(1) ) spi( .clk(clk), .rst_n(rst), .we(we), .word(word), 
               .SS(ss), .SCLK(sclk), .MOSI(o), .MISO(o), .rx_data(red), .rx_data_r(red_r),
               .rx_data_fifo_empty(rx_data_fifo_empty), .rx_data_fifo(rx_fifo_data),
               .rx_data_fifo_r(rx_data_fifo_r), .response_words(2) );

endmodule
