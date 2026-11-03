extends Node
class_name Weapons

@export var damage:int = 5
@export var animation:AnimatedSprite2D
@onready var weapon_hitbox:Area2D = $WeaponHitbox


func _ready() -> void: 
	#$WeaponHitbox.connect("area_entered", _on_area_entered)
	$WeaponHitbox.connect("body_entered", _on_body_entered)

func _on_body_entered(body:Node2D):
	if(body.is_in_group("enemy")):
		body.damage_recieved.emit(damage)
