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
    var valid = false
    var tries = 10
    while !valid:
        tries -= 1
        valid = true
        _goal_graph.generate_random_points(_get_vertices())
        _graph.copy(_goal_graph)
        _graph.BowyerWatson()
        if _graph.probably_reroll() && tries > 0:
            valid = false
            continue
        _goal_graph.AndrewFornet()
        if _is_game_end():
            valid = false
            continue
    _level += 1
    emit_signal("new_level")

func get_graph():
    return _graph
    
func get_goal():
    return _goal_graph

func _get_vertices():
    if _level <= 5:
        return 4
    if _level <= 20:
        return 5
    if _level <= 50:
        return 7
    if _level <= 80:
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

func _new_level_delay():
    set_up_new_level()
