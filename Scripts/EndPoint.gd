extends Node

func _on_Area2D_body_entered(body):
	if "PlayerBody" in body.name:
		Global.finalTime = get_tree().get_root().get_node("MainGame").get_node("CanvasLayer").timer
		Global.finalEnemiesKilled = get_tree().get_root().get_node("MainGame").get_node("CanvasLayer").enemyKilled
		Global.totalEnemies = get_tree().get_root().get_node("MainGame").get_node("CanvasLayer").enemyCountTotal
		for child in get_tree().get_root().get_children():
			if child.name != "Global":
				child.queue_free()
		get_tree().change_scene("res://Scenes/PostLevelScreen.tscn")
