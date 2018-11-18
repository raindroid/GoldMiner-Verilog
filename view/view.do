vlib work
vlog view.v score_and_time_display.v num0.v num1.v num2.v num3.v num4.v num5.v num6.v num7.v num8.v num9.v ../model/item_generator.v
vsim  -L altera_mf_ver view
log {/*}

add wave clk

add wave -unsigned X_out Y_out Color_out writeEn

add wave -unsigned gold_count stone_count diamond_count

add wave -color grey -unsigned current_state next_state 



force {clk} 0 0, 1 10ns -r 20ns
force {resetn} 0 0, 1 20ns
force {go} 0

run 10000ns