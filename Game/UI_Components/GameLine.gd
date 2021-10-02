extends Area2D
# GameLine.gd

var _graph
var v1
var v2
var _cooldown
var MAX_CD

func init(graph, n1, n2):
    _graph = graph
    MAX_CD = 0.1
    set_node(n1, n2)

func set_node(n1, n2):
    v1 = n1
    v2 = n2
    set_position(n1.linear_interpolate(n2, 0.5))
    set_rotation(n1.angle_to_point(n2) + PI / 2)
    var distance = n1.distance_to(n2)
    set_scale(Vector2(1.0 / 192, distance / 128.0))
    _cooldown = MAX_CD

func _process(delta):
    _cooldown = max(0, _cooldown - delta)

func _input_event(viewport, event, shape_idx):
    if _cooldown > 0:
        return
    if Input.is_action_pressed("action"):
        self.on_click()

func on_click():
    var new_vertices = _graph.flip_edge(v1, v2)
    if !new_vertices:
        return
    set_node(new_vertices[0], new_vertices[1])
