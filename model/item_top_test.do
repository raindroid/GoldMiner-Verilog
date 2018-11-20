vlib work
vlog item_generator.v
vsim test_top
log {/*}

add wave -color yellow clk resetn enable_random

add wave -color red -unsigned data 
add wave -color blue -unsigned x_init_gold y_init_gold
add wave -color blue -unsigned x_init_stone  y_init_stone
add wave -color blue -unsigned x_init_diamond  y_init_diamond

force {clk} 0 0, 1 10ns -r 20ns
force {resetn} 0 0, 1 20ns
force {enable_random} 0 0, 1 20ns, 0 60ns
run 10000ns