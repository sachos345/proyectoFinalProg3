extends Node2D

export (String) var type = "Ammo"
export (int) var ammountGive = 100

onready var pickUpSprite = $Area2D/Sprite
var spriteAmmo = preload("res://Assets/AmmoBox.png")
var spriteAK = preload("res://Assets/poshlinov.png")

func _ready():
	if type == "Ammo":
		pickUpSprite.set_texture(spriteAmmo)
	elif type == "AK":
		pickUpSprite.set_texture(spriteAK)
		pickUpSprite.scale = Vector2(4,4)
		
func _on_Area2D_body_entered(body):
	if "PlayerBody" in body.name:
		if type == "Ammo":
			body.pickUpAmmo(ammountGive)
		elif type == "AK":
			body.pickUpAK()
		queue_free()
