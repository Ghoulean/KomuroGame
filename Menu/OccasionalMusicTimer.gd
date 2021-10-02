extends Timer
# OccasionalMusicTimer

onready var occasional_music = $OccasionalMusic

func _ready():
    set_paused(false)
    set_one_shot(false)
    start(120)
    set_autostart(true)
    connect("timeout", self, "on_tick")
    
func on_tick():
    if !occasional_music.is_playing():
        occasional_music.play()
