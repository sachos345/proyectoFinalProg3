extends Node

onready var timer = $CanvasLayer/TimerTXT
onready var enemies = $CanvasLayer/EnemyCountTXT
onready var score = $CanvasLayer/ScoreTXT
onready var rank = $CanvasLayer/RankTXT

func _ready():
	timer.set_text(str(floor(Global.finalTime)))
	enemies.set_text(str(Global.finalEnemiesKilled) + "/" + str(Global.totalEnemies))
	var percentkilled = float(Global.finalEnemiesKilled) / Global.totalEnemies * 100
	var temprank = ""
	if percentkilled <= 10:
		temprank = "D"
	elif percentkilled <= 40:
		temprank = "C"
	elif percentkilled <=70:
		temprank = "B"
	elif percentkilled <=99:
		temprank = "A"
	else:
		temprank = "S"
	rank.set_text(str(floor(percentkilled*100)/100) + "% (" + temprank + " RANK)")
	
	var tempscore = 100000/Global.finalTime + Global.finalEnemiesKilled * 100
	score.set_text("FINAL SCORE: " + str(floor(tempscore)))
	
func _on_BTContinue_pressed():
	$SFXUI.play()
	yield(get_tree().create_timer(0.1), "timeout")
	if Global.currentLevel == 1:
		Global.currentLevel = 2
		get_tree().change_scene("res://Scenes/Level2.tscn")
	elif Global.currentLevel == 2:
		Global.currentLevel = 1
		get_tree().change_scene("res://Scenes/Ending.tscn")


func _on_BTReplay_pressed():
	$SFXUI.play()
	yield(get_tree().create_timer(0.1), "timeout")
	if Global.currentLevel == 1:
		get_tree().change_scene("res://Scenes/Level1.tscn")
	elif Global.currentLevel == 2:
		get_tree().change_scene("res://Scenes/Level2.tscn")


func _on_BTMainMenu_pressed():
	$SFXUI.play()
	yield(get_tree().create_timer(0.1), "timeout")
	get_tree().change_scene("res://Scenes/MainMenu.tscn")
