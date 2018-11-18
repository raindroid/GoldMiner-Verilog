/**
 * This is the module for generating new item list
 * List Format:
 *      At most 8 items in the list
 *      For item n: 
            [n * 18 + 17 :  n * 18 + 9] left
            [n * 18 + 8 :   n * 18 + 1] top
            [n * 18] occupied?
 *
 * INPUT:
 *      clock
 *      resetn: syn low active reset
 *      number
 *
 * PARAMETER:
 *
 * OUTPUT:
 *      [180: 0] list_DATA

 * Author: Yucan Wu
 * Version: 0.0.1
 * Created: Nov 17, 2018
 * Last Updated: Nov 17, 2018, just started
 * Tested: init
 **/
