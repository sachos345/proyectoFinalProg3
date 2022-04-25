extends Node2D

func _process(delta):
	if Input.is_action_pressed("shoot"):
		get_tree().change_scene("res://Scenes/Level1.tscn")
