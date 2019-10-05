extends AudioStreamPlayer

# Declare member variables here. Examples:
var audio_clips = {
    "hit":preload("res://sound/hit.wav"),
}

# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
    pass

func play_sound(sound_name):
#    print('sound '+sound_name+' played')
    self.stream = audio_clips[sound_name]
    self.play(0)