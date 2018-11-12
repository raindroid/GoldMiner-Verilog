vlib work
vlog key_detector.v
vsim test_key_detector
log {/*}

add wave -color yellow clock resetn 
add wave -color green KEY 
add wave -color red out
add wave -color grey k/next_state k/current_state

force {clock} 0 0, 1 10ns -r 20ns
force {resetn} 0 0, 1 20ns
#force {KEY} 0 0, 1 100ns, 0 120ns
force {KEY} 0 0, 1 100ns, 0 120ns, 1 150ns, 0 190ns, 1 230ns, 0 400ns
run 1500ns
