
//************************************************************
  //Test:
  //pass_a_p_af_rst_pwdata
  //
  //Desc:
  //Unit test for CIP_ID: a_p_af_rst_pwdata
  //rst_n= 0, next clock pwdata = 0
  //Expected result: PASS
  //************************************************************
  `SVTEST(pass_a_p_af_rst_pwdata)
 
    `g2u_display("a_p_af_rst_pwdata")
    idle();
    wait_for_n_clks(1);
    `g2u_display("Driving pwdata ")
 
    penable =1'b1;
    wait_for_n_clks(1);
   //rst_n=1'b0;
    penable =1'b0;
   pwdata = 1'b0;
    idle();
    wait_for_n_clks(10);
    `g2u_display("End pass_a_p_af_rst_pwdata")
 
  `SVTEST_END
 
  //************************************************************
  //Test:
  //fail_a_p_af_rst_pwdata
  //
  //Desc:
  //Unit test for CIP_ID: a_p_af_rst_pwdata
  //rst_n = 1, next clock write = 0
  //Expected result: FAIL
  //************************************************************
  `SVTEST(fail_a_p_af_rst_pwdata)
 
    `g2u_display("fail_a_p_af_rst_pwdata")
    idle();
    `g2u_display("Driving pwdata to 1")
    psel =1'b1;
    wait_for_n_clks(1);
    `g2u_display("Driving pwdata to 0")
    penable =1'b0;
    wait_for_n_clks(1);
    penable =1'b1;
    pwdata = 1'b0;
    idle();
    wait_for_n_clks(10);
    `FAIL_IF_LOG(1, "Expected FAIL a_p_af_rst_pwdata")
    `g2u_display("End fail_a_p_af_rst_pwdata")
 
  `SVTEST_END
