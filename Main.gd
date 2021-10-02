extends Node
# Main.gd

const Menu = preload("res://Menu/Menu.tscn")
const Game = preload("res://Game/Gameplay.tscn")

onready var scene = $Scene

func _ready():
    load_menu()
    # load_game()

func load_menu():
    _delete_children(scene)
    var new_instance = Menu.instance()
    scene.add_child(new_instance)
    new_instance.init(self)

func load_game():
    _delete_children(scene)
    var new_instance = Game.instance()
    scene.add_child(new_instance)
    new_instance.init(self)

func _delete_children(node):
    for n in node.get_children():
        node.remove_child(n)
        n.queue_free()
