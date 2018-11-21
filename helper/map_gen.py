from random import *

def to_bin(dec: int, dig: int):
    bin_str = "{0:b}".format(dec)
    extra_str = '0' * (dig - len(bin_str))
    return extra_str + bin_str

if __name__ == "__main__":
    # q = 1
    q = int(input("Please enter the number of items: "))
    print("""
-- Copyright (C) 2018  Intel Corporation. All rights reserved.
-- Your use of Intel Corporation's design tools, logic functions
-- and other software and tools, and its AMPP partner logic
-- functions, and any output files from any of the foregoing
-- (including device programming or simulation files), and any
-- associated documentation or information are expressly subject
-- to the terms and conditions of the Intel Program License
-- Subscription Agreement, the Intel Quartus Prime License Agreement,
-- the Intel FPGA IP License Agreement, or other applicable license
-- agreement, including, without limitation, that your use is for
-- the sole purpose of programming logic devices manufactured by
-- Intel and sold by Intel or its authorized distributors.  Please
-- refer to the applicable agreement for further details.

-- Quartus Prime generated Memory Initialization File (.mif)

WIDTH=32;
DEPTH=16;

ADDRESS_RADIX=BIN;
DATA_RADIX=BIN;

CONTENT BEGIN""");

    __DEBUG = False


    gold_q = q // 3
    stone_q = q // 2
    diamond_q = q - gold_q - stone_q

    map = [[0 for y in range(240 * 16 + 5)] for x in range(320 * 16 + 5)]
    # print(map)

    for i in range(q):
        get = False
        while not get:
            #generate new item location
            rand_x = randint(0, 303 * 16)
            rand_y = randint(80 * 16, 223 * 16)
            left = rand_x
            right = rand_x + 16 * 16
            top = rand_y
            bottom = rand_y + 16 * 16
            # print(left, right, top, bottom)
            #paint the map
            isCovered = 0
            for x in range(left, right):
                for y in range(top, bottom):
                    # print("x,y=",x//100,y//100)
                    if map[x][y] == 1:
                        isCovered = 1
                        break
            if isCovered == 0:
                for x in range(left, right):
                    for y in range(top, bottom):
                        map[x][y] = 1
                if __DEBUG:
                    print(to_bin(i, 4), "\t\t:\t", to_bin(x, 13), "_", to_bin(y, 13), "_", to_bin(0, 4),
                          to_bin((1 if i < gold_q else (0 if i < stone_q + gold_q else 2)), 2),
                          "10", sep="")
                else:
                    print(to_bin(i, 4), "\t\t:\t", to_bin(x, 13), to_bin(y, 12), "000",
                          to_bin((1 if i < gold_q else (0 if i < stone_q + gold_q else 2)), 2),
                          "10", ";", sep="")
                get = True


    print("""[0011..1111]  :   0;
END;""")