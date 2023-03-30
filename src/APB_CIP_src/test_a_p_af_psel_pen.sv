  //************************************************************
  // Test:
  //   pass_a_p_af_psel_pen
  //
  // Desc:
  //   Unit test for CIP_ID: a_p_af_psel_pen
  //   psel = 1, next clock penable = 1
  //   Expected result: PASS
  //************************************************************
  `SVTEST(pass_a_p_af_psel_pen)

    `g2u_display ("pass_a_p_af_psel_pen")
    idle ();
    `g2u_display ("Driving psel to 1")
    psel = 1'b1;
    wait_for_n_clks (1); 
    `g2u_display ("Driving pen to 1")
    penable = 1'b1;
    wait_for_n_clks (1); 
    penable = 1'b0;
    idle ();
    wait_for_n_clks (10); 
    `g2u_display ("End pass_a_p_af_psel_pen")

  `SVTEST_END

  //************************************************************
  // Test:
  //   fail_a_p_af_psel_pen
  //
  // Desc:
  //   Unit test for CIP_ID: a_p_af_psel_pen
  //   psel = 1, next clock penable = 0
  //   Expected result: FAIL
  //************************************************************
  `SVTEST(fail_a_p_af_psel_pen)

    `g2u_display ("fail_a_p_af_psel_pen")
    idle ();
    `g2u_display ("Driving psel to 1")
    psel = 1'b1;
    wait_for_n_clks (1); 
    `g2u_display ("Driving pen to 0")
    penable = 1'b0;
    wait_for_n_clks (1); 
    penable = 1'b0;
    idle ();
    wait_for_n_clks (10); 
    `FAIL_IF_LOG(1, "Expected FAIL a_p_af_psel_pen")
    `g2u_display ("End fail_a_p_af_psel_pen")

  `SVTEST_END

