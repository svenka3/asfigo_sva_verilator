  //************************************************************
  // Test:
  //   pass_a_p_af_pwdata_stable_bw_setup_and_en
  //
  // Desc:
  //   Unit test for CIP_ID: a_p_af_rst_pwdata_stable_bw_setup_and_en
  //   penable = 1,psel = 1,pready =1,pwdata = 1 next clock pwdata = 1
  //   Expected result: PASS
  //************************************************************
  `SVTEST(pass_a_p_af_pwdata_stable_bw_setup_and_en)

    `g2u_display ("pass_a_p_af_pwdata_stable_bw_setup_and_en")
    `g2u_display ("Driving psel to 1")
    psel = 1'b1;
    `g2u_display("Driving penable to 1")
    penable = 1'b1;
    `g2u_display("Driving pready to 1")
    pready = 1'b1;
    `g2u_display("Driving pwdata to 1")
    pwdata = 1'b1;
    wait_for_n_clks (2); 
    psel = 1'b0;
    penable = 1'b0;
    `g2u_display ("Driving pwdata to 1")
    pwdata = 1'b1;
    wait_for_n_clks (1); 
    pwdata = 1'b1;
    `g2u_display ("End pass_a_p_af_pwrite_stable_bw_setup_and_en")
  `SVTEST_END

  //************************************************************
  // Test:
  //   fail_a_p_af_pwdata_stable_bw_setup_and_en
  //
  // Desc:
  //   Unit test for CIP_ID: a_p_af_pwrite_stable_bw_setup_and_en
  //   penable = 1,pready =1,psel =1,pwdata =1  next clock pwdata = 0
  //   Expected result: FAIL
  //************************************************************
  `SVTEST(fail_a_p_af_pwdata_stable_bw_setup_and_en)

    `g2u_display ("fail_a_p_af_pwdata_stable_bw_setup_and_en")
    `g2u_display ("Driving psel to 1")
    psel = 1'b1;
    `g2u_display("Driving penable to 1")
    penable = 1'b1;
    `g2u_display("Driving pready to 1")
    pready = 1'b1;
    `g2u_display("Driving pwdata to 1")
    pwdata = 1'b1;
    wait_for_n_clks (2); 
    psel = 1'b0;
    penable = 1'b0;
    `g2u_display ("Driving pwdata to 1")
    pwdata = 1'b0;
    wait_for_n_clks (1); 
    pwdata = 1'b0;
    `FAIL_IF_LOG(1, "Expected FAIL a_p_af_pwdata_stable_bw_setup_and_en")
    `g2u_display ("End fail_a_p_af_pedata_stable_bw_setup_and_en")

  `SVTEST_END

