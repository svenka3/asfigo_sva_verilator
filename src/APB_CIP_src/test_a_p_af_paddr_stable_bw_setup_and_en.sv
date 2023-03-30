  //************************************************************
  // Test:
  //   pass_a_p_af_paddr_stable_bw_setup_and_en
  //
  // Desc:
  //   Unit test for CIP_ID: a_p_af_paddr_stable_bw_setup_and_en
  //    paddr is stable in between setup and enable
  //   Expected result: PASS
  //************************************************************
  `SVTEST(pass_a_p_af_paddr_stable_bw_setup_and_en)

    `g2u_display ("pass_a_p_af_paddr_stable_bw_setup_and_en")
    idle ();
    `g2u_display ("Driving signals for setup state")
    psel = 1;
    wait_for_n_clks (1); 
    `g2u_display ("Driving pen to 1")
    penable = 1'b1;
    wait_for_n_clks (1); 
    penable = 1'b0;
    idle ();
    wait_for_n_clks (10); 
    `g2u_display ("End pass_a_p_af_paddr_stable_bw_setup_and_en")

  `SVTEST_END

  //************************************************************
  // Test:
  //   fail_a_p_af_paddr_stable_bw_setup_and_en
  //
  // Desc:
  //   Unit test for CIP_ID: a_p_af_af_rst_penable
  //   paddr is changing in between setup and enable
  //   Expected result: FAIL
  //************************************************************
  `SVTEST(fail_a_p_af_paddr_stable_bw_setup_and_en)

    `g2u_display ("fail_a_p_af_paddr_stable_bw_setup_and_en")
    idle ();
    `g2u_display ("Driving signals for setup state")
    psel = 1;
    pwrite = 0;
    paddr = 8'b00000100;
    wait_for_n_clks (1); 
    `g2u_display ("Changing paddr to another value")
    paddr = 8'b00000010;
    penable = 1'b1;
    wait_for_n_clks (1); 
    penable = 1'b0;
    idle ();
    wait_for_n_clks (10); 
    `FAIL_IF_LOG(1, "Expected FAIL a_p_af_paddr_stable_bw_setup_and_en")
    `g2u_display ("End fail_a_p_af_paddr_stable_bw_setup_and_en")

  `SVTEST_END

