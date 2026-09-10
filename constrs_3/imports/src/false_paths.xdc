#set_false_path -through [get_pins */user_led_g0_driver_inst/*/d_q1_reg/D]
#set_false_path -through [get_pins */user_led_g1_driver_inst/*/d_q1_reg/D]
#set_false_path -through [get_pins */user_led_r_driver_inst/*/d_q1_reg/D]

#set_false_path -through [get_pins */reset75_sync_inst/inst/*_reg/CLR]
#set_false_path -through [get_pins */reset75_sync_inst/inst/q0_reg/D]

#set_false_path -through [get_pins */reset300_sync_inst/inst/*_reg/CLR]
#set_false_path -through [get_pins */reset300_sync_inst/inst/q0_reg/D]

#set_false_path -from [get_clocks clk_out*_clock_and_buffer_clk_wiz_0_*] -to [get_clocks clk_out*_clock_and_buffer_clk_wiz_0_*]
set_false_path -from [get_pins clock_and_buff*/clk_wiz*/inst*/mmcm*/CLK*] -to [get_pins my_vio/inst*/PROBE*/probe*/D]


