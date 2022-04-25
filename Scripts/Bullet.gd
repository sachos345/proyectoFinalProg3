extends Area2D


export (float) var speed = 800

var direction
var dieParticle = load("res://Prefabs/Sparks.tscn")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var velocity = direction * speed * delta
	global_position += velocity
	
func setDirection(direction: Vector2):
	self.direction = direction

func die():
	var particle = dieParticle.instance()
	particle.set_emitting(true)
	particle.global_position = global_position
	particle.rotation_degrees = global_rotation_degrees - 180
	get_tree().get_root().call_deferred("add_child",particle)

func _on_Bullet_body_entered(body):
	if "Enemy" in body.name && $VisibilityNotifier2D.is_on_screen():
		queue_free()
		body.getDamaged(1)
		if (body.getHP() <= 0):
			body.die()
			body.queue_free()
	if "TileMap" in body.name && $VisibilityNotifier2D.is_on_screen():
		get_tree().get_root().get_node("MainGame").get_node("PlayerBody").get_node("SFXBulletDie").play()
		die()
		queue_free()
