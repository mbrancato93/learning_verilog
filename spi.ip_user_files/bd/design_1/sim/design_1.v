//Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
//Copyright 2022-2024 Advanced Micro Devices, Inc. All Rights Reserved.
//--------------------------------------------------------------------------------
//Tool Version: Vivado v.2023.2.2 (win64) Build 4126759 Thu Feb  8 23:53:51 MST 2024
//Date        : Sat Nov 23 21:44:03 2024
//Host        : LAPTOP-EETGHN0U running 64-bit major release  (build 9200)
//Command     : generate_target design_1.bd
//Design      : design_1
//Purpose     : IP block netlist
//--------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

(* CORE_GENERATION_INFO = "design_1,IP_Integrator,{x_ipVendor=xilinx.com,x_ipLibrary=BlockDiagram,x_ipName=design_1,x_ipVersion=1.00.a,x_ipLanguage=VERILOG,numBlks=5,numReposBlks=5,numNonXlnxBlks=0,numHierBlks=0,maxHierDepth=0,numSysgenBlks=0,numHlsBlks=0,numHdlrefBlks=2,numPkgbdBlks=0,bdsource=USER,synth_mode=Hierarchical}" *) (* HW_HANDOFF = "design_1.hwdef" *) 
module design_1
   (ck_io0,
    ck_io1,
    ck_io2,
    clk);
  output ck_io0;
  output ck_io1;
  output ck_io2;
  (* X_INTERFACE_INFO = "xilinx.com:signal:clock:1.0 CLK.CLK CLK" *) (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME CLK.CLK, CLK_DOMAIN design_1_clk_0, FREQ_HZ 125000000, FREQ_TOLERANCE_HZ 0, INSERT_VIP 0, PHASE 0.0" *) input clk;

  wire clk_0_1;
  wire clk_div_0_rising;
  wire spi_mstr_0_MOSI;
  wire spi_mstr_0_SCLK;
  wire spi_mstr_0_SS;
  wire [7:0]xlconstant_0_dout;
  wire [0:0]xlconstant_1_dout;
  wire [31:0]xlconstant_2_dout;

  assign ck_io0 = spi_mstr_0_SS;
  assign ck_io1 = spi_mstr_0_SCLK;
  assign ck_io2 = spi_mstr_0_MOSI;
  assign clk_0_1 = clk;
  design_1_clk_div_0_0 clk_div_0
       (.clk(clk_0_1),
        .divisor(xlconstant_2_dout),
        .rising(clk_div_0_rising),
        .rst(xlconstant_1_dout));
  design_1_spi_mstr_0_0 spi_mstr_0
       (.MISO(1'b0),
        .MOSI(spi_mstr_0_MOSI),
        .SCLK(spi_mstr_0_SCLK),
        .SS(spi_mstr_0_SS),
        .clk(clk_0_1),
        .response_words({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .rst_n(xlconstant_1_dout),
        .rx_data_fifo_r(1'b0),
        .we(clk_div_0_rising),
        .word(xlconstant_0_dout));
  design_1_xlconstant_0_0 xlconstant_0
       (.dout(xlconstant_0_dout));
  design_1_xlconstant_1_0 xlconstant_1
       (.dout(xlconstant_1_dout));
  design_1_xlconstant_2_0 xlconstant_2
       (.dout(xlconstant_2_dout));
endmodule
