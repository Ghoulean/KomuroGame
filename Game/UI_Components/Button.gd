extends Button
# Skip level button

var _game_engine

func init(game_engine):
    _game_engine = game_engine

func _on_Button_button_up():
    _game_engine.reroll_level()
