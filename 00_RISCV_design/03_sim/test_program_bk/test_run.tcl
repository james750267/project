#--------------------------------------------------------------------------------------------------
#   File name	: test_run.tcl
#   Project		: DSP Training
#   Author		: Nguyen Tuan Phuoc
#   Description	: Running the functional simution of fsk_modulation
#
#   Referents	: none.
#
#   Confidential
#   All rights reserved
#   ICDREC Copyright (C) 2013
#--------------------------------------------------------------------------------------------------
    
    #----------------------------------------------------------------------------------------------
    #   Clear the test_run folders � Only Option
    #----------------------------------------------------------------------------------------------
    if {[file isdirectory test_run]} {
        #file delete -force test_run
    } else {
    file mkdir test_run
    }
    cd "./test_run"

    #----------------------------------------------------------------------------------------------
    #   Copy .txt to set initial data for ROM
    #----------------------------------------------------------------------------------------------
#    file copy -force "../../../src/matlab/sin128_data.txt" "./"
#    file copy -force "../../../src/matlab/sin64_data.txt" "./"
    
    #----------------------------------------------------------------------------------------------
    #   Clear the rtl_lib and tb_lib folders
    #----------------------------------------------------------------------------------------------
    if {[file isdirectory rtl_dir]} {
        file delete -force rtl_dir
    }

    if {[file isdirectory tb_dir]} {
        file delete -force tb_dir
    }

    #----------------------------------------------------------------------------------------------
    #   Create the rtl_lib and tb_lib folders before mapping the referencing names
    #----------------------------------------------------------------------------------------------
    vlib rtl_dir
    vmap rtl_lib rtl_dir
    
    vlib tb_dir
    vmap tb_lib tb_dir
    
    #----------------------------------------------------------------------------------------------
    #   Compilation of verilog files
    #----------------------------------------------------------------------------------------------
    set rtl_path "../../../01_rtl/01_non_pipeline"
    set tb_path "../../../02_tb"
    
    vlog +initreg+{r}+{0} +delay_mode_zero -timescale 1ns/1ns -vlog01compat -work rtl_lib "$rtl_path/*.v"
    vlog +initreg+{r}+{0} +delay_mode_zero -timescale 1ns/1ns -vlog01compat -work rtl_lib "../riscv_imem.v"
    vlog +initreg+{r}+{0} +delay_mode_zero -timescale 1ns/1ns -vlog01compat -work tb_lib  "$tb_path/testbench.v"
    
    #----------------------------------------------------------------------------------------------
    #   Running the simulation
    #----------------------------------------------------------------------------------------------
    vsim -novopt -t ns -wlf "testbench_wav.wlf" -L rtl_lib -L tb_lib tb_lib.testbench
    log -r /*
    run 2ms

    #----------------------------------------------------------------------------------------------
    #   Quit the simulation
    #----------------------------------------------------------------------------------------------
    quit -sim

    #----------------------------------------------------------------------------------------------
    #   Return to the original folder
    #----------------------------------------------------------------------------------------------
    cd ../
    
    #----------------------------------------------------------------------------------------------
    #   Quit the ModelSim
    #----------------------------------------------------------------------------------------------
    quit -f
    
    
    
