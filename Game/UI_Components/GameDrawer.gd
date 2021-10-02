extends Node2D
# GameDrawer.gd

const GameVertex = preload("res://Scenes/UI_Components/GameVertex.tscn")
const GameLine = preload("res://Scenes/UI_Components/GameLine.tscn")

var _graph
var _n_vertices
var _n_lines
var _n_triangles

func init(graph, goal):
    _graph = graph
    var vertices = graph.get_vertices()
    for v in vertices:
        pass
    
func _process(_delta):
    if _graph:
        update()
