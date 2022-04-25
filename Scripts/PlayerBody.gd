extends KinematicBody2D


export (float) var movSpeed = 150
export (PackedScene) var goBullet

onready var gunSpawn1 = $GunSpawn1
onready var gunSpawn2 = $GunSpawn2

onready var playerSprite = $Sprite
var playerSpriteGun1 = preload("res://Assets/Top_Down_Survivor/handgun/idle/survivor-idle_handgun_0.png")
var playerSpriteGun2 = preload("res://Assets/Top_Down_Survivor/rifle/idle/survivor-idle_rifle_0.png")

var timer = 0.0
var muzzleFlash = load("res://Prefabs/MuzzleFlash.tscn")

var hp = 10

var flashing = false
var flashFor = 0.1
var flashTimer = 0.0

var gun = 1
var gunOwnsAK = false
var gunShootEverySec = 0.5
var gunShootTimer = 0
var automatic = false
var bullets = 50
var bulletSpentPerShot = 1
var recoilStr = 2.5
var shootHolding = false
var canShoot = true


# Called when the node enters the scene tree for the first time.
func _ready():
	flashing = false
	flashTimer = 0.0
	get_child(0).material.set_shader_param("flashRange",0.0)
	playerSprite.set_texture(playerSpriteGun1)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var movDir := Vector2.ZERO
	if Input.is_action_pressed("up"):
		movDir.y = -1
	if Input.is_action_pressed("down"):
		movDir.y = 1
	if Input.is_action_pressed("left"):
		movDir.x = -1
	if Input.is_action_pressed("right"):
		movDir.x = 1
		
	movDir = movDir.normalized()
	movDir *= movSpeed
	
	move_and_slide(movDir)
	
	look_at(get_global_mouse_position())
	
	if (flashing):
		flashTimer += delta
		if (flashTimer >= flashFor):
			flashing = false
			flashTimer = 0.0
			get_child(0).material.set_shader_param("flashRange",0.0)
	
	
	#Update bullet count in UI
	get_tree().get_root().get_node("MainGame").get_node("CanvasLayer").get_child(2).set_text(str(bullets))
	#Update HP count in UI
	get_tree().get_root().get_node("MainGame").get_node("CanvasLayer").get_child(3).set_text(str(hp))
	
	if !canShoot && automatic:
		gunShootTimer += delta
		if gunShootTimer >= gunShootEverySec:
			canShoot = true
			gunShootTimer = 0
		
	if Input.is_action_pressed("shoot"):
		if canShoot && bullets >= bulletSpentPerShot:
			shoot()
			canShoot = false

	if Input.is_action_just_released("shoot"):
		canShoot = true
		
	if Input.is_action_just_pressed("Gun1"):
		setGun("Gun")
	if Input.is_action_just_pressed("Gun2") && gunOwnsAK:
		setGun("AK")
	if Input.is_action_just_pressed("Reset"):
		kill()
	if Input.is_action_just_pressed("Return"):
		for child in get_tree().get_root().get_children():
			if child.name != "Global":
				child.queue_free()
		get_tree().change_scene("res://Scenes/MainMenu.tscn")
		
func setGun(type):
	if type == "Gun":
		playerSprite.set_texture(playerSpriteGun1)
		gun = 1
		gunShootEverySec = 0.5
		automatic = false
		bulletSpentPerShot = 1
		recoilStr = 2.5
	elif type == "AK":
		playerSprite.set_texture(playerSpriteGun2)
		gun = 2
		gunShootEverySec = 0.1
		automatic = true
		bulletSpentPerShot = 2
		recoilStr = 4.5
		
func shoot():
	bullets -= bulletSpentPerShot
	
	position -= global_transform.x * recoilStr #knockback
	
	var bulletInstance = goBullet.instance()
	get_tree().get_root().call_deferred("add_child",bulletInstance)
	bulletInstance.rotation_degrees = rotation_degrees
	bulletInstance.setDirection(bulletInstance.global_transform.x)
	
	var particle = muzzleFlash.instance()
	particle.set_emitting(true)
	particle.rotation_degrees = rotation_degrees
	get_tree().get_root().call_deferred("add_child",particle)
	
	if gun == 1:
		$SFXFireGun.play()
		bulletInstance.global_position = gunSpawn1.global_position
		particle.global_position = gunSpawn1.global_position
	elif gun == 2:
		$SFXFireAK.play()
		bulletInstance.global_position = gunSpawn2.global_position
		particle.global_position = gunSpawn2.global_position
		randomize()
		bulletInstance.scale = Vector2(0.6,3.4)
		bulletInstance.global_position += Vector2(rand_range(-12,12),rand_range(-1,1))
		
func kill():
	for child in get_tree().get_root().get_children():
		if child.name != "Global":
			child.queue_free()
	get_tree().reload_current_scene()

func pickUpAmmo(ammount):
	$SFXPickUpAmmo.play()
	bullets += ammount

func pickUpAK():
	$SFXPickUpAK.play()
	gunOwnsAK = true
	setGun("AK")

func _on_Area2D_body_entered(body):
	if "Enemy" in body.name:
		$SFXGetHit.play()
		hp -= 1
		
		position -= global_transform.x * 30 #knockback
		
		get_child(0).material.set_shader_param("flashRange",0.5)
		flashing = true
		
		if hp <= 0:
			kill()
