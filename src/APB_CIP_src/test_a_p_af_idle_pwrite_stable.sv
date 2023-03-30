//********************
  //Test:
  //pass_a_p_af_idle_pwrite_stable
  //
  //Desc:
  //Unit test for CIP_ID: a_p_af_idle_pwrite_stable
  //psel = 0,penable =0,pwrite =0 next clock pwrite = 0
  //Expected result: PASS
  //********************
  `SVTEST(pass_a_p_af_idle_pwrite_stable)

    `g2u_display("pass_a_p_af_idle_pwrite_stable")
    idle();
    pwrite= 1'b0;
    `g2u_display("Driving a_p_af_idle_pwrite_stable to 1")
    psel =1'b0;
    wait_for_n_clks(1); 
    `g2u_display("Driving a_p_af_idle_pwrite_stable to 1")
    penable =1'b0;
    wait_for_n_clks(1); 
    pwrite= 1'b0;
    idle();
    wait_for_n_clks(10); 
    `g2u_display("End pass_a_p_af_idle_pwrite_stable")

  `SVTEST_END

  //********************
  //Test:
  //fail_a_p_af_idle_pwrite_stable
  //
  //Desc:
  //Unit test for CIP_ID: a_p_af_idle_pwrite_stable
  //psel = 0,penable =0,pwrite =0 next clock pwrite = 1
  //Expected result: FAIL
  //********************
  `SVTEST(fail_a_p_af_idle_pwrite_stable)

    `g2u_display("fail_a_p_af_idle_pwrite_stable")
    psel = 1'b0;
    pwrite= 1'b0;
    penable = 1'b0;
    `g2u_display("Driving a_p_af_idle_pwrite_stable to 1")
    wait_for_n_clks(1); 
    `g2u_display("Driving a_p_af_idle_pwrite_stable to 1")
    pwrite =1'b1;
     wait_for_n_clks (10); 
    `FAIL_IF_LOG(1, "Expected FAIL a_p_af_idle_pwrite_stable")
    `g2u_display ("End fail_a_p_af_idle_pwrite_stable")


  `SVTEST_END
