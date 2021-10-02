extends Node2D
# GameVertex.gd

var _graph
var vertex
var _break_velocity

func _ready():
    set_scale(Vector2(1, 1) / 128)
    _break_velocity = Vector2(0, 0)

func init(graph, v):
    _graph = graph
    vertex = v
    set_position(vertex)

func _process(delta):
    if _break_velocity != Vector2(0, 0):
        set_position(get_position() + _break_velocity)

func break_animation(from):
    _break_velocity = 4 * (get_position() - from) / get_position().distance_squared_to(from)
