extends Node2D
# Drawer.gd

var _graph
var _color
var _rng

var COLOR_STDEV = 0.05

func _ready():
    _rng = RandomNumberGenerator.new()
    _rng.randomize()

func init(graph, color):
    _graph = graph
    _color = color

func _draw():
    var vertices = _graph.get_vertices()
    var edges = _graph.get_edges()
    for v in vertices:
        draw_circle(v, 1, Color(0.2, 0.0, 0.0))
        for v2 in vertices:
            if _graph.is_edge(v, v2):
                draw_line(v, v2, (_color + Color(_rng.randfn(0, COLOR_STDEV), _rng.randfn(0, COLOR_STDEV), _rng.randfn(0, COLOR_STDEV))), 2)
        # draw_circle(Vector2(0, 0), 1, Color(0.0, 1.0, 0.0))

