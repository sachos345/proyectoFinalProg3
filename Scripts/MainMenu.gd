extends Node2D

func _ready():
	Global.currentLevel = 1
	
func _on_BTPlay_pressed():
	$SFXUI.play()
	yield(get_tree().create_timer(0.1), "timeout")
	get_tree().change_scene("res://Scenes/Intro.tscn")

func _on_BTQuit_pressed():
	$SFXUI.play()
	yield(get_tree().create_timer(0.2), "timeout")
	get_tree().quit()
