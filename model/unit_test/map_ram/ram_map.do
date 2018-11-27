vlib work
vlog ram_map.v
vsim MapRam
log {/*}

add wave -color yellow clock resetn enable 
add wave -color green -bin read_req_code write_req_code 

add wave -color green -hex address0 address1 address2 write_data1 write_data2

add wave -color green -unsigned current_state next_state

add wave -color red -bin read_data_done write_data_done
add wave -color red -hex data

force {clock} 0 0, 1 10ns -r 20ns
force {resetn} 0 0, 1 20ns
force {enable} 1
force {write_data1} 1
force {write_data2} 10
run 130ns

force {read_req_code} 111
force {write_req_code} 000
force {address0} 0
run 140ns

force {read_req_code} 110
force {write_req_code} 000
force {address1} 0
run 140ns

force {read_req_code} 000
force {write_req_code} 110
force {address1} 0
force {write_data1} 1
force {write_data2} 10
run 140ns

force {read_req_code} 000
force {write_req_code} 100
force {address1} 0
force {write_data1} 1
force {write_data2} 10
run 40ns