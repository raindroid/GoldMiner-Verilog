vlib work
vlog draw_hook_FSM_data.v
vsim draw_hook
log {/*}

add wave -color yellow clock resetn
add wave -color grey -hex current_state next_state 

add wave -color green -dec enable centerX centerY degree
add wave -color red -dec outX outY color writeEn done
add wave -color blue -dec degree_counter xRad tempX tempY

add wave -dec midX interX

force {clock} 0 0, 1 10ns -r 20ns
force {resetn} 0 0, 1 20ns
force {enable} 0 0, 1 30ns, 0 50ns
force {centerX} 10110100
force {centerY} 1111000
force {degree} 1011010

run 10000ns