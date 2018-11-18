vlib work
vlog bomb.v
vsim Bomb
log {/*}

add wave -color yellow clock resetn buy used

add wave -color yellow -unsigned quantity

force {clock} 0 0, 1 10ns -r 20ns
force {resetn} 0 0, 1 20ns
force {buy} 0 0, 1 70ns, 0 90ns, 1 130ns, 0 150ns
force {used} 0 0, 1 190ns, 0 210ns
run 300ns