module uart_tx_controller(
  input clk,
  input reset_n,
  input tx_ready,
  input [7:0] ip_tx_data,
  output op_tx_data,
  output tx_done,
  output op_tx_active
);
  
  localparam tx_idle=3'b000,
  			 tx_start=3'b001,
  			 tx_data=3'b010,
  			 tx_stop=3'b011;
  
  
  
  reg[2:0] bit_index,nx_bit_index;
  
  reg r_tx_data,nx_tx_data; // these are the output bits that are expelled from the UART serially i.e 1 for the idle case and 0 for the start 
  reg r_tx_done,nx_tx_done;
  reg r_tx_active,nx_tx_active; // these are used to  flag the start of bit wise data exracion process when become high, data t/f starts
    
  reg[2:0] r_state,nx_r_state;
  
//   always @(*) begin 
    
//     nx_bit_index = bit_index;
//     nx_tx_data = r_tx_data;
//     nx_r_state = r_state;
//     r_tx_done = 1'b0;
//     r_tx_active = 1'b0;
    
       
//     case(r_state)
//       tx_idle :begin 
//         nx_tx_data = 1'b1;
//         nx_tx_done = 1'b0;
//         nx_bit_index = 1'b0;
//         if(tx_ready) begin 
//           nx_r_state = tx_start;
//           nx_tx_active = 1'b1;
//         end 
//       end
//       tx_start :begin 
//         nx_tx_data = 1'b0;
//         nx_r_state = tx_data;        
//         end
//       tx_data :begin 
//         nx_tx_data = ip_tx_data[bit_index];
//         if(bit_index < 7) begin 
//           nx_bit_index = bit_index+1;
//           nx_r_state = tx_data;
//         end 
//         else begin 
//           nx_bit_index = 1'b0;
//           nx_r_state =   tx_stop;
//         end
//       end 
//       tx_stop :begin 
//         nx_tx_data = 1'b1;
//         nx_tx_done = 1'b1;
//         nx_r_state = tx_idle;
//       end
      
//       default : 
//         nx_r_state = tx_idle;
//     endcase
//   end 
  always @(*) begin
    nx_bit_index = bit_index;
    nx_tx_data   = r_tx_data;
    nx_r_state   = r_state;
    nx_tx_done   = 1'b0;
    nx_tx_active = 1'b0;
    
    case (r_state)
      tx_idle: begin
        nx_tx_data   = 1'b1;
        nx_tx_done   = 1'b0;
        nx_bit_index = 3'b000;
        if (tx_ready) begin
          nx_r_state   = tx_start;
          nx_tx_active = 1'b1;
        end
      end
      tx_start: begin
        nx_tx_data = 1'b0;  // Start bit
        nx_r_state = tx_data;
      end
      
      tx_data: begin
        nx_tx_data = ip_tx_data[bit_index];
        if (bit_index < 3'd7) begin
          nx_bit_index = bit_index + 1;
          nx_r_state   = tx_data;
        end else begin
          nx_bit_index = 3'b000;
          nx_r_state   = tx_stop;
        end
      end
      
      tx_stop: begin
        nx_tx_data = 1'b1;  // Stop bit
        nx_tx_done = 1'b1;
        nx_r_state = tx_idle;
      end
      default: begin
        nx_r_state = tx_idle;
      end
    endcase
  end

  
  
  
  always @(posedge clk or negedge reset_n) begin 
    if(!reset_n) begin 
      r_state <= tx_idle;
      r_tx_data <= 1'b1;
      r_tx_done <= 1'b0 ;
      r_tx_active <= 1'b0 ;
      bit_index <= 1'b0 ;
    end 
    else begin 
      bit_index <= nx_bit_index ;
      r_tx_data <= nx_tx_data   ;
      r_state <= nx_r_state;     
      r_tx_done <= nx_tx_done;
      r_tx_active <= nx_tx_active;      
    end
  end 
  
  assign op_tx_data = r_tx_data ;
  assign tx_done = r_tx_done;  
  assign op_tx_active = r_tx_active;
endmodule 


           
  
  