`define AF_CIP_ERROR(ID, MSG) \
  `uvm_error (ID, MSG) 

interface apb2_m_cip #(
    parameter DATA_WIDTH = 32,
    parameter ADDR_WIDTH = 16
) (
    input logic                  pclk,
    input                        presetn,
    input                        pwrite,
    input                        penable,
    input                        pready,
    input       [DATA_WIDTH-1:0] pwdata,
    input       [ADDR_WIDTH-1:0] paddr,
    input       [DATA_WIDTH-1:0] prdata,
    input                        psel
);

  logic  af_apb_idle_st;
  logic  af_apb_acc_st;
  string af_id = "AF";


  assign af_apb_idle_st = !psel && !penable;
  assign af_apb_setup_st = psel && !penable;
  assign af_apb_acc_st  = psel && penable && pready;

  // Assert properties

  //========================================
  function void cip_fail_msg(string ID, MSG);
    `uvm_error (ID, MSG);
  endfunction : cip_fail_msg



  default clocking clock @(posedge pclk);
  endclocking
`ifndef VERILATOR
  default disable iff (!presetn);
`endif  // VERILATOR

  always @(posedge pclk) begin
    if (psel) begin
      `g2u_printf (("psel: %b pen: %b", psel, penable))
    end
  end

  //==========================================

  //MASTER ASSERTIONS

  //==========================================

  // property : penable should appear exactly one clock after psel
  a_p_af_psel_pen : assert property 
    ( @(posedge pclk) disable iff (!presetn) 
      (psel && !penable) |=> penable)
  else 
    `AF_CIP_ERROR("p_af_psel_pen", 
      "penable is not HIGH after psel");

  //=================================================

  //property : paddr should be stable during IDLE
  a_p_af_idle_paddr_stable : assert property 
    (disable iff (!presetn) 
      af_apb_idle_st |-> $stable(paddr))
  else
    `AF_CIP_ERROR("a_p_af_idle_paddr_stable", 
      " paddr is not stable when APB is IDLE");

  //=================================================

  //property : pwrite should be stable during IDLE
  a_p_af_idle_pwrite_stable : assert property 
    (disable iff (!presetn) 
      af_apb_idle_st |-> $stable(pwrite))
  else
    `AF_CIP_ERROR("a_p_af_idle_pwrite_stable", 
      " pwrite is not stable when APB is IDLE");

  //==================================================

 
  //property : fsm can stay in active state for exactly one clock 

  a_p_af_active_one_clk : assert property 
    (disable iff (!presetn)
      af_apb_acc_st |=> (af_apb_setup_st || af_apb_idle_st))
    else
      `AF_CIP_ERROR("p_af_active_one_clk", 
        "ENABLE state stayed HIGH for more than one clock");

  // Using never-disable construct
  // http://sv-verif.blogspot.com/2013/03/sva-default-disable-boon-or-bane.html    
  property p_af_rst_penable;
    disable iff (1'b0)
    (!presetn) |-> (penable == 1'b0);
  endproperty : p_af_rst_penable

  a_p_af_rst_penable : assert property 
    (p_af_rst_penable)
  else
    `AF_CIP_ERROR("a_p_af_rst_penable", "penable is not low at reset");

  //========================================================
  //property : To ensure all peripherals/Inputs are low when reset is low


  a_p_af_rst_pwrite : assert property ( 
    disable iff (1'b0)
    (!presetn) |-> (pwrite == 'b0))
  else
    `AF_CIP_ERROR("a_p_af_rst_pwrite", "pwrite is not low at reset");

  a_p_af_rst_paddr : assert property ( 
    disable iff (1'b0)
    (!presetn) |-> (paddr == '0))
  else
    `AF_CIP_ERROR("p_af_output_at_reset", "paddr is not low at reset");

  a_p_af_rst_pwdata : assert property (
    disable iff (1'b0)
    (!presetn) |-> (pwdata == '0))
  else
    `AF_CIP_ERROR("a_p_af_rst_pwdata", "pwdata is not low at reset");

  //To ensure rdata is low when reset is low
  a_p_af_rst_prdata : assert property (
    disable iff (1'b0)
    (!presetn) |-> (prdata == '0))
  else
    `AF_CIP_ERROR("a_p_af_rst_prdata", "prdata is not low at reset");




  //========================================================
  //property : To ensure paddr,pwrite & pwdata to be held 
  // stable b/w setup & enable state

  a_p_af_paddr_stable_bw_setup_and_en : assert property (
    disable iff (!presetn) 
    af_apb_acc_st |=> $stable(paddr))
  else
    `AF_CIP_ERROR("a_p_af_paddr_stable_bw_setup_and_en", 
      "paddr is not stable during SETUP-EN state");

  a_p_af_pwrite_stable_bw_setup_and_en : assert property (
    disable iff (!presetn) 
    af_apb_acc_st |=> $stable(pwrite))
  else
    `AF_CIP_ERROR("a_p_af_pwrite_stable_bw_setup_and_en", 
      "pwrite is not stable during SETUP-EN state");

  a_p_af_pwdata_stable_bw_setup_and_en : assert property (
    disable iff (!presetn) 
    af_apb_acc_st |=> $stable(pwdata))
  else
    `AF_CIP_ERROR("a_p_af_pwdata_stable_bw_setup_and_en", 
      "pwdata is not stable during SETUP-EN state");

  //property to ensure prdata is not an unknown value 
  // during read transfer

  p_af_prdata_not_unknown_during_read : assert property (
    disable iff (!presetn) 
    !pwrite |=> !$isunknown(prdata))
  else
    `AF_CIP_ERROR("p_af_prdata_not_unknown_during_read", 
      $sformatf ("prdata: 0x%0h has X/Z after !pwrite ", prdata));


  initial begin : init
    `g2u_display("Using CIP");
  end : init
endinterface : apb2_m_cip

bind apb_slave_unit_test apb2_m_cip u_apb2_m_cip (
    .pclk(clk),
    .presetn(rst_n),
    .*
);

