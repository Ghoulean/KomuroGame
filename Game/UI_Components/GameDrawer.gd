extends Node2D
# GameDrawer.gd

const GameVertex = preload("res://Scenes/UI_Components/GameVertex.tscn")
const GameLine = preload("res://Scenes/UI_Components/GameLine.tscn")

var _graph
var _n_vertices
var _n_lines
var _n_triangles

func init(graph, goal):
    _n_vertices = []
    _n_lines = []
    _n_triangles = []

    _graph = graph
    var vertices = graph.get_vertices()
    for v1 in vertices:
        for v2 in vertices:
            if !graph._lexicographic_comparator(v1, v2):
                continue
            if graph.is_edge(v1, v2):        
                var game_line = GameLine.instance()
                get_parent().add_child(game_line)
                game_line.init(graph, v1, v2)
                _n_lines.append(game_line)
    for v in vertices:
        var game_vertex = GameVertex.instance()
        get_parent().add_child(game_vertex)
        game_vertex.init(graph, v)
        _n_vertices.append(game_vertex)

func clear():
    for v in _n_vertices:
        v.queue_free()
    for e in _n_lines:
        e.queue_free()
    
