extends Node
# Menu.gd

var _main_scene

onready var click_to_continue = $ClickToContinue

func _ready():
    pass

func init(main):
    _main_scene = main
    click_to_continue.init(_main_scene)
