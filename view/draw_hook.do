vlib work
vlog draw_hook_FSM_data.v
vsim draw_hook
log {/*}

add wave -color yellow clock resetn
add wave -color grey -hex current_state next_state 

add wave -color green enable centerX centerY degree trigAbsX trigAbsY
add wave -color green trigSignX trigSignY
add wave -color red outX outY
add wave -color blue -hex delay_counter DELAY_TIME