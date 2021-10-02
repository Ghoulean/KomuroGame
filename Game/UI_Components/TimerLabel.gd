extends Label

var seconds
var minutes
var hours

var logs = []

# Called when the node enters the scene tree for the first time.
func _ready():
    hours = 0
    minutes = 0
    seconds = 0

func get_time_string():
    return "{}:{}:{}:{}".format(["%03d" % hours, "%02d" % minutes, "%02d" % seconds, "%03d" % ((seconds - int(seconds)) * 1000)], "{}")

func _process(delta):
    seconds += delta
    if seconds >= 60:
        minutes += 1
        seconds -= 60
    if minutes >= 60:
        hours += 1
        minutes -= 60
    text = get_time_string()
    if logs.size() > 0:
        text += "\n" + logs[logs.size() - 1]

func make_log(level):
    if level % 100 == 0:
        logs.append("「" + get_time_string() + "」")
    elif level % 10 == 0:
        logs.append(get_time_string())
