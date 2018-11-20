vlib work
vlog ../../item_generator.v project_test.v
vsim project_test
log {/*}

add wave -color yellow clock resetn enable

add wave -color red -unsigned out
add wave -color red -bin out

force {KEY[0]} 0 0, 1 10ns -r 20ns
force {KEY[1]} 0 0, 1 20ns
force {KEY[2]} 0 0, 1 20ns
run 400ns