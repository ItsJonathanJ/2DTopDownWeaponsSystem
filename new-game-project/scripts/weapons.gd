extends Sprite2D
class_name Weapons
signal attacking(status: bool)

@export var damage:int = 5
@export var animation:AnimatedSprite2D
@onready var weapon_hitbox:Area2D = $WeaponHitbox


func _ready() -> void: 
	attacking.connect(_attacking_update)
	weapon_hitbox.get_node("CollisionShape2D").disabled = true;

func _attacking_update(status:bool):
	if(status):
		weapon_hitbox.get_node("CollisionShape2D").disabled = false;
	else:
		weapon_hitbox.get_node("CollisionShape2D").disabled = true;


	
