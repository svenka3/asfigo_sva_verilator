  //************************************************************
  // Test:
  //   pass_a_p_af_pwrite_stable_bw_setup_and_en
  //
  // Desc:
  //   Unit test for CIP_ID: a_p_af_rst_pwrite_stable_bw_setup_and_en
  //   penable = 1,psel = 1,pready =1,pwrite = 1 next clock pwrite = 1
  //   Expected result: PASS
  //************************************************************
  `SVTEST(pass_a_p_af_pwrite_stable_bw_setup_and_en)

    `g2u_display ("pass_a_p_af_pwrite_stable_bw_setup_and_en")
      idle();
    `g2u_display ("Driving psel to 1")
    psel = 1'b1;
    `g2u_display("Driving penable to 1")
    penable = 1'b1;
    `g2u_display("Driving pready to 1")
    pready = 1'b1;
    `g2u_display("Driving pwrite to 1")
    wait_for_n_clks (1); 
    pwrite = 1'b0;
    penable = 1'b0;
    psel = 1'b0;
    idle();
    wait_for_n_clks (5); 
    `g2u_display ("Driving pwrite to 1")
    pwrite = 1'b0;
    wait_for_n_clks (1); 
    pwrite = 1'b0;
    `g2u_display ("End pass_a_p_af_pwrite_stable_bw_setup_and_en")
  `SVTEST_END

  //************************************************************
  // Test:
  //   fail_a_p_af_pwrite_stable_bw_setup_and_en
  //
  // Desc:
  //   Unit test for CIP_ID: a_p_af_pwrite_stable_bw_setup_and_en
  //   penable = 1,pready =1,psel =1,pwrite =1  next clock pwrite = 0
  //   Expected result: FAIL
  //************************************************************
  `SVTEST(fail_a_p_af_pwrite_stable_bw_setup_and_en)

    `g2u_display ("fail_a_p_af_pwrite_stable_bw_setup_and_en")
    idle();
    `g2u_display ("Driving psel to 1")
    psel = 1'b1;
    `g2u_display("Driving penable to 1")
    penable = 1'b1;
    `g2u_display("Driving pready to 1")
    pready = 1'b1;
    `g2u_display("Driving pwrite to 1")
    pwrite = 1'b1;
    wait_for_n_clks (1); 
    `g2u_display ("Driving pwrite to 0")
    pwrite = 1'b0;
    idle();
    wait_for_n_clks (1); 
    pwrite = 1'b0;  
    `FAIL_IF_LOG(1, "Expected FAIL a_p_af_pwrite_stable_bw_setup_and_en")
    `g2u_display ("End fail_a_p_af_pwrite_stable_bw_setup_and_en")

  `SVTEST_END

