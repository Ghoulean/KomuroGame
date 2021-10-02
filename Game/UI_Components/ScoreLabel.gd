extends Label
# ScoreLabel.gd

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

const japanese_numbers = ["０","１","２","３","４","５","６","７","８","９"]

# Called when the node enters the scene tree for the first time.
func _ready():
    update_text(1)

func update_text(score):
    var txt = ""
    while score > 0:
        txt = japanese_numbers[int(score) % 10] + txt
        score = int(score / 10)
    set_text("ＬＥＶＥＬ：" + txt)
