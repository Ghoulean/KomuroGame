extends Node
# GameEngine.gd

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
    _level += 1
    _set_up_graphs(true)

func reroll_level():
    _set_up_graphs(false)
    
func _set_up_graphs(preset):
    var valid = false
    var tries = 10
    while !valid:
        tries -= 1
        valid = true
        if (preset && get_level_points(_level)):
            _goal_graph.set_points(get_level_points(_level))
        else:
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
    if _level <= 40:
        return 6
    if _level <= 80:
        return 7
    if _level <= 150:
        return 8
    return 9

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

func get_level_points(n):
    if n == 1:
        return [Vector2(-28.848076, 26.820595), Vector2(-5.316879, 41.932343), Vector2(-2.045246, -41.932343), Vector2(28.848076, 3.176441)]
    elif n == 2:
        return [Vector2(-31.862904, -7.413593), Vector2(-17.359493, -37.59026), Vector2(16.585869, 37.59026), Vector2(31.8629, 14.832172)]
    elif n == 6:
        return [Vector2(-20.895287, 40.254211), Vector2(-5.525604, -23.694288), Vector2(-0.378044, 38.726418), Vector2(12.514565, -40.254211), Vector2(20.895279, -6.855808)]
    elif n == 7:
        return [Vector2(-33.034382, 39.860111), Vector2(-23.973259, -25.277576), Vector2(-17.33366, -45.285458), Vector2(9.53828, -26.276035), Vector2(33.034386, 45.285458)]
    return null
