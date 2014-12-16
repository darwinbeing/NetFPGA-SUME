// (c) Copyright 1995-2014 Xilinx, Inc. All rights reserved.
// 
// This file contains confidential and proprietary information
// of Xilinx, Inc. and is protected under U.S. and
// international copyright and other intellectual property
// laws.
// 
// DISCLAIMER
// This disclaimer is not a license and does not grant any
// rights to the materials distributed herewith. Except as
// otherwise provided in a valid license issued to you by
// Xilinx, and to the maximum extent permitted by applicable
// law: (1) THESE MATERIALS ARE MADE AVAILABLE "AS IS" AND
// WITH ALL FAULTS, AND XILINX HEREBY DISCLAIMS ALL WARRANTIES
// AND CONDITIONS, EXPRESS, IMPLIED, OR STATUTORY, INCLUDING
// BUT NOT LIMITED TO WARRANTIES OF MERCHANTABILITY, NON-
// INFRINGEMENT, OR FITNESS FOR ANY PARTICULAR PURPOSE; and
// (2) Xilinx shall not be liable (whether in contract or tort,
// including negligence, or under any other theory of
// liability) for any loss or damage of any kind or nature
// related to, arising under or in connection with these
// materials, including for any direct, or any indirect,
// special, incidental, or consequential loss or damage
// (including loss of data, profits, goodwill, or any type of
// loss or damage suffered as a result of any action brought
// by a third party) even if such damage or loss was
// reasonably foreseeable or Xilinx had been advised of the
// possibility of the same.
// 
// CRITICAL APPLICATIONS
// Xilinx products are not designed or intended to be fail-
// safe, or for use in any application requiring fail-safe
// performance, such as life-support or safety devices or
// systems, Class III medical devices, nuclear facilities,
// applications related to the deployment of airbags, or any
// other applications that could lead to death, personal
// injury, or severe property or environmental damage
// (individually and collectively, "Critical
// Applications"). Customer assumes the sole risk and
// liability of any use of Xilinx products in Critical
// Applications, subject only to applicable laws and
// regulations governing limitations on product liability.
// 
// THIS COPYRIGHT NOTICE AND DISCLAIMER MUST BE RETAINED AS
// PART OF THIS FILE AT ALL TIMES.
// 
// DO NOT MODIFY THIS FILE.


// IP VLNV: NetFPGA:NetFPGA:fallthrough_small_fifo:1.0
// IP Revision: 1

(* X_CORE_INFO = "fallthrough_small_fifo,Vivado 2014.2" *)
(* CHECK_LICENSE_TYPE = "fallthrough_small_fifo_opl,fallthrough_small_fifo,{}" *)
(* DowngradeIPIdentifiedWarnings = "yes" *)
module fallthrough_small_fifo_opl (
  din,
  wr_en,
  rd_en,
  dout,
  full,
  nearly_full,
  prog_full,
  empty,
  reset,
  clk
);

input wire [416 : 0] din;
input wire wr_en;
input wire rd_en;
output wire [416 : 0] dout;
output wire full;
output wire nearly_full;
output wire prog_full;
output wire empty;
input wire reset;
input wire clk;

  fallthrough_small_fifo #(
    .WIDTH(417),
    .MAX_DEPTH_BITS(2),
    .PROG_FULL_THRESHOLD(7)
  ) inst (
    .din(din),
    .wr_en(wr_en),
    .rd_en(rd_en),
    .dout(dout),
    .full(full),
    .nearly_full(nearly_full),
    .prog_full(prog_full),
    .empty(empty),
    .reset(reset),
    .clk(clk)
  );
endmodule