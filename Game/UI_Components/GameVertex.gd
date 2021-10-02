extends Node2D
# GameVertex.gd

var _graph
var vertex

func _ready():
    set_scale(Vector2(1, 1) / 128)

func init(graph, v):
    _graph = graph
    vertex = v
    set_position(vertex)
