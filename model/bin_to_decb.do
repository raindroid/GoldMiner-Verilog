vlib work
vlog bin_to_decb.v
vsim  bin_dec
log {/*}

add wave {/*}

force {clk} 0 0, 1 10ns -r 20ns
force {rst_n} 0 0, 1 20ns
force {bin} 0 0, 'd4024 30ns

run 1000ns