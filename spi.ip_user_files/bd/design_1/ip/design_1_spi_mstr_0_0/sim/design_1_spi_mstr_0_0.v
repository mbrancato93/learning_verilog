// (c) Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
// (c) Copyright 2022-2024 Advanced Micro Devices, Inc. All rights reserved.
// 
// This file contains confidential and proprietary information
// of AMD and is protected under U.S. and international copyright
// and other intellectual property laws.
// 
// DISCLAIMER
// This disclaimer is not a license and does not grant any
// rights to the materials distributed herewith. Except as
// otherwise provided in a valid license issued to you by
// AMD, and to the maximum extent permitted by applicable
// law: (1) THESE MATERIALS ARE MADE AVAILABLE "AS IS" AND
// WITH ALL FAULTS, AND AMD HEREBY DISCLAIMS ALL WARRANTIES
// AND CONDITIONS, EXPRESS, IMPLIED, OR STATUTORY, INCLUDING
// BUT NOT LIMITED TO WARRANTIES OF MERCHANTABILITY, NON-
// INFRINGEMENT, OR FITNESS FOR ANY PARTICULAR PURPOSE; and
// (2) AMD shall not be liable (whether in contract or tort,
// including negligence, or under any other theory of
// liability) for any loss or damage of any kind or nature
// related to, arising under or in connection with these
// materials, including for any direct, or any indirect,
// special, incidental, or consequential loss or damage
// (including loss of data, profits, goodwill, or any type of
// loss or damage suffered as a result of any action brought
// by a third party) even if such damage or loss was
// reasonably foreseeable or AMD had been advised of the
// possibility of the same.
// 
// CRITICAL APPLICATIONS
// AMD products are not designed or intended to be fail-
// safe, or for use in any application requiring fail-safe
// performance, such as life-support or safety devices or
// systems, Class III medical devices, nuclear facilities,
// applications related to the deployment of airbags, or any
// other applications that could lead to death, personal
// injury, or severe property or environmental damage
// (individually and collectively, "Critical
// Applications"). Customer assumes the sole risk and
// liability of any use of AMD products in Critical
// Applications, subject only to applicable laws and
// regulations governing limitations on product liability.
// 
// THIS COPYRIGHT NOTICE AND DISCLAIMER MUST BE RETAINED AS
// PART OF THIS FILE AT ALL TIMES.
// 
// DO NOT MODIFY THIS FILE.


// IP VLNV: xilinx.com:module_ref:spi_mstr_:1.0
// IP Revision: 1732416234

`timescale 1ns/1ps

(* IP_DEFINITION_SOURCE = "module_ref" *)
(* DowngradeIPIdentifiedWarnings = "yes" *)
module design_1_spi_mstr_0_0 (
  clk,
  rst_n,
  we,
  word,
  response_words,
  MISO,
  SS,
  SCLK,
  MOSI,
  rx_data,
  rx_data_r,
  rx_data_fifo,
  rx_data_fifo_empty,
  rx_data_fifo_full,
  rx_data_fifo_r
);

(* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME clk, FREQ_HZ 125000000, FREQ_TOLERANCE_HZ 0, PHASE 0.0, CLK_DOMAIN design_1_clk_0, INSERT_VIP 0" *)
(* X_INTERFACE_INFO = "xilinx.com:signal:clock:1.0 clk CLK" *)
input wire clk;
(* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME rst_n, POLARITY ACTIVE_LOW, INSERT_VIP 0" *)
(* X_INTERFACE_INFO = "xilinx.com:signal:reset:1.0 rst_n RST" *)
input wire rst_n;
input wire we;
input wire [7 : 0] word;
input wire [31 : 0] response_words;
input wire MISO;
output wire SS;
output wire SCLK;
output wire MOSI;
output wire [7 : 0] rx_data;
output wire rx_data_r;
output wire [7 : 0] rx_data_fifo;
output wire rx_data_fifo_empty;
output wire rx_data_fifo_full;
input wire rx_data_fifo_r;

  spi_mstr_ #(
    .FIFO_DEPTH(8),
    .FIFO_WIDTH(8),
    .CPOL(1),
    .CPHA(0),
    .CLK_DIV(10),
    .SS_LATENCY(5),
    .BIG_ENDIAN(0)
  ) inst (
    .clk(clk),
    .rst_n(rst_n),
    .we(we),
    .word(word),
    .response_words(response_words),
    .MISO(MISO),
    .SS(SS),
    .SCLK(SCLK),
    .MOSI(MOSI),
    .rx_data(rx_data),
    .rx_data_r(rx_data_r),
    .rx_data_fifo(rx_data_fifo),
    .rx_data_fifo_empty(rx_data_fifo_empty),
    .rx_data_fifo_full(rx_data_fifo_full),
    .rx_data_fifo_r(rx_data_fifo_r)
  );
endmodule
