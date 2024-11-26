`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/23/2024 05:32:42 PM
// Design Name: 
// Module Name: spi_mst
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


module spi_mstr_#
(
    parameter   integer FIFO_DEPTH  =   8,
    parameter   integer FIFO_WIDTH  =   8,
    parameter   integer CPOL        =   1,
    parameter   integer CPHA        =   0,
    parameter   integer CLK_DIV     =   10,
    parameter   integer SS_LATENCY  =   5,
    parameter   integer BIG_ENDIAN  =   0
)(
    input                               clk,
    input                               rst_n,
    input                               we,
    input [ (FIFO_WIDTH-1):0 ]          word,
    input [ 31:0 ]                      response_words,
    
    input                               MISO,
    output                              SS,
    output                              SCLK,
    output  reg                         MOSI,
    
    output  reg [ (FIFO_WIDTH-1):0 ]    rx_data,
    output  reg                         rx_data_r,
    output      [ (FIFO_WIDTH-1):0 ]    rx_data_fifo,
    output                              rx_data_fifo_empty,
    output                              rx_data_fifo_full,
    input                               rx_data_fifo_r
);

    // FIFO (WORDS)
    reg                         f_re;
    wire [ (FIFO_WIDTH-1):0 ]   r_data;
    wire                        f_full;
    wire                        f_empty;
    
    `define SPI_DATA_FIFO_RESET()    \
        f_re        =   0;     
    
    initial begin
        `SPI_DATA_FIFO_RESET
    end

    fifo #( .DATA_WIDTH(FIFO_WIDTH), .DEPTH(FIFO_DEPTH) )
            f( .clk(clk), .rst_n(rst_n), .we(we), .w_data(word),
               .re(f_re), .r_data(r_data), .full(f_full), .empty(f_empty) );

    // FIFO (RESPONSES)
    reg                         resp_re;
    wire [ 31:0 ]               resp_data;
    wire                        resp_full;
    wire                        resp_empty;
    
    `define SPI_RESP_FIFO_RESET()   \
        resp_re     =   0;
        
    initial begin
        `SPI_RESP_FIFO_RESET
    end

    fifo #( .DATA_WIDTH(32), .DEPTH(FIFO_DEPTH) )
            responses( .clk(clk), .rst_n(rst_n), .we(we), .w_data(response_word),
               .re(resp_re), .r_data(resp_data), .full(resp_full), .empty(resp_empty) );
               
    // FIFO (MISO)
    reg                         miso_re;
    wire [ 31:0 ]               miso_data;
    wire                        miso_full;
    wire                        miso_empty;
    
    `define SPI_MISO_FIFO_RESET()   \
        miso_re     =   0;
        
    initial begin
        `SPI_MISO_FIFO_RESET
    end
    
    fifo #( .DATA_WIDTH(FIFO_WIDTH), .DEPTH(FIFO_DEPTH) )
            f_miso( .clk(clk), .rst_n(rst_n), .we(rx_data_r), .w_data(rx_data),
                    .re(rx_data_fifo_r), .r_data(rx_data_fifo), 
                    .full(rx_data_fifo_full), .empty(rx_data_fifo_empty) );

    // SCLK
    reg                         tx_clk_active;
    reg                         rx_clk_active;
    wire                        clk_rising;
    wire                        clk_falling;

    `define SPI_SCLK_RESET()    \
        tx_clk_active   =   0;  \
        rx_clk_active   =   0;
        
    initial begin
        `SPI_SCLK_RESET
    end
    
    clk_div #( .START_VAL(CPOL) ) 
                spi_clk( .clk(clk), .rst( ~( tx_clk_active | rx_clk_active ) ),
                         .divisor(CLK_DIV), .divd(SCLK), .rising(clk_rising),
                         .falling(clk_falling) );
                         
    localparam   [ 3:0 ]                IDLE        =   1,
                                        NEXT_FIFO   =   2,
                                        LATENCY     =   3,
                                        DATA        =   4;
                            
    reg  [ 3:0 ]                        tx_curr_state;
    reg  [ 3:0 ]                        rx_curr_state;
    
    reg                                 tx_hold_ss;
    reg                                 rx_hold_ss;
    
    reg [ 31:0 ]                        tx_counter;
    reg [ 31:0 ]                        rx_counter;
    
    reg [ ($clog2(FIFO_WIDTH)-1):0 ]    tx_word_ptr;
    reg [ ($clog2(FIFO_WIDTH)-1):0 ]    rx_word_ptr;
    reg [ 31:0 ]                        remaining_responses;
   
    `define SPI_MAIN_RESET()            \
        tx_curr_state       =   IDLE;   \
        rx_curr_state       =   IDLE;   \
        tx_hold_ss          =   0;      \
        rx_hold_ss          =   0;      \
        tx_counter          =   0;      \
        rx_counter          =   0;      \
        tx_word_ptr         =   0;      \
        rx_word_ptr         =   0;      \
        MOSI                =   0;      \
        rx_data             =   0;      \
        rx_data_r           =   0;      \
        remaining_responses =   0;
        
    initial begin
        `SPI_MAIN_RESET
    end
   
    always @( posedge clk ) begin
        if ( ~rst_n ) begin
            `SPI_DATA_FIFO_RESET
            `SPI_RESP_FIFO_RESET
            `SPI_SCLK_RESET
            `SPI_MAIN_RESET
        end else begin
            case ( tx_curr_state )
                IDLE:
                    begin
                        if ( ~f_empty ) begin
                            f_re            <=  1;
                            resp_re         <=  1;
                            tx_curr_state   <=  NEXT_FIFO;
                        end else begin
                            if ( clk_rising ) begin
                                tx_clk_active   <=  0;
                                tx_hold_ss      <=  0;
                            end
                        end
                    end
                    
                NEXT_FIFO:
                    begin
                        if ( tx_hold_ss ) begin
                            tx_curr_state       <=  DATA; 
                        end else begin
                            tx_curr_state       <=  LATENCY;
                        end 
                        f_re                <=  0;
                        resp_re             <=  0;
                        remaining_responses =   remaining_responses + FIFO_WIDTH + ( response_words << 3 );
                    end
                
                LATENCY:
                    begin
                        tx_hold_ss          <=  1;
                        tx_counter          <=  tx_counter + 1;
                        
                        // prep the first written bit before the data section
                        MOSI                <=  r_data[tx_word_ptr];
                        if ( tx_counter > SS_LATENCY ) begin
                            tx_curr_state   <=  DATA;
                            tx_counter      <=  0;
                            tx_word_ptr     <=  tx_word_ptr + 1;
                        end
                    end
                    
                DATA:
                    begin
                        tx_clk_active           <=  1;
                        if ( clk_rising ) begin                            
                            MOSI                <=  r_data[tx_word_ptr];
                            tx_word_ptr         <=  tx_word_ptr + 1;
                            
                            if ( tx_word_ptr == (FIFO_WIDTH-1) ) begin
                                tx_word_ptr     <=  0;
                                tx_curr_state   <= IDLE;
                            end
                        end
                    end            
            endcase
            
            // rx stuff
            if ( rx_data_r ) begin
                rx_data_r      <=  0;
            end
            
            if ( clk_falling && ( remaining_responses > 0 ) ) begin
                rx_hold_ss          <=  1;
                rx_clk_active       <=  1;
                remaining_responses <=  remaining_responses - 1;
                
                if ( BIG_ENDIAN ) begin
                    rx_data[(FIFO_WIDTH-1)-rx_word_ptr]    <=  MISO;
                end else begin
                    rx_data[rx_word_ptr]    <=  MISO;
                end
                rx_word_ptr             <=  rx_word_ptr + 1;
                
                if ( rx_word_ptr == (FIFO_WIDTH-1) ) begin
                    rx_word_ptr         <=  0;
                    rx_data_r           <=  1;
                end
            end
            
            if ( clk_rising && ( remaining_responses == 0 ) ) begin
                rx_clk_active           <=  0;
            end
        end
    end

    assign  SS      = ~( tx_hold_ss | rx_hold_ss );
endmodule
