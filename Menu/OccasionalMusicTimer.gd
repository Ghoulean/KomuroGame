extends Timer
# OccasionalMusicTimer

onready var occasional_music = $OccasionalMusic

export var countdown:int

func _ready():
    set_paused(false)
    set_one_shot(false)
    start(countdown)
    set_autostart(false)
    connect("timeout", self, "on_tick")
    
func on_tick():
    if !occasional_music.is_playing():
        occasional_music.play()
