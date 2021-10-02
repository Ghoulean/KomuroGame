extends Area2D
# GameLine.gd

var _graph
var v1
var v2

func init(graph, n1, n2):
    _graph = graph
    set_node(n1, n2)

func set_node(n1, n2):
    v1 = n1
    v2 = n2
    set_position(n1.linear_interpolate(n2, 0.5))
    set_rotation(n1.angle_to_point(n2) + PI / 2)
    var distance = n1.distance_to(n2)
    set_scale(Vector2(1.0 / 128, distance / 128.0))

func _process(delta):
    pass

func _input_event(viewport, event, shape_idx):
    if event is InputEventMouseButton \
    and event.button_index == BUTTON_LEFT \
    and event.is_pressed():
        self.on_click()

func on_click():
    var new_vertices = _graph.flip_edge(v1, v2)
    if !new_vertices:
        return
    set_node(new_vertices[0], new_vertices[1])
