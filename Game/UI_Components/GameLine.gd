extends TextureRect
# GameLine.gd

var v1_node
var v2_node

func set_node(n1, n2):
    v1_node = n1
    v2_node = n2

func _process(delta):
    pass

func _input(event):
    if event is InputEventMouseButton:
        print("It is a mouse click.")
