vlib work
vlog item_generator.v
vsim ItemMap
log {/*}

add wave -color yellow clock resetn generateEn size

add wave -color red -unsigned data 
add wave -color blue -unsigned counter x y tempX tempY isCovered
add wave -color blue -unsigned testX testY tempOld tempData usedData

add wave -color yellow -unsigned moveEn moveIndex moveX moveY moveState
add wave -color blue -unsigned isMoving 
add wave loop_counter resetn_loop_counter check_done resetn_isCovered set_isCovered load_tempData load_tempOld endloop
add wave -unsigned current_state next_state start_loop

force {clock} 0 0, 1 10ns -r 20ns
force {resetn} 0 0, 1 20ns

force {generateEn} 0 0, 1 10ns, 0 750ns
force {quantity} 'd28
force {moveIndex} 'd3
run 1000ns

force {moveEn} 1
force {moveX} 10000000010
force {moveY} 10
force {moveState} 1
force {moveIndex2} 100
force {moveEn2} 1
force {moveX2} 0000000010
force {moveY2} 10
force {moveState2} 1
force {visible} 1
force {visible2} 1 

run 160ns