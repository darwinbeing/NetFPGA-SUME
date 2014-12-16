/********************************************************************************
 *  NetFPGA-10G http://www.netfpga.org
 *
 *  File:
 *        opl_cpu_regs.v
 *
 *  Module:
 *        opl_cpu_regs
 *
 *  Author:
 *        Noa Zilberman
 *
 *  Description:
 *        This file is automatically generated with the registers towards the CPU/Software
 *
 *  Copyright notice:
 *        Copyright (C) 2013 University of Cambridge
 *
 *  Licence:
 *        This file is part of the NetFPGA 10G development base package.
 *
 *        This file is free code: you can redistribute it and/or modify it under
 *        the terms of the GNU Lesser General Public License version 2.1 as
 *        published by the Free Software Foundation.
 *
 *        This package is distributed in the hope that it will be useful, but
 *        WITHOUT ANY WARRANTY; without even the implied warranty of
 *        MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
 *        Lesser General Public License for more details.
 *
 *        You should have received a copy of the GNU Lesser General Public
 *        License along with the NetFPGA source package.  If not, see
 *        http://www.gnu.org/licenses/.
 *
 */

`include "opl_cpu_regs_defines.v"
 module opl_cpu_regs 
 #(
    parameter C_S_AXI_DATA_WIDTH    = 32,
    parameter C_S_AXI_ADDR_WIDTH    = 32,
    parameter C_USE_WSTRB           = 0,
    parameter C_DPHASE_TIMEOUT      = 0,
    parameter C_NUM_ADDRESS_RANGES = 1,
    parameter  C_TOTAL_NUM_CE       = 1,
    parameter  C_S_AXI_MIN_SIZE    = 32'h0000_FFFF,
    parameter [31:0]  C_BASE_ADDRESS      = 32'h0000_0000,
    parameter [31:0]  C_HIGH_ADDRESS      = 32'h0000_FFFF,
    parameter [0:8*C_NUM_ADDRESS_RANGES-1] C_ARD_NUM_CE_ARRAY  ={C_NUM_ADDRESS_RANGES{8'd1}},
    parameter     C_FAMILY            = "virtex7"
  )
 (
   // General ports
    input      clk,
    input      resetn,
   // Global Registers
   input      cpu_resetn_soft,
   output reg resetn_soft,
   output reg resetn_sync,

   // Register ports
    input      [`REG_ID_BITS]    id_reg,
    input      [`REG_VERSION_BITS]    version_reg,
    input      [`REG_FLIP_BITS]    ip2cpu_flip_reg,
    output reg [`REG_FLIP_BITS]    cpu2ip_flip_reg,
    input      [`REG_COUNTERIN_BITS]    counterin_reg,
    output reg                          counterin_reg_clear,
    input      [`REG_COUNTEROUT_BITS]    counterout_reg,
    output reg                          counterout_reg_clear,
    input      [`REG_DEBUG_BITS]    ip2cpu_debug_reg,
    output reg [`REG_DEBUG_BITS]    cpu2ip_debug_reg,

  // AXI Lite ports
    input                                     S_AXI_ACLK,
    input                                     S_AXI_ARESETN,
    input      [C_S_AXI_ADDR_WIDTH-1 : 0]     S_AXI_AWADDR,
    input                                     S_AXI_AWVALID,
    input      [C_S_AXI_DATA_WIDTH-1 : 0]     S_AXI_WDATA,
    input      [C_S_AXI_DATA_WIDTH/8-1 : 0]   S_AXI_WSTRB,
    input                                     S_AXI_WVALID,
    input                                     S_AXI_BREADY,
    input      [C_S_AXI_ADDR_WIDTH-1 : 0]     S_AXI_ARADDR,
    input                                     S_AXI_ARVALID,
    input                                     S_AXI_RREADY,
    output                                    S_AXI_ARREADY,
    output     [C_S_AXI_DATA_WIDTH-1 : 0]     S_AXI_RDATA,
    output     [1 : 0]                        S_AXI_RRESP,
    output                                    S_AXI_RVALID,
    output                                    S_AXI_WREADY,
    output     [1 :0]                         S_AXI_BRESP,
    output                                    S_AXI_BVALID,
    output                                    S_AXI_AWREADY

);

    reg                                             resetn_sync_d;
    wire                                            Bus2IP_Clk;
    wire                                            Bus2IP_Resetn;
    wire     [C_S_AXI_ADDR_WIDTH-1 : 0]             Bus2IP_Addr;
    wire     [0:0]                                  Bus2IP_CS;
    wire                                            Bus2IP_RNW;
    wire     [C_S_AXI_DATA_WIDTH-1 : 0]             Bus2IP_Data;
    wire     [C_S_AXI_DATA_WIDTH/8-1 : 0]           Bus2IP_BE;
    wire     [C_S_AXI_DATA_WIDTH-1 : 0]             IP2Bus_Data;
    wire                                            IP2Bus_RdAck;
    wire                                            IP2Bus_WrAck;
  
    wire [C_S_AXI_ADDR_WIDTH-1 : 0]                 bus2ip_addr_sync;
    wire [0:0]                                      bus2ip_cs_sync;
    wire                                            bus2ip_rnw_sync;
    wire [C_S_AXI_DATA_WIDTH-1 : 0]                 bus2ip_data_sync;
    wire [C_S_AXI_DATA_WIDTH/8-1 : 0]               bus2ip_be_sync;
    reg  [C_S_AXI_DATA_WIDTH-1 : 0]                 ip2bus_data_sync;
    reg                                             ip2bus_rdack_sync;
    reg                                             ip2bus_wrack_sync;
    wire                                            ip2bus_error_sync;
    wire                                            bus2ip_sync_valid;
    
    wire [C_S_AXI_ADDR_WIDTH-1 : 0]                 masked_addr;
    assign masked_addr = bus2ip_addr_sync ^ C_BASE_ADDRESS;

  //ipif_xbar block
  axi_lite_ipif
#(
       .C_S_AXI_DATA_WIDTH     (C_S_AXI_DATA_WIDTH ),
       .C_S_AXI_ADDR_WIDTH     (C_S_AXI_ADDR_WIDTH ),
       .C_S_AXI_MIN_SIZE       (C_S_AXI_MIN_SIZE   ),
       .C_DPHASE_TIMEOUT       (C_DPHASE_TIMEOUT   ),
       .C_NUM_ADDRESS_RANGES   (C_NUM_ADDRESS_RANGES),
       .C_TOTAL_NUM_CE         (C_TOTAL_NUM_CE     ),
       .C_ARD_ADDR_RANGE_ARRAY ({C_BASE_ADDRESS,C_HIGH_ADDRESS}),
       .C_ARD_NUM_CE_ARRAY     (C_ARD_NUM_CE_ARRAY),
       .C_FAMILY               (C_FAMILY           )
   ) axi_lite_ipif_inst
  (
    .S_AXI_ACLK          ( S_AXI_ACLK     ),
    .S_AXI_ARESETN       ( S_AXI_ARESETN  ),
    .S_AXI_AWADDR        ( S_AXI_AWADDR   ),
    .S_AXI_AWVALID       ( S_AXI_AWVALID  ),
    .S_AXI_WDATA         ( S_AXI_WDATA    ),
    .S_AXI_WSTRB         ( S_AXI_WSTRB    ),
    .S_AXI_WVALID        ( S_AXI_WVALID   ),
    .S_AXI_BREADY        ( S_AXI_BREADY   ),
    .S_AXI_ARADDR        ( S_AXI_ARADDR   ),
    .S_AXI_ARVALID       ( S_AXI_ARVALID  ),
    .S_AXI_RREADY        ( S_AXI_RREADY   ),
    .S_AXI_ARREADY       ( S_AXI_ARREADY  ),
    .S_AXI_RDATA         ( S_AXI_RDATA    ),
    .S_AXI_RRESP         ( S_AXI_RRESP    ),
    .S_AXI_RVALID        ( S_AXI_RVALID   ),
    .S_AXI_WREADY        ( S_AXI_WREADY   ),
    .S_AXI_BRESP         ( S_AXI_BRESP    ),
    .S_AXI_BVALID        ( S_AXI_BVALID   ),
    .S_AXI_AWREADY       ( S_AXI_AWREADY  ),
	
	// Controls to the IP/IPIF modules
    .Bus2IP_Clk          ( Bus2IP_Clk     ),
    .Bus2IP_Resetn       ( Bus2IP_Resetn  ),
    .Bus2IP_Addr         ( Bus2IP_Addr    ),
    .Bus2IP_RNW          ( Bus2IP_RNW     ),
    .Bus2IP_BE           ( Bus2IP_BE      ),
    .Bus2IP_CS           ( Bus2IP_CS      ),
    .Bus2IP_Data         ( Bus2IP_Data    ),
    .IP2Bus_Data         ( IP2Bus_Data    ),
    .IP2Bus_WrAck        ( IP2Bus_WrAck   ), 
    .IP2Bus_RdAck        ( IP2Bus_RdAck   ), 
    .IP2Bus_Error        ( IP2Bus_Error   )
  );

  //synchronization module
cpu_sync 
#(
    .C_S_AXI_DATA_WIDTH    (C_S_AXI_DATA_WIDTH),
    .C_S_AXI_ADDR_WIDTH    (C_S_AXI_ADDR_WIDTH)
) cpu_sync_inst
(
    //ip clock domain
    .clk                    (clk),
    .resetn                 (resetn_sync),
    .bus2ip_addr_sync       (bus2ip_addr_sync),
    .bus2ip_cs_sync         (bus2ip_cs_sync),
    .bus2ip_rnw_sync        (bus2ip_rnw_sync),
    .bus2ip_data_sync       (bus2ip_data_sync),
    .bus2ip_be_sync         (bus2ip_be_sync),
    .bus2ip_sync_valid      (bus2ip_sync_valid),
    .ip2bus_data_sync       (ip2bus_data_sync),
    .ip2bus_rdack_sync      (ip2bus_rdack_sync),
    .ip2bus_wrack_sync      (ip2bus_wrack_sync),
    .ip2bus_error_sync      (ip2bus_error_sync),
    
    //axi clock domain
    .Bus2IP_Clk             (Bus2IP_Clk),
    .Bus2IP_Resetn          (Bus2IP_Resetn),

    .Bus2IP_Addr            (Bus2IP_Addr),
    .Bus2IP_CS              (Bus2IP_CS),
    .Bus2IP_RNW             (Bus2IP_RNW),
    .Bus2IP_Data            (Bus2IP_Data),
    .Bus2IP_BE              (Bus2IP_BE),
    .IP2Bus_Data            (IP2Bus_Data),
    .IP2Bus_RdAck           (IP2Bus_RdAck),
    .IP2Bus_WrAck           (IP2Bus_WrAck),
    .IP2Bus_Error           (IP2Bus_Error)

);

  //Sample reset (not mandatory, but good practice)
   always @(posedge clk)
   if (!resetn) begin
      resetn_sync_d  <= #1 1'b0;
      resetn_sync    <= #1 1'b0;
   end
   else begin
      resetn_sync_d  <= #1 resetn;
      resetn_sync    <= #1 resetn_sync_d;
   end

   //Handle ACK signals (note that the timing is correct)
   reg new_event;
   always @(posedge clk)
   if (!resetn_sync) begin
      ip2bus_wrack_sync <= #1 1'b0;
      ip2bus_rdack_sync <= #1 1'b0;
      new_event <= #1 1'b1;
   end
   else begin
     ip2bus_wrack_sync <= #1 bus2ip_cs_sync && !bus2ip_rnw_sync && new_event  ;
     ip2bus_rdack_sync <= #1 bus2ip_cs_sync && bus2ip_rnw_sync && new_event  ;
	 // new_event <= #1 !bus2ip_cs_sync ? 1'b1: 1'b0;
     new_event <= #1 ~bus2ip_sync_valid ? new_event : !bus2ip_cs_sync ? 1'b1: 1'b0;
   end

   assign ip2bus_error_sync = 1'b0; //unless we need it... but no error event is currently handled

   //global registers, sampling
   always @(posedge clk) resetn_soft <= #1 cpu_resetn_soft;

//Return value to CPU on read

         //Id Wire
           wire [31:0] id_wire;
           assign id_wire [`REG_ID_BITS] = id_reg;
           generate
               if (`REG_ID_WIDTH<32)
                  assign id_wire [31:`REG_ID_WIDTH] = 'b0;
          endgenerate
         //Version Wire
           wire [31:0] version_wire;
           assign version_wire [`REG_VERSION_BITS] = version_reg;
           generate
               if (`REG_VERSION_WIDTH<32)
                  assign version_wire [31:`REG_VERSION_WIDTH] = 'b0;
          endgenerate
         //Flip Wire
            wire [31:0] ip2cpu_flip_wire;
               assign ip2cpu_flip_wire [`REG_FLIP_BITS] =  ip2cpu_flip_reg;
               generate
                              if (`REG_FLIP_WIDTH<32)
                                 assign ip2cpu_flip_wire [31:`REG_FLIP_WIDTH] = 'b0;
                         endgenerate
         //Counterin Wire
           wire [31:0] counterin_wire;
           assign counterin_wire [`REG_COUNTERIN_BITS] = counterin_reg;
           generate
               if (`REG_COUNTERIN_WIDTH<32)
                  assign counterin_wire [31:`REG_COUNTERIN_WIDTH] = 'b0;
          endgenerate
         //Counterout Wire
           wire [31:0] counterout_wire;
           assign counterout_wire [`REG_COUNTEROUT_BITS] = counterout_reg;
           generate
               if (`REG_COUNTEROUT_WIDTH<32)
                  assign counterout_wire [31:`REG_COUNTEROUT_WIDTH] = 'b0;
          endgenerate
         //Debug Wire
            wire [31:0] ip2cpu_debug_wire;
               assign ip2cpu_debug_wire [`REG_DEBUG_BITS] =  ip2cpu_debug_reg;
               generate
                              if (`REG_DEBUG_WIDTH<32)
                                 assign ip2cpu_debug_wire [31:`REG_DEBUG_WIDTH] = 'b0;
                         endgenerate

//Return value to CPU on read
   always @(posedge clk) 
   if (!resetn_sync) begin
        ip2bus_data_sync[31:0] <= #1 32'hDEADBEEF;
   end
   else begin
        if ( bus2ip_cs_sync && bus2ip_rnw_sync ) begin
         case (masked_addr)
         //Id Register
         `REG_ID_ADDR : begin
             ip2bus_data_sync [`REG_ID_BITS] <= #1 id_wire;
        end
         //Version Register
         `REG_VERSION_ADDR : begin
             ip2bus_data_sync [`REG_VERSION_BITS] <= #1 version_wire;
        end
         //Flip Register
         `REG_FLIP_ADDR : begin
             ip2bus_data_sync [`REG_FLIP_BITS] <= #1 ip2cpu_flip_wire;
        end
         //Counterin Register
         `REG_COUNTERIN_ADDR : begin
             ip2bus_data_sync [`REG_COUNTERIN_BITS] <= #1 counterin_wire;
        end
         //Counterout Register
         `REG_COUNTEROUT_ADDR : begin
             ip2bus_data_sync [`REG_COUNTEROUT_BITS] <= #1 counterout_wire;
        end
         //Debug Register
         `REG_DEBUG_ADDR : begin
             ip2bus_data_sync [`REG_DEBUG_BITS] <= #1 ip2cpu_debug_wire;
        end
         //Default return value
         default: begin 
             ip2bus_data_sync [31:0] <= #1 32'hDEADBEEF;
         end
      endcase
    end
  end//end of assigning data to IP2Bus_Data bus
     //Read only registers, not cleared
   //Nothing to do here....
   
   //Read only registers, cleared on read (e.g. counters)
   always @(posedge clk)
   if (!resetn_sync) begin 
      counterin_reg_clear <= #1 1'b0;
      counterout_reg_clear <= #1 1'b0;
   end
   else begin
      counterin_reg_clear <= #1(bus2ip_cs_sync && bus2ip_rnw_sync && (masked_addr==`REG_COUNTERIN_ADDR)) ? 1'b1 : 1'b0;
      counterout_reg_clear <= #1(bus2ip_cs_sync && bus2ip_rnw_sync && (masked_addr==`REG_COUNTEROUT_ADDR)) ? 1'b1 : 1'b0;
   end

     //R/W register, not cleared
       always @(posedge clk)
       if (!resetn_sync) begin
           cpu2ip_flip_reg <= #1 `REG_FLIP_DEFAULT;
           cpu2ip_debug_reg <= #1 `REG_DEBUG_DEFAULT;
       end
       else begin
           if (bus2ip_cs_sync && !(bus2ip_rnw_sync)) //write event
           case (masked_addr)
         //Flip Register
           `REG_FLIP_ADDR : begin
            cpu2ip_flip_reg <= #1 bus2ip_data_sync[`REG_FLIP_BITS]; //dynamic register;
            end
         //Debug Register
           `REG_DEBUG_ADDR : begin
            cpu2ip_debug_reg <= #1 bus2ip_data_sync[`REG_DEBUG_BITS]; //dynamic register;
            end
        default: begin
          end
        endcase
      end

endmodule