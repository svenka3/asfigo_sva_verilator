`include "svunit_defines.svh"
`include "apb_slave.sv"

module apb_slave_unit_test;
  import svunit_pkg::svunit_testcase;


  string name = "apb_slave_ut";
  svunit_testcase svunit_ut;

  logic [7:0] addr;
  logic [31:0] data, rdata;


  //===================================
  // This is the UUT that we're 
  // running the Unit Tests on
  //===================================
  reg         clk;
  reg         rst_n;
  reg [7:0]   paddr;
  reg         pwrite;
  bit         pready;
  reg         psel;
  reg         penable;
  reg [31:0]  pwdata;
  wire [31:0] prdata;

  assign pready = 1'b1;

  parameter CLK_PERIOD = 10;
  // clk generator
  initial begin
    clk = 0;
    forever begin
      #(CLK_PERIOD/2) clk = ~clk;
    end
  end

  task wait_for_n_clks (input int num_clk = 1);
    repeat (num_clk) begin
      @ (negedge clk);
    end
  endtask : wait_for_n_clks 

  /*
  default clocking dcb @(posedge clk);
  endclocking : dcb
  */

  apb_slave my_apb_slave(.*);


  //===================================
  // Build
  //===================================
  function void build();
    svunit_ut = new(name);
  endfunction


  //===================================
  // Setup for running the Unit Tests
  //===================================
  task setup();
    svunit_ut.setup();

    //-----------------------------------------
    // move the bus into the IDLE state
    // before each test
    //-----------------------------------------
    idle();

    //-----------------------------
    // then do a reset for the uut
    //-----------------------------
    rst_n = 0;
    repeat (8) @(posedge clk);
    rst_n = 1;
  endtask


  //===================================
  // Here we deconstruct anything we 
  // need after running the Unit Tests
  //===================================
  task teardown();
    svunit_ut.teardown();
    /* Place Teardown Code Here */
  endtask


  //===================================
  // All tests are defined between the
  // SVUNIT_TESTS_BEGIN/END macros
  //
  // Each individual test must be
  // defined between `SVTEST(_NAME_)
  // `SVTEST_END
  //
  // i.e.
  //   `SVTEST(mytest)
  //     <test code>
  //   `SVTEST_END
  //===================================
  `SVUNIT_TESTS_BEGIN


    idle ();
    wait_for_n_clks (10); 

    `include "test_a_p_af_psel_pen.sv"
    `include "test_a_p_af_active_one_clk.sv"
    `include "test_a_p_af_idle_paddr_stable.sv"
    `include "test_a_p_af_idle_pwrite_stable.sv"

    `include "test_a_p_af_paddr_stable_bw_setup_and_en.sv"
    `include "test_a_p_af_pwdata_stable_bw_setup_and_en.sv"
    `include "test_a_p_af_pwrite_stable_bw_setup_and_en.sv"
    `include "test_a_p_af_rst_paddr.sv"
    /*
    `include "test_a_p_af_rst_penable.sv"
    `include "test_a_p_af_rst_prdata.sv"
    `include "test_a_p_af_rst_pwdata.sv"
    `include "test_a_p_af_rst_pwrite.sv"
*/



  `SVUNIT_TESTS_END


  //-------------------------------------------------------------------------------
  //
  // write ()
  //
  // Simple write method used in the unit tests. Includes options for back-to-back
  // writes and protocol errors on the psel and pwrite.
  //
  //-------------------------------------------------------------------------------
  task write(logic [7:0] addr,
             logic [31:0] data,
             logic back2back = 0,
             logic setup_psel = 1,
             logic setup_pwrite = 1);

    // if !back2back, insert an idle cycle before the write
    if (!back2back) begin
      @(negedge clk);
      psel = 0;
      penable = 0;
    end

    // this is the SETUP state where the psel,
    // pwrite, paddr and pdata are set
    //
    // NOTE:
    //   setup_psel == 0 for protocol errors on the psel
    //   setup_pwrite == 0 for protocol errors on the pwrite
    @(negedge clk);
    psel = setup_psel;
    pwrite = setup_pwrite;
    paddr = addr;
    pwdata = data;
    penable = 0;

    // this is the ENABLE state where the penable is asserted
    @(negedge clk);
    pwrite = 1;
    penable = 1;
    psel = 1;
  endtask


  //-------------------------------------------------------------------------------
  //
  // read ()
  //
  // Simple read method used in the unit tests. Includes options for back-to-back
  // reads.
  //
  //-------------------------------------------------------------------------------
  task read(logic [7:0] addr, output logic [31:0] data, input logic back2back = 0);

    // if !back2back, insert an idle cycle before the read
    if (!back2back) begin
      @(negedge clk);
      psel = 0;
      penable = 0;
    end

    // this is the SETUP state where the psel, pwrite and paddr
    @(negedge clk);
    psel = 1;
    paddr = addr;
    penable = 0;
    pwrite = 0;

    // this is the ENABLE state where the penable is asserted
    @(negedge clk);
    penable = 1;

    // the prdata should be flopped after the subsequent posedge
    @(posedge clk);
    #1 data = prdata;
  endtask


  //-------------------------------------------------------------------------------
  //
  // idle ()
  //
  // Clear the all the inputs to the uut (i.e. move to the IDLE state)
  //
  //-------------------------------------------------------------------------------
  task idle();
    psel = 0;
    penable = 0;
    pwrite = 0;
    paddr = 0;
    pwdata = 0;
    @(negedge clk);
    @(negedge clk);
  endtask

  initial begin
    $timeformat (-9, 3, " ns", 10);
    $dumpfile ("cip.vcd");
    $dumpvars();
    $display ("%m DUMP");
  end
  vw_go2uvm_sim_utils u_vw_go2uvm_sim_utils ();
endmodule : apb_slave_unit_test

`include "af_apb_cip.sv"


