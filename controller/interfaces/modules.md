<p style="color: blue;font-size:80%">Version 0.0.1

# Gold Miner
- Main
    有一个Main主线进程控制所有的Stage
## View
- Start
    - input: 
        - show_help_KEY
        - start_game_KEY
    - output:
        - game_start_EN
- InputMode
    - input:
        - data_reset_DONE
    - output:
        - mode_DATA
- InputName
  (有点难搞，以后再说，现在跳过)
- Game
    - input:
        - level_DATA
        - item_lists_DATA
        - target_score_DATA
        - score_DATA
        - bomb_DATA
        - x/y/rope_len/degree _DATA
        - USER1_up/down_KEY
        - USER2_up/down_KEY
        - continue_KEY
        - end_KEY
        - purchase_KEY
    - output:
        - item_generate_EN
        - continue_game_EN
        - purchase_DONE
        (购买时候判断score是否足够，然后给controller操作，再delay重新读取分数，同一个变量不能同时被多个module写入)
        - score_change_DATA
        - state_DATA
        (in-game(1) or purchasing(0))
- CountDownTimer
    - input:
        - restart_EN
    - output:
        - time_left_DATA
## Controller
- PreGame
    - input:
        - reset_DONE
        - mode_input_DONE
    - output:
        - game_control_EN
- KeyDetector
    - input:
        - input_PHYSICAL_KEY
    - output:
        - input_DATA
        (can set up delays)
- RopeController
    - input:
        - item_lists_DATA
    - output:
        - rotation_speed
        (not used)
        - line_speed
        (not used)
        - endX/endY/rope_len/degree _DATA
- Scores
    - input:
        - state_DATA
        - score_change_DATA
        - reset_EN
    - output:
        - score
## Model
(Resets of all modules are controlld by Main)
- UserNames
  (not used)
- Bombs
    - input:
        - bomb_change_DATA
    - output:
        - bomb_DATA
- ItemGenerator
    - input:
        - generate_EN
        (或者直接用reset代替)
    - output:
        - item_lists