extends Node2D
# Drawer.gd

var _graph
var _color

func init(graph, color):
    _graph = graph
    _color = color

func _draw():
    var vertices = _graph.get_vertices()
    var edges = _graph.get_edges()
    for v in vertices:
        draw_circle(v, 0.5, Color(1.0, 0.0, 0.0))
        for v2 in vertices:
            if _graph.is_edge(v, v2):
                draw_line(v, v2, _color, 1)
        # draw_circle(Vector2(0, 0), 1, Color(0.0, 1.0, 0.0))

