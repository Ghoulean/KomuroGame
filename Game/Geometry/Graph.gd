extends Reference
class_name Graph

var _rng

# array
var _vertices
# vertex->vertex two-way dict
var _edges
# 2d array consisting of 3-item vertices
var _triangles

var _bounds

var SCALE = 100

func _init():
    _rng = RandomNumberGenerator.new()
    _rng.randomize()

func copy(other):
    _vertices = []
    for v in other.get_vertices():
        _vertices.append(v)
    _triangles = []
    for t in other.get_triangles():
        _triangles.append(Triangle.new(t.a, t.b, t.c))
    _edges = {}
    for v in _vertices:
        _edges[v] = {}
        for v2 in _vertices:
            _edges[v][v2] = false
    for t in _triangles:
        var e = t.get_edges()
        _set_edge(e[0][0], e[0][1])
        _set_edge(e[1][0], e[1][1])
        _set_edge(e[2][0], e[2][1])
    _calculate_bounds()
    

# Generate in pre-determined tile
# Tiles in pseudo-spiral pattern with padding
# e.g. (0, 0), (0, 2), (2, 2), (2, 0), (4, 0), 
#      (4, 2), (4, 4), (2, 4), (0, 4), (0, 6)...
func generate_random_points(n):
    assert(n >= 3)
    _vertices = []
    for i in range(n):
        _vertices.append(SCALE * Vector2(_rng.randf(), _rng.randf()))
    _calculate_bounds()
    for i in range(len(_vertices)):
        _vertices[i] -= (_bounds.position + _bounds.size / 2)
    _edges = {}
    for v in _vertices:
        _edges[v] = {}
        for v2 in _vertices:
            _edges[v][v2] = false
    _triangles = []
    _calculate_bounds()

func _calculate_bounds():
    _bounds = Rect2(_vertices[0], Vector2(0, 0))
    for v in _vertices:
        _bounds = _bounds.expand(v)
    _bounds = _bounds.abs()

# Graham scan
func _generate_convex_hull():
    assert(_vertices != null)
    assert(_vertices.size() >= 3)
    var _convex_hull = []
    _vertices.sort_custom(self, "_polar_comparator")
    for v in _vertices:
        while _convex_hull.size() > 1:
            var next_to_top = _convex_hull[_convex_hull.size() - 2]
            var top = _convex_hull[_convex_hull.size() - 1]
            if (top.x - next_to_top.x) * (v.y - next_to_top.y) - (top.y - next_to_top.y) * (v.x - next_to_top.x) <= 0:
                _convex_hull.pop_back()
            else:
                break
        _convex_hull.append(v)
    for i in range(_convex_hull.size()):
        var v1 = _convex_hull[i]
        var v2 = _convex_hull[(i+1)%_convex_hull.size()]
        if !is_edge(v1, v2):
            var v3 = []
            for v_i in _vertices:
                if is_edge(v1, v_i) && is_edge(v2, v_i):
                    v3.append(v_i)
            if v3.size() == 0:
                continue
            var vmin = v3[0]
            for v_i in v3:
                if Triangle.new(v1, v2, vmin).is_inside_triangle(v_i):
                    vmin = v_i
            _set_edge(v1, v2)
            _triangles.append(Triangle.new(v1, v2, vmin))
            print(v1, v2, v3, vmin)
    return _convex_hull

# Warning: may leave graph in inconsistent state
func _set_edge(v1, v2):
    _edges[v1][v2] = true
    _edges[v2][v1] = true

# Warning: may leave graph in inconsistent state
func _unset_edge(v1, v2):
    _edges[v1][v2] = false
    _edges[v2][v1] = false

func is_vertex(v):
    return v in _vertices 

func is_edge(v1, v2):
    if !is_vertex(v1) || !is_vertex(v2):
        return false
    return _edges[v1][v2]

# Delaunay triangulation algorithm
func BowyerWatson():
    var triangulation = []
    _clear_edges()
    var bottom_super_triangle = _bounds.position + Vector2(_bounds.size.x / 2, -500)
    var half_x_super_triangle = _bounds.size.y + _bounds.size.x / 2 + 500
    var super_a = bottom_super_triangle + Vector2(half_x_super_triangle, 0)
    var super_b = bottom_super_triangle - Vector2(half_x_super_triangle, 0)
    var super_c = bottom_super_triangle + Vector2(0, half_x_super_triangle * 2)
    triangulation.append(Triangle.new(super_a, super_b, super_c))
    
    _vertices.sort_custom(self, "_lexicographic_comparator")
    for v in _vertices:
        var bad_triangles = []
        for triangle in triangulation:
            if triangle.is_inside_circumcircle(v):
                bad_triangles.append(triangle)
        var polygon = []
        for triangle in bad_triangles:
            var edges = triangle.get_edges()
            for e in edges:
                var shared = false
                for other_tri in bad_triangles:
                    if other_tri.equals(triangle):
                        continue
                    if other_tri.has_edge(e[0], e[1]):
                        shared = true
                        break
                if !shared:
                    polygon.append(e)
        for triangle in bad_triangles:
            for i in range(triangulation.size()):
                var check_triangle = triangulation[i]
                if triangle.equals(check_triangle):
                    triangulation.remove(i)
                    break
        for e in polygon:
            var new_tri = Triangle.new(e[0], e[1], v)
            triangulation.append(new_tri)
    var i = 0
    while i < triangulation.size():
        var triangle = triangulation[i]
        if triangle.has_vertex(super_a) || triangle.has_vertex(super_b) || triangle.has_vertex(super_c):
            triangulation.remove(i)
            i -= 1
        i += 1
    _triangles = triangulation
    _recalculate_edges()

# triangulation based off Andrew's monotone chain convex hull
# augmented by Marcelo Fornet
func AndrewFornet():
    var triangulations = []
    _clear_edges()
    _vertices.sort_custom(self, "_lexicographic_comparator")
    var u = []
    var l = []
    for v in _vertices:
        while l.size() >= 2 && _ccw(l[l.size() - 2], l[l.size() - 1], v) == false:
            triangulations.append(Triangle.new(l[l.size() - 2], l[l.size() - 1], v))
            l.pop_back()
        l.append(v)
    _vertices.invert()
    for v in _vertices:
        while u.size() >= 2 && _ccw(u[u.size() - 2], u[u.size() - 1], v) == false:
            triangulations.append(Triangle.new(u[u.size() - 2], u[u.size() - 1], v))
            u.pop_back()
        u.append(v)
    _triangles = triangulations
    _recalculate_edges()

func _clear_edges():
    _edges = {}
    for v in _vertices:
        _edges[v] = {}
        for v2 in _vertices:
            _edges[v][v2] = false
    

# prereq: triangles must be populated
func _recalculate_edges():
    _clear_edges()
    for t in _triangles:
        var e = t.get_edges()
        _set_edge(e[0][0], e[0][1])
        _set_edge(e[1][0], e[1][1])
        _set_edge(e[2][0], e[2][1])

#v1, v2, v3 + v1, v2, v4 ==> v1, v3, v4 + v2, v3, v4
# unattach v1-v2 and add v3-v4
func flip_edge(v1, v2):
    if !is_edge(v1, v2):
        print("fail: not an edge")
        return false
    var commons = _common_vertex(v1, v2)
    if commons.size() < 2:
        print("fail: can't find enough commons")
        return false
    assert(commons.size() == 2)
    # test if quadrilateral is convex; abort otherwise
    if Triangle.new(v1, v2, commons[0]).is_inside_triangle(commons[1]):
        print("fail: not quadrilateral")
        return false
    if Triangle.new(v1, v2, commons[1]).is_inside_triangle(commons[0]):
        print("fail: not quadrilateral")
        return false
    if Triangle.new(v1, commons[0], commons[1]).is_inside_triangle(v2):
        print("fail: not quadrilateral")
        return false
    if Triangle.new(v2, commons[0], commons[1]).is_inside_triangle(v1):
        print("fail: not quadrilateral")
        return false 
    var change_triangles = _get_triangle([v1, v2])
    var new_triangles = [Triangle.new(v1, commons[0], commons[1]), Triangle.new(v2, commons[0], commons[1])]
    _unset_edge(v1, v2)
    _set_edge(commons[0], commons[1])
    for t in change_triangles:
        for i in range(_triangles.size()):
            if _triangles[i].equals(t):
                print("removing ", _triangles[i])
                _triangles.remove(i)
                break
    _triangles.append_array(new_triangles)
    print("flipped: ", v1, v2, " with ", commons[0], commons[1])
    print("added ", new_triangles)
    return commons

func _get_triangle(vs):
    var tris = []
    for t in _triangles:
        var valid = true
        for v in vs:
            if !t.has_vertex(v):
                valid = false
                break
        if valid:
            tris.append(t)
    return tris

func _get_adjacent(v):
    var adj = []
    for v1 in _vertices:
        if v == v1:
            continue
        if is_edge(v, v1):
            adj.append(v1)
    return adj

# if there exists a triangle with v1, v2, v3, add v3 to commons
func _common_vertex(v1, v2):
    assert(v1 != v2)
    var commons = []  
    for t in _triangles:
        if t.has_vertex(v1) && t.has_vertex(v2):
            # lol
            var common = t.a
            if common == v1 || common == v2:
                common = t.b
            if common == v1 || common == v2:
                common = t.c
            commons.append(common)
    return commons

func equals(graph):
    var other_vertices = graph.get_vertices()
    var other_edges = graph.get_edges()
    if other_vertices.size() != _vertices.size():
        return false
    for v in _vertices:
        if !graph.is_vertex(v):
            return false
    for v in other_vertices:
        if !is_vertex(v):
            return false
    for v1 in _vertices:
        for v2 in _vertices:
            if is_edge(v1, v2) != graph.is_edge(v1, v2):
                return false
    return true

func get_vertices():
    return _vertices

func get_edges():
    return _edges

func get_triangles():
    return _triangles

func has_triangle(t):
    for c in _triangles:
        if t.equals(c):
            return true
    return false

func get_bounds():
    return _bounds

func _lexicographic_comparator(a, b):
    if a.x != b.x:
        return a.x < b.x
    else:
        return a.y < b.y

func _polar_comparator(a, b):
    # vertices MUST BE origin-normalized
    return a.angle() < b.angle()

func _ccw(a, b, c):
    return (b.x - a.x) * (c.y - a.y) - (c.x - a.x) * (b.y - a.y) > 0
