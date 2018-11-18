vlib work
vlog ../view/draw_diamond.v diamond.v
vsim -L altera_mf_ver draw_diamond
log {/*}

add wave -unsigned X_out_diamond Y_out_diamond current_state next_state
add wave Color_out_diamond
add wave writeEn_diamond draw_diamond_done diamond_count

force {clk} 0 0, 1 10ns -r 20ns
force {resetn} 0 0, 1 20ns
force {enable_draw_diamond} 0 0, 1 30ns, 0 50ns

force {x_init} 0 0, 'd100 30ns
force {y_init} 0 0, 'd100 30ns


run 10000ns