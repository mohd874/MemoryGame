extends Node

onready var scenes = {
    "MainMenu":"res://scenes/MenuScene.tscn",
    "SelectLevel":"res://scenes/Levels.tscn",
    "GameScreen":"res://scenes/GameManager2.tscn"
    }

func get_scene(scene_name):
    var path = scenes[scene_name]
#	var scene = preload(path)
#	return scene

func swicth_scene(scene_name):
    get_tree().change_scene(scenes[scene_name])