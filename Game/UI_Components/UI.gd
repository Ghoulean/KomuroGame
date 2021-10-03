extends Node
# UI.gd

var _game_engine

onready var _game_canvas = $Game
onready var _hud_canvas = $HUD

onready var _drawer = $Game/Drawer
onready var _gamedrawer = $Game/GameDrawer

onready var _score_label = $HUD/ScoreLabel
onready var _timer_label = $HUD/TimerLabel

onready var click_sfx = $Audio/ClickSFX
onready var level_win_sfx = $Audio/LevelWinSFX

onready var button = $HUD/Button

onready var _windows_size = get_viewport().size
# min margin from any one side
onready var margins = 1

const DRAW_COLOR = Color(0.2, 0.2, 0.2)

func init(game_engine):
    _game_engine = game_engine
    update_canvas()
    _drawer.init(game_engine.get_goal(), DRAW_COLOR)
    _gamedrawer.init(game_engine.get_graph(), game_engine.get_goal())
    _game_engine.connect("new_level", self, "_load_new_level")
    _game_engine.get_graph().connect("flip_edge", click_sfx, "play_click")
    button.init(game_engine)

func update_canvas():
    var bounds = _game_engine.get_graph().get_bounds().grow(margins)
    var scale = _windows_size / bounds.size
    var zoom = min(scale.x, scale.y)
    _game_canvas.set_scale(Vector2(1, 1) * zoom)
    var offset = (_windows_size / 2)
    _game_canvas.set_offset(offset)
    
func _load_new_level():
    level_win_sfx.play()
    _gamedrawer.break_animation(Vector2(0, 0))
    
    var t = Timer.new()
    t.set_wait_time(0.5)
    t.set_one_shot(true)
    self.add_child(t)
    t.start()
    yield(t, "timeout")
    t.queue_free()
    
    _gamedrawer.clear()
    update_canvas()
    _drawer.init(_game_engine.get_goal(), DRAW_COLOR)
    _drawer.update()
    _gamedrawer.init(_game_engine.get_graph(), _game_engine.get_goal())
    _score_label.update_text(_game_engine.get_level())
    _timer_label.make_log(_game_engine.get_level())
