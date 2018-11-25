vlib work
vlog ../../model/degree.v rope_ram-test.v
vsim Rope
log {/*}

add wave -color yellow clock resetn draw_stone_flag go_KEY writeEn
add wave -color grey -unsigned next_state current_state
add wave -color blue -bin read_data tempData tempType data_write
add wave -color blue -unsigned read_address frame_counter
add wave -color green -unsigned rope_len found_stone  tempX tempY score_change
add wave -color red -unsigned rotation_speed line_speed endX endY degree current_score

force {clock} 0 0, 1 10ns -r 20ns
force {resetn} 0 0, 1 20ns
force {enable} 1
force {draw_stone_flag} 0
force {draw_index} 0
force {quantity} 1
#x = 267, y = 229, gold
force {read_data} 10000101110111110010111010000110
force {go_KEY} 0
run 12010ns
force {go_KEY} 1
run 300ns
force {go_KEY} 0
run 100000ns
force {go_KEY} 1
run 10000ns