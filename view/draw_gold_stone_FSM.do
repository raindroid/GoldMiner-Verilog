vlib work
vlog draw_gold_stone_FSM.v
vsim draw_gold_FSM
log {/*}

add wave -color yellow clk resetn 
add wave -color grey -hex current_state next_state 

add wave -color green enable_draw_gold gold_pixel_cout
add wave -color red enable_c_gold load_x_gold load_y_gold enable_x_adder_gold
add wave -color red enable_y_adder_gold enable_gold_count writeEn_gold
add wave -color red draw_gold_done

force {clk} 0 0, 1 10ns -r 20ns
force {resetn} 0 0, 1 20ns
force {enable_draw_gold} 0 0, 1 50ns, 0 70ns
force {gold_pixel_cout} 0 0, 1 100ns, 100000000 200ns

run 400ns