extends Area2D
# ClickToContinue.gd

var _main_scene

func init(main):
    visible = true
    _main_scene = main

func _input_event(viewport, event, shape_idx):
    if Input.is_action_pressed("action"):
        self.on_click()
        
func on_click():
    # go to game
    _main_scene.load_game()
