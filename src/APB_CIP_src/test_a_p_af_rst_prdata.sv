  //************************************************************
  // Test:
  //   pass_a_p_af_rst_prdata
  //
  // Desc:
  //   Unit test for CIP_ID: a_p_af_rst_prdata
  //   presetn = 1, next clock psel = 0, penble 0
  //   Expected result: PASS
  //************************************************************
  `SVTEST(pass_a_p_af_rst_prdata)

    `g2u_display ("pass_a_p_af_rst_prdata")
    `g2u_display ("Driving presetn to 1")
    rst_n = 1'b0;
    wait_for_n_clks (1); 
    `g2u_display ("Driving psel to 0 and penable to 0")
    psel = 1'b0;
    penable = 1'b0;
    idle ();
    wait_for_n_clks (10); 
    `g2u_display ("End pass_a_p_af_rst_prdata")

  `SVTEST_END

  //************************************************************
  // Test:
  //   fail_a_p_af_rst_prdata
  //
  // Desc:
  //   Unit test for CIP_ID: a_p_af_rst_prdata
  //   presetn = 1, next clock psel = 1, penble 0
  //   Expected result: FAIL
  //************************************************************
  `SVTEST(fail_a_p_af_rst_prdata)

    `g2u_display ("fail_a_p_af_rst_prdata")
    idle ();
    `g2u_display ("Driving presetn to 0")
    rst_n = 1'b0;
    wait_for_n_clks (1); 
   
    `g2u_display ("Driving psel to 1 and penable to 0")
     // prdata = 1'b1;
    wait_for_n_clks (10); 
    `FAIL_IF_LOG(1, "Expected FAIL a_p_af_rst_prdata")
    `g2u_display ("End fail_a_p_af_rst_prdata")

  `SVTEST_END
