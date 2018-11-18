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

force {clock} 0 0, 1 10ns -r 20ns
force {resetn} 0 0, 1 20ns
force {size} 10000
force {generateEn} 0 0, 1 10ns, 0 260ns
force {moveIndex} 0
run 390ns
force {moveEn} 1
force {moveX} 10000000010
force {moveY} 10
force {moveState} 1
run 80ns