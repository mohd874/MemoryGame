extends Node2D

signal go_to_level(level)
signal go_to_main_menu

var levels_data = {}
var MAX_BUTTONS_IN_ROW = 6

var padding = 20
var btn_size = 260
#var gameManagerPacked
var levels_btns = []

# Called when the node enters the scene tree for the first time.
func _ready():
    load_levels()
#    gameManagerPacked = preload("res://scenes/GameManager2.tscn")

func load_levels():
    # Open levels file
    var file = File.new()
    file.open("res://levels/levels_data.json", file.READ)
    var text = file.get_as_text()
    levels_data = parse_json(text)
    file.close()
    
    # Get each level dir path
    # Add level nodes (buttons) to this scene
    var row = 0
    var col = 0
    for level in levels_data.levels:
        var pos = {"x": $Start.position.x + (self.btn_size * row) + self.padding, "y": $Start.position.y + (self.btn_size * col) + self.padding}
        add_level_button(level, pos)
        row += 1
        if row+1 > MAX_BUTTONS_IN_ROW:
            row = 0
            col += 1
    
    # For each button -> assign on click to show the selected level
    
    
func add_level_button(level, pos):
#    print('adding button')
    var btn = $TemplateButton.duplicate()
#    print('adding level to button')
#	btn.text = str(level.level)
    var btn_sprite = btn.get_child(0)
    btn_sprite.texture = load("res://sprites/ui/n"+str(level.level)+".png")
    btn.level = level
    btn.levels_manager = self
    btn.set_script(load("res://scripts/LevelButton.gd"))
    btn.rect_position.x = pos.x
    btn.rect_position.y = pos.y
    btn.connect("pressed", btn, "_on_LevelButton_pressed")
    
    levels_btns.append(btn)
    add_child(btn)

#func start_game(level):
#    hide_levels_btns()
#    var root = get_tree().get_root()
#    var game = gameManagerPacked.instance()
#    game.init_game(level)
#    var sound_player = root.get_node('MenuScene').sound_player
#    game.sound_player = sound_player
#    add_child(game)

func start_level(level):
    emit_signal("go_to_level", level)
#
#func _on_LevelButton_pressed():
#    print("pressed")

#func hide_levels_btns():
#    for b in levels_btns:
#        b.hide()
#
##func show_levels_btns():
#    for b in levels_btns:
#        b.show()

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass



func _on_BackButton_pressed():
    emit_signal("go_to_main_menu")
