//
// APB Bus cycle generator
//
// Freeware September 2015, Fen Logic Ltd.
// This code is free and is delivered 'as is'.
// It comes without any warranty, to the extent permitted by applicable law.
// There are no restrictions to any use or re-use of this code
// in any form or shape. It would be nice if you keep my company name
// in the source or modified source code but even that is not
// required as I can't check it anyway.
// But the code comes with no warranties or guarantees whatsoever.
//
// User accessable task
// ====================
//
// write(<16 bit address> , <32 bit write data> )
//    Start a  write cycle 
//    e.g. apb_bus0.write(16'h000C,32'hDEADBEEF);
//    Beware that the task returns BEFORE the write has finished 
//
// read(<16 bit address> , <32 bit expected data> )
//    Start a read cycle
//    expected bits set to 'x' are ignored.
//    e.g. apb_bus0.read(16'h000C,32'h#!#xBEEF);
//    Beware that the task returns BEFORE the read has finished 
//
// delay( <32 bit counter> )
//   waits the amount of APB clock cycles. 
//   The delays starts after the bus has become idle
//   delay must be >= 1
//   e.g. apb_bus0.delay(12);
//
//
// User accessable variables
// =========================
//
// errors : the number of data compare errors seen
//
//

module apb_bus 
#(parameter CLKPER  = 100,  // pclk period
            TIMEOUT = 1000  // Timout if no ready after so many clocks
 )
(
   // APB
   output reg         pclk,            
   output reg  [15:0] paddr,   // ls 2 bits always 0 
   output reg         pwrite,
   output reg         psel,
   output reg         penable,
   output reg  [31:0] pwdata,
   input       [31:0] prdata,
   input              pready,
   input              pslverr

);

localparam DO_NONE  = 2'h0,
           DO_WRITE = 2'h1,
           DO_READ  = 2'h2;

localparam IDLE    = 4'h0,
           READ1   = 4'h1,
           READ2   = 4'h2,
           WRITE1  = 4'h3,
           WRITE2  = 4'h4;
      
reg  [2:0] state;
reg [31:0] check_data;      

reg  [1:0] request;
reg [15:0] req_adrs;
reg [31:0] req_data;


integer   wait_count,errors;
 
initial
begin
   state  = IDLE;
   wait_count = 0;
   errors     = 0;
   request    = DO_NONE;
   
   paddr   = 16'h0;
   pwrite  = 1'b0;
   psel    = 1'b0;
   penable = 1'b0;
   pwdata  = 32'h0;
   pclk    = 1'b0;;
   forever
      #(CLKPER/2) pclk = ~pclk;
end

   //
   // The cycle FSM 
   //
   always @(posedge pclk)
   begin
      
      case (state)
      IDLE :
         handle_request;
         
      READ1 : 
         begin
            penable <= 1'b1;
            state    <= READ2;
            wait_count <= 0;
         end
         
      WRITE1 : 
         begin
            penable <= 1'b1;
            state    <= WRITE2;
            wait_count <= 0;
         end
         
      READ2   :
         if (pready)
         begin
            handle_request;
            if (!pslverr)
               compare(check_data,prdata);
         end
         else
            wait_count <= wait_count + 1;
         
      WRITE2  : 
         if (pready)
            handle_request;
         else
            wait_count <= wait_count + 1;
              
      default : state <= IDLE;
      endcase
      
      if (penable & psel & pready & pslverr)
      begin
         $display("%m@%0t: !!! APB Slave error active!!",$time);
      end
      
   end
   
   always @(wait_count)
      if (wait_count==TIMEOUT)
      begin
         $display("%m@%0t: APB time-out",$time);
         $stop;
      end

//
// Kick off a write
//
task write;
input [15:0] address;
input [31:0] data;
begin
   // checking on neg edge so data can be picked up at next pos edge. 
   // (Only use opposite edges if you are desparate) 
   @(negedge pclk);
   while (request!=DO_NONE)
      @(negedge pclk);
   if (request==DO_NONE)
   begin
      request  <= DO_WRITE;
      req_adrs <= address;
      req_data <= data;
   end
end
endtask


//
// Kick off a read
//
task read;
input [15:0] address;
input [31:0] data;
begin
   // checking on neg edge so data can be picked up at next pos edge. 
   // (Only use opposite edges if you are desparate) 
   @(negedge pclk);
   while (request!=DO_NONE)
      @(negedge pclk);
   if (request==DO_NONE)
   begin
      request  <= DO_READ;
      req_adrs <= address;
      req_data <= data;
   end
end
endtask



//
// Wait for bus to be in last cycle 
// (And no more commands in queue)
// then wait if we need more cycles delay
//
task delay;
input integer cycles;
begin
   
   // Wait for bus to finish
   @(posedge pclk);
   // If not finished wait more cycles 
   // Could add a time-out here...
   while ( request!=DO_NONE || state==READ1 || state==WRITE1 ||
           ((state==READ2 || state==WRITE2) & !pready)
         )
      @(posedge pclk);
       
  while (cycles>1)
      @(posedge pclk)
         cycles <= cycles - 1;
  
end
endtask

//
// Check if there is another cycle to run
//
task handle_request;
begin
   penable <= 1'b0;
   case (request)
   DO_NONE :
      begin
         psel    <= 1'b0;
         state   <= IDLE;         
      end
      
   DO_WRITE : 
      begin
         paddr  <= req_adrs;
         pwdata <= req_data;
         psel   <= 1'b1;
         pwrite <= 1'b1;
         state  <= WRITE1;
         request <= DO_NONE;
      end
      
   DO_READ : 
      begin
         paddr  <= req_adrs;
         check_data <= req_data;
         psel   <= 1'b1;
         pwrite <= 1'b0;
         state  <= READ1;
         request <= DO_NONE;
      end
            
   endcase
end
endtask // handle_request

//
// Compare data read against data expected
// Do not compare expected 'x' bits
// 
task compare;
input [31:0] check_data;
input [31:0] read_data;
integer b,err;
begin
   err=0;
   for (b=0; b<32 && err==0; b=b+1)
     if (check_data[b]!==1'bx)
        if (read_data[b]!==check_data[b])
           err = 1;
  if (err)
  begin
     $display("%m@%0t: !!! APB read verify error. Have 0x%08x, expected: 0x%08X",
                  $time,read_data,check_data);
     errors = errors + 1;
  end
   
end
endtask // compare 


endmodule