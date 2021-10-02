extends Reference
class_name Triangle

var vertices
var a
var b
var c

# immutable class
func _init(v1, v2, v3):
    vertices = [v1, v2, v3]
    vertices.sort_custom(self, "_lexicographic_comparator")
    a = vertices[0]
    b = vertices[1]
    c = vertices[2]
    if !_ccw(a, b, c):
        var d = b
        b = c
        c = d

# thanks someone I don't know who but you're awesome
func is_inside_triangle(s):
    var as_x = s[0] - a[0]
    var as_y = s[1] - a[1]
    var s_ab = ((b[0] - a[0]) * as_y - (b[1] - a[1]) * as_x) > 0
    if (((c[0] - a[0]) * as_y - (c[1] - a[1]) * as_x) > 0) == s_ab:
        return false
    if (((c[0] - b[0]) * (s[1] - b[1]) - (c[1] - b[1]) * (s[0] - b[0])) > 0) != s_ab:
        return false
    return true

# thanks TitouanT
func is_inside_circumcircle(d):
    var ax_ = a.x - d.x
    var ay_ = a.y - d.y
    var bx_ = b.x - d.x
    var by_ = b.y - d.y
    var cx_ = c.x - d.x
    var cy_ = c.y - d.y
    return (
        (ax_*ax_ + ay_*ay_) * (bx_*cy_-cx_*by_) -
        (bx_*bx_ + by_*by_) * (ax_*cy_-cx_*ay_) +
        (cx_*cx_ + cy_*cy_) * (ax_*by_-bx_*ay_)
    ) > 0

func has_edge(v1, v2):
    var count = 0
    if v1 == a || v1 == b || v1 == c:
        count += 1
    if v2 == a || v2 == b || v2 == c:
        count += 1
    return count == 2

func get_edges():
    return [[a, b], [b, c], [a, c]]

func has_vertex(v):
    return v == a || v == b || v == c

func get_vertices():
    return vertices

func equals(other):
    return other.a == a && other.b == b && other.c == c

func _lexicographic_comparator(a, b):
    if a.x != b.x:
        return a.x < b.x
    else:
        return a.y < b.y

func _ccw(a, b, c):
    return (b.x - a.x) * (c.y - a.y) - (c.x - a.x) * (b.y - a.y) > 0

func _to_string():
    return "Triangle[" + str(a) + "," + str(b) + "," + str(c) + "]"

