extends Node2D

func _process(delta):
	if Input.is_action_pressed("Return"):
		get_tree().change_scene("res://Scenes/MainMenu.tscn")
