module uart_rx_controller#(parameter RX_OVERSAMPLE=0)(
  input clk,
  input resetn,
  input ip_rx_data,
  output rx_done,
  output [7:0] op_rx_data
);
  localparam rx_idle = 3'b000,
  		     rx_start = 3'b001,
  			 st_rx_data = 3'b010,
  			 rx_stop = 3'b011;
  
  
  // in-module parameters used 
  reg [2:0] rx_state , nx_rx_state;
  reg [3:0] bit_index, nx_bit_index;
  reg [4:0] clk_count, nx_clk_count;
  reg r_rx_done, nx_done ;
  reg [7:0] rx_data, nx_rx_data;
  
  
  // SEQUENTIAL LOGIC 
  always @(posedge clk or negedge resetn) begin 
    if(!resetn) begin 
      rx_state <=  rx_idle  ;
 	  bit_index <= 4'b0;
 	  clk_count <= 5'b0;
      r_rx_done <= 0; 
      rx_data   <= 0 ;
    end
    else begin 
      rx_state  <= nx_rx_state;
      bit_index <= nx_bit_index;
      clk_count <= nx_clk_count;
      r_rx_done <= nx_done; 
      rx_data   <= nx_rx_data ;
    end 
  end 
  
  always @(*) begin 
    nx_rx_state = rx_state ;
    nx_bit_index = bit_index ;
    nx_clk_count = clk_count ;
    nx_done = 0;   
    nx_rx_data = rx_data ;
    
    case(rx_state)
      rx_idle  : begin        
        nx_bit_index = 0;
        nx_clk_count = 0;
        if(ip_rx_data == 0) begin 
          nx_rx_state <= rx_start;
        end           
      end 
      rx_start : begin 
        if(clk_count == RX_OVERSAMPLE/2) begin 
          if(ip_rx_data == 0) begin 
            nx_rx_state <= st_rx_data; 
            nx_clk_count <= 0;
          end
          else nx_rx_state <= rx_idle;
        end
        else begin
          nx_clk_count <= clk_count +1;
        end 
      end
      st_rx_data  : begin 
        if (clk_count < RX_OVERSAMPLE) nx_clk_count <= clk_count +1;
        else begin
          nx_rx_data[bit_index] <= ip_rx_data;
          nx_clk_count <= 0;
          if(bit_index < 7) begin 
            nx_bit_index <= bit_index + 1 ;
          end else begin
            nx_bit_index <= 0;
            nx_rx_state <= rx_stop;
          end 
        end 
      end 
      rx_stop  : begin 
        if (clk_count < RX_OVERSAMPLE) nx_clk_count <= clk_count +1;
        else begin 
          nx_clk_count <= 0;
          nx_rx_state <= rx_idle;
          nx_done <= 1'b1;
        end 
      end 
    endcase 
  end 
  
  assign op_rx_data = r_rx_done?rx_data:0 ;
  assign rx_done = r_rx_done ;
  
endmodule 
    
    
      
  
  
  
  
  
  
  
  
  
  