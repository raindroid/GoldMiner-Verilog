vlib work
vlog ../model/degree.v draw_hook_FSM_data.v
vsim draw_hook
log {/*}

add wave -color yellow clock resetn
add wave -color grey -unsigned current_state next_state 

add wave -color green -unsigned enable length degree
add wave -color red -unsigned outX outY color writeEn done
add wave -color blue -unsigned centerX centerY degree_counter length_counter 
add wave -unsigned deg_cos deg_sin deg_signCos deg_signSin
add wave -unsigned cos sin signCos signSin tempX tempY
add wave -unsigned longX longY

force {clock} 0 0, 1 10ns -r 20ns
force {resetn} 0 0, 1 20ns
force {enable} 0 0, 1 30ns, 0 50ns
force {length} 110010
force {degree} 1111

run 100000ns