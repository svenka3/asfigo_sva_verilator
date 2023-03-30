  //************************************************************
  // Test:
  //   pass_a_p_af_idle_paddr_stable
  //
  // Desc:
  //   Unit test for CIP_ID: a_p_af_idle_paddr_stable
  //   psel = 0, penable = 0, paddr = 0,  next clock paddr = 0
  //   Expected result: PASS
  //************************************************************
  `SVTEST(pass_a_p_af_idle_paddr_stable)

    `g2u_display ("pass_a_p_af_idle_paddr_stable")
    paddr = 1'b0;
    `g2u_display ("Driving psel to 0")
    psel = 1'b0;
    `g2u_display ("Driving pen to 0")
    penable = 1'b0;
    wait_for_n_clks (1); 
    `g2u_display ("Driving addr to 0")
    paddr = 1'b0;
    wait_for_n_clks (10); 
    `g2u_display ("End pass_a_p_af_idle_paddr_stable")

  `SVTEST_END

  //************************************************************
  // Test:
  //   fail_a_p_af_idle_paddr_stable
  //
  // Desc:
  //   Unit test for CIP_ID: a_p_af_idle_paddr_stable
  //   psel = 0, penable = 0, paddr = 0,  next clock paddr = 1
  //   Expected result: FAIL
  //************************************************************
  `SVTEST(fail_a_p_af_idle_paddr_stable)

    `g2u_display ("fail_a_p_af_idle_paddr_stable")
    paddr = 1'b0;
    `g2u_display ("Driving psel to 0")
    psel = 1'b0;
    `g2u_display ("Driving pen to 0")
    penable = 1'b0;
    wait_for_n_clks (1); 
    `g2u_display ("Driving addr to 1")
    paddr = 1'b1;
    wait_for_n_clks (10); 
    `FAIL_IF_LOG(1, "Expected FAIL a_p_af_idle_paddr_stable")
    `g2u_display ("End fail_a_p_af_idle_paddr_stable")

  `SVTEST_END
