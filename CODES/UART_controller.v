// Code your design here
`include "defines.v"
//`include "baud_counter.v"

//`ifdef UART_TX_ONLY
  //  `include "uart_tx_controller.v"
//`else
  //  `ifdef UART_RX_ONLY
    //    `include "uart_rx_controller.v"
    //`else
        //`include "uart_tx_controller.v"
        //`include "uart_rx_controller.v"
 //   `endif
//`endif

module UART_controller#(
    parameter CLOCK_RATE    = `CLOCK_RATE,
    parameter BAUD_RATE     = `BAUD_RATE,
    parameter RX_OVERSAMPLE = `RX_OVERSAMPLE
)(
  input               clk,
  input               reset_n,
  `ifdef UART_TX_ONLY
  input               i_Tx_Ready,
  input [7:0]         i_Tx_Byte,
  output              o_Tx_Active,
  output              o_Tx_Data,
  output              o_Tx_Done
  `else
  `ifdef UART_RX_ONLY
  input               i_Rx_Data,
  output              o_Rx_Done,
  output [7:0]        o_Rx_Byte
  `else  
  input [7:0]         i_Tx_Byte,
  input               i_Tx_Ready,
  output              o_Rx_Done,  // Asserted for 1 clk cycle after receiving one byte of data 
  output [7:0]        o_Rx_Byte
  `endif
  `endif);
  
  
  wire                w_Rx_ClkTick,w_Tx_ClkTick;
  wire                w_Tx_Data_to_Rx;
  
  `ifdef UART_TX_ONLY
  assign o_Tx_Data = w_Tx_Data_to_Rx;
  `else
  `ifdef UART_RX_ONLY
  assign w_Tx_Data_to_Rx = i_Rx_Data;
  `endif
  `endif
  
  // BAUD RATE GENERATOR 
  baud_counter#(.CLOCK_RATE(`CLOCK_RATE),
                .BAUD_RATE(`BAUD_RATE),
                .RX_OVERSAMPLE(`RX_OVERSAMPLE)) 
  baud_inst(.clk(clk),.resetn(reset_n),.op_rx_clk(w_Rx_ClkTick),.op_tx_clk(w_Tx_ClkTick));
  
  `ifdef UART_TX_ONLY
  // TX-only mode
  uart_tx_controller xUART_TX(
    .clk            (w_Tx_ClkTick),
    
    .reset_n        (reset_n), 
    .ip_tx_data     (i_Tx_Byte), 
    .tx_ready       (i_Tx_Ready), 
    .tx_done        (o_Tx_Done), 
    .op_tx_active   (o_Tx_Active), 
    .op_tx_data     (w_Tx_Data_to_Rx)
  );
  `else
  `ifdef UART_RX_ONLY
  // RX-only mode
  uart_rx_controller #(`RX_OVERSAMPLE) xUART_RX(
    .clk          (w_Rx_ClkTick), 
    .resetn       (reset_n), 
    .ip_rx_data   (w_Tx_Data_to_Rx), 
    .rx_done      (o_Rx_Done), 
    .op_rx_data   (o_Rx_Byte)
  );
  `else
  
    // Full-duplex mode (both TX and RX)
  uart_tx_controller xUART_TX(
    .clk            (w_Tx_ClkTick), 
    .reset_n        (reset_n), 
    .ip_tx_data     (i_Tx_Byte), 
    .tx_ready       (i_Tx_Ready), 
    .tx_done        (), 
    .op_tx_active   (), 
    .op_tx_data     (w_Tx_Data_to_Rx)
  );
  uart_rx_controller #(`RX_OVERSAMPLE) xUART_RX(
    .clk          (w_Rx_ClkTick), 
    .resetn       (reset_n), 
    .ip_rx_data   (w_Tx_Data_to_Rx), 
    .rx_done      (o_Rx_Done), 
    .op_rx_data   (o_Rx_Byte)
  );
  `endif
  `endif
  
  
  
endmodule
  

  
