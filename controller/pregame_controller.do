vlib work
vlog pregame_controller.v
vsim PreGame
log {/*}

add wave -color yellow clock resetn 
add wave -color grey -hex current_state next_state 

add wave -color green start mode cbk_from_reset cbk_from_view cbk_from_end_confirm
add wave -color red user_name_req clear_req
add wave -color blue -hex delay_counter DELAY_TIME

force {clock} 0 0, 1 10ns -r 20ns
force {resetn} 0 0, 1 20ns
force {start} 0 0, 1 40ns, 0 60ns
force {cbk_from_reset} 0 0, 1 90ns, 0 110ns

#Test for 1 user mode
force {mode} 0 0, 01 190ns
force {cbk_from_view} 0 0, 0 210ns
force {cbk_from_view} 1 490ns, 0 510ns
force {cbk_from_view} 1 650ns, 0 670ns
force {cbk_from_end_confirm} 0 0, 1 1010ns, 0 1030ns
run 1300ns