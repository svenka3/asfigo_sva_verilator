  //************************************************************
  // Test:
  //   pass_a_p_af_rst_pwrite
  //
  // Desc:
  //   Unit test for CIP_ID: a_p_af_rst_pwrite
  //   rst_n = 0, next clock pwrite = 0
  //   Expected result: PASS
  //************************************************************
  `SVTEST(pass_a_p_af_rst_pwrite)

    `g2u_display ("pass_a_p_af_rst_pwrite")
    idle ();
    `g2u_display ("Driving rst_n to 0")
    rst_n = 1'b0; 
    `g2u_display ("Driving pwrite to 0")
    pwrite = 1'b0;
    wait_for_n_clks (1); 
    pwrite = 1'b0;
    idle ();
    wait_for_n_clks (10); 
    `g2u_display ("End pass_a_p_af_rst_pwrite")

  `SVTEST_END

  //************************************************************
  // Test:
  //   fail_a_p_af_rst_pwrite
  //
  // Desc:
  //   Unit test for CIP_ID: a_p_af_rst_pwrite
  //   rst_n = 0, next clock penable = 1
  //   Expected result: FAIL
  //************************************************************
  `SVTEST(fail_a_p_af_rst_pwrite)

    `g2u_display ("fail_a_p_af_rst_pwrite")
    idle ();
    `g2u_display ("Driving rst_n to 0")
    rst_n = 1'b0; 
    `g2u_display ("Driving pwrite to 1")
    pwrite = 1'b1;
    wait_for_n_clks (1); 
    pwrite = 1'b1;
    idle ();
    wait_for_n_clks (10); 
    `FAIL_IF_LOG(1, "Expected FAIL a_p_af_rst_pwrite")
    `g2u_display ("End fail_a_p_af_rst_pwrite")

  `SVTEST_END

