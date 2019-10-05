extends TextureButton

signal start_level(level)

var level = null
var levels_manager = null
var sound_scene = null
# Called when the node enters the scene tree for the first time.
func _ready():
    pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _on_LevelButton_pressed():
#	levels_manager.start_game(level)
    emit_signal("start_level", level)
