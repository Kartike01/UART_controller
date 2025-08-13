module baud_counter#(parameter CLOCK_RATE = 25000000,
                    parameter BAUD_RATE = 115200,
                     parameter RX_OVERSAMPLE = 16 )(
  input clk,
  input resetn,
  output reg op_tx_clk,
  output reg op_rx_clk
);
  parameter TX_CNT = CLOCK_RATE/(2*BAUD_RATE) ; // the division here makes sure that a complete clock cycle is generated 
  parameter RX_CNT = CLOCK_RATE/(2*BAUD_RATE*RX_OVERSAMPLE);
  parameter TX_WIDTH = $clog2(TX_CNT);
  parameter RX_WIDTH = $clog2(RX_CNT);
  
  reg [TX_WIDTH-1:0] TX_count;
  reg [RX_WIDTH-1:0] RX_count;
  
  // RX CLOCKING   
  always @(posedge clk or negedge resetn) begin 
    if(!resetn) begin 
      op_rx_clk <= 0;
      RX_count <= 0;
    end 
    else if(RX_count == RX_CNT-1  ) begin 
      op_rx_clk <= ~op_rx_clk;
      RX_count <= 0;
    end 
    else begin 
      RX_count <= RX_count+1;
    end 
  end 
  
  
  // TX CLOCKING 
  always @(posedge clk or negedge resetn) begin 
    if(!resetn) begin 
      op_tx_clk <= 0;
      TX_count <= 0;
    end 
    else if(TX_count == TX_CNT-1 ) begin 
      op_tx_clk <= ~op_tx_clk;
      TX_count <= 0;
    end 
    else begin 
      TX_count <= TX_count+1;
    end 
  end 
endmodule 
      
  
      
      
      
      
  
  
  