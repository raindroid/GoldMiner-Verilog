vlib work
vlog score_and_time_display.v num0.v num1.v num2.v num3.v num4.v num5.v num6.v num7.v num8.v num9.v bin_to_decb.v
vsim  -L altera_mf_ver score_and_time_display
log {/*}

add wave clk
add wave -unsigned score_to_display time_remained
add wave -unsigned outX outY color writeEn display_score_and_time_done
add wave -unsigned num_mem_address
add wave -unsigned time_one time_ten score_one score_ten

add wave -color grey -unsigned current_state next_state 
add wave -unsigned num_pixel decimal_bit_count

add wave -unsigned time_one time_ten time_hun score_one score_ten score_hun

force {clk} 0 0, 1 10ns -r 20ns
force {resetn} 0 0, 1 20ns
force {enable_score_and_time_display} 0 0, 1 30ns, 0 50ns
force {score_to_display} 110010
force {time_remained} 'd1035 1;
force {score_to_display} 'd155 1;

run 10000ns