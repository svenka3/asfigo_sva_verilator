 //************************************************************
  // Test:
  //   pass_a_p_af_active_one_clk
  //
  // Desc:
  //   Unit test for CIP_ID: a_p_af_active_one_clk
  //   psel = 1, penable = 1, pready = 1, next clock psel = 1, penable = 0
  //   pready = 1
  //   Expected result: PASS
  //************************************************************

  `SVTEST(pass_a_p_af_active_one_clk)

    `g2u_display ("pass_a_p_af_active_one_clk")
    `g2u_display ("Driving psel to 1")
    psel = 1'b1;

    `g2u_display ("Driving pen to 1")
    penable = 1'b1;
    `g2u_display ("Driving pready to 1")
    pready = 1'b1; 

    `g2u_display ("Driving psel to 1")
    psel = 1'b1;
    `g2u_display ("Driving pen to 0")
    penable = 1'b0;
    wait_for_n_clks (1);    
    `g2u_display ("End pass_a_p_af_active_one_clk")

  `SVTEST_END
 

  //************************************************************
  // Test:
  //   fail_a_p_af_active_one_clk
  //
  // Desc:
  //   Unit test for CIP_ID: a_p_af_active_one_clk
  //   psel = 1, penable = 1, pready = 1, next clock
  //   pready = 1
  //   Expected result: fail
  //************************************************************
 
  `SVTEST(fail_a_p_af_active_one_clk)

    `g2u_display ("fail_a_p_af_active_one_clk")
    `g2u_display ("Driving psel to 1")
    psel = 1'b1;
    `g2u_display ("Driving pen to 1")
    penable = 1'b1;
    `g2u_display ("Driving pready to 1")
    pready = 1'b1; 

    wait_for_n_clks (2);
    `g2u_display ("Driving psel to 1")
    psel = 1'b1;
    `g2u_display ("Driving pen to 1")
    penable = 1'b1;

    wait_for_n_clks (2); 
    `FAIL_IF_LOG(1, "Expected FAIL a_p_af_active_one_clk")    
    `g2u_display ("End fail_a_p_af_active_one_clk")

  `SVTEST_END
 