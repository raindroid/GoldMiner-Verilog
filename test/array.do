vlib work
vlog array.v
vsim array_test
log {/*}

add wave -color yellow clock resetn 

add wave -color red -unsigned x
#add wave -color blue -unsigned temp

force {clock} 0 0, 1 10ns -r 20ns
force {resetn} 0 0, 1 20ns
run 10000ns