vlt: clean apb 

apb:
	runSVUnit -s vlt -c -I../go2uvm/go2uvm/src/ -f flist -t ../src/APB_CIP_src/af_apb_tests.sv -c -I../src/APB_CIP_src/ -c "--assert --trace " 2>&1 | tee apb_cip_run_vlt.log

clean:
	rm -fr vbu* *.log obj* .sv* .*.sv *.vcd *.cfg
