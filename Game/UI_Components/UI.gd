extends Node
# UI.gd

var _game_engine

onready var _game_canvas = $Game
onready var _hud_canvas = $HUD

onready var _drawer = $Game/Drawer
onready var _drawer2 = $Game/Drawer2
onready var _gamedrawer = $Game/GameDrawer

onready var _windows_size = OS.get_window_size()
# min margin from any one side
onready var margins = 1

func init(game_engine):
    _game_engine = game_engine
    update_canvas()
    _drawer.init(game_engine.get_graph(), Color(1.0, 1.0, 0))
    _drawer2.init(game_engine.get_goal(), Color(0, 0, 1.0))
    _gamedrawer.init(game_engine.get_graph(), game_engine.get_goal())

func update_canvas():
    var bounds = _game_engine.get_graph().get_bounds().grow(margins)
    var scale = _windows_size / bounds.size
    var zoom = min(scale.x, scale.y)
    _game_canvas.set_scale(Vector2(1, 1) * zoom)
    var offset = (_windows_size / 2)
    _game_canvas.set_offset(offset)
