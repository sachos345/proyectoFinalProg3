extends KinematicBody2D


export (float) var speed = 150
export (int) var type = 1

var hp = 3
var flashing = false
var flashFor = 0.1
var flashTimer = 0.0

var blood = load("res://Prefabs/Blood.tscn")
var bloodExpl = load("res://Prefabs/BloodExpl.tscn")
var corpse = load("res://Prefabs/Corpse.tscn")

onready var ghostSprite = $Sprite
var spriteGhost1 = preload("res://Assets/ghost1.png")
var spriteGhost2 = preload("res://Assets/ghost2.png")

# Called when the node enters the scene tree for the first time.
func _ready():
	if type == 1:
		ghostSprite.set_texture(spriteGhost1)
		speed = 150
		hp = 3
	elif type == 2:
		ghostSprite.set_texture(spriteGhost2)
		hp = 5
		speed = 250

func _process(delta):
	if (flashing):
		flashTimer += delta
		if (flashTimer >= flashFor):
			flashing = false
			flashTimer = 0.0
			get_child(0).material.set_shader_param("flashRange",0.0)
			

func _physics_process(delta):
	var player = get_parent().get_parent().get_node("PlayerBody")
	var movDir = player.position - position
	if (global_position.distance_to(player.global_position) < 400):
		movDir = movDir.normalized()
		
		movDir *= speed
		
		look_at(player.position)
		move_and_slide(movDir)

func getDamaged(var dmg):
	$SFXGetHit.play()
	position -= global_transform.x * 10 #knockback
	
	get_child(0).material.set_shader_param("flashRange",0.5)
	flashing = true
	hp -= dmg
	
	if hp > 0:
		var bloodSplatter = blood.instance()
		bloodSplatter.set_emitting(true)
		bloodSplatter.global_position = global_position
		bloodSplatter.rotation_degrees = global_rotation_degrees - 180
		get_tree().get_root().call_deferred("add_child",bloodSplatter)

func die():
	get_tree().get_root().get_node("MainGame").get_node("PlayerBody").get_node("SFXEnemyDie").play()
	var bloodSplatter = bloodExpl.instance()
	bloodSplatter.set_emitting(true)
	bloodSplatter.global_position = global_position
	bloodSplatter.rotation_degrees = global_rotation_degrees - 180
	get_tree().get_root().call_deferred("add_child",bloodSplatter)
	
	var corpses = corpse.instance()
	corpses.z_index = -1
	corpses.global_position = global_position
	corpses.rotation_degrees = global_rotation_degrees - 180
	get_tree().get_root().call_deferred("add_child",corpses)
	
	#Update Enemy Killed Count
	get_tree().get_root().get_node("MainGame").get_node("CanvasLayer").increaseEnemyKilled()

func getHP():
	return hp
