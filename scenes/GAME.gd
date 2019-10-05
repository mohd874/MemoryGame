extends Node2D

var cur_scene

onready var scenes = [$MenuScene,$Levels, $GameManger]

func _ready():
    cur_scene = $MenuScene
    main_menu()

func main_menu():
    hide_scenes()
    $MenuScene.show()
    
func select_level():
    hide_scenes()
    $Levels.show()
    
func go_to_level(level: Dictionary):
    hide_scenes()
    $GameManger.init_game(level)
    $GameManger.show()

func pair_found():
    play_sound("hit")
    
func card_revealed2():
    play_sound("hit")

func play_sound(sound):
    $AudioManager.play_sound(sound)
    
func hide_scenes():
    for s in scenes:
        s.hide()

    
#func swicth_scene(scene_name):
#    var scene = $Scenes.get_scene(scene_name)
#    remove_child(cur_scene)
#    add_child(scene)
#    cur_scene = scene
