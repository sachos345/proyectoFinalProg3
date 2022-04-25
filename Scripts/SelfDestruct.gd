extends Node

var destroyInSec = 1
var destroyTimer = 0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	destroyTimer += delta
	if destroyTimer >= destroyInSec:
		queue_free()
