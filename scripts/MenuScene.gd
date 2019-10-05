extends Node2D

signal selectLevel
signal quit

#var gameManagerPacked 
#var gameManagerUnpacked

onready var GAME = get_tree().get_root().get_node("GAME")
var levelsScene

func _ready():
#	gameManagerPacked = preload("res://scenes/GameManager2.tscn")
#	gameManagerUnpacked = gameManagerPacked.instance()
    
    levelsScene = preload('res://scenes/Levels.tscn').instance()
    print(GAME)
    
func _on_StartButton_pressed():
    emit_signal("selectLevel")
    
#	get_node("StartButton").visible = false
#	get_node("QuitButton").visible = false
#	get_node("BackButton").visible = true
#	get_node("GameName").visible = false
#	get_node("Credits").visible = false
#	# add_child(gameManagerUnpacked)
#	add_child(levelsScene)
    

func _on_QuitButton_button_down():
    get_tree().quit()
    
