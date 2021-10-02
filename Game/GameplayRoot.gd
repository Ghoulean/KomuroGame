extends Node
# GameplayRoot.gd

onready var _game_engine = $GameEngine
onready var _ui = $UI

var _main_scene

func init(main):
    _main_scene = main

func _ready():
    _game_engine.init()
    _ui.init(_game_engine)
