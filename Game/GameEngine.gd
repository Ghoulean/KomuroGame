extends Node
# GameEngine.gd

var _rng

var _graph
var _goal_graph

var _level

signal new_level
signal edge_flipped

func init():
    _level = 0
    set_up_new_level()

func set_up_new_level():
    _graph = Graph.new()
    _goal_graph = Graph.new()
    _goal_graph.generate_random_points(13)
    _goal_graph.BowyerWatson()
    _graph.copy(_goal_graph)
    _graph.AndrewFornet()
    if _is_game_end():
        set_up_new_level()
        return
    _level += 1
    emit_signal("new_level")
    print(_graph.get_triangles().size())

func get_graph():
    return _graph
    
func get_goal():
    return _goal_graph

func _is_game_end():
    var goal_triangles = _goal_graph.get_triangles()
    var count = 0
    for t in goal_triangles:
        if _graph.has_triangle(t):
            count += 1
    if count == goal_triangles.size():
        return true
    var triangles = _graph.get_triangles()
    count = 0
    for t in triangles:
        if _goal_graph.has_triangle(t):
            count += 1
    if count == triangles.size():
        return true
    return false

func get_level():
    return _level
    
func _input_flip_edge():
    emit_signal("edge_flipped")
