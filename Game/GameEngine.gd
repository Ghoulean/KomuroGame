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
    _graph = Graph.new()
    _goal_graph = Graph.new()
    _graph.connect("flip_edge", self, "_try_move_on")
    set_up_new_level()

func set_up_new_level():
    _goal_graph.generate_random_points(_get_vertices())
    _goal_graph.BowyerWatson()
    if _goal_graph.probably_reroll():
        set_up_new_level()
        return
    _graph.copy(_goal_graph)
    _graph.AndrewFornet()
    if _is_game_end():
        set_up_new_level()
        return
    print("next level")
    _level += 1
    emit_signal("new_level")

func get_graph():
    return _graph
    
func get_goal():
    return _goal_graph

func _get_vertices():
    if _level <= 3:
        return 4
    if _level <= 10:
        return 5
    if _level <= 25:
        return 7
    if _level <= 50:
        return 11
    return 14

func get_level():
    return _level

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

func _try_move_on():
    if _is_game_end():
        set_up_new_level()
