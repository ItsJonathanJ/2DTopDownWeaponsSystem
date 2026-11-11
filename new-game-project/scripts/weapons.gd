extends Sprite2D
class_name Weapons
signal attacking(status: bool)
signal change_weapon_direction(direction: String)
var last_direction = "n";

@export var damage:int = 5
@export var animation:AnimatedSprite2D
@onready var weapon_hitbox:Area2D = $WeaponHitbox

var weapon_angle = 180;

func _ready() -> void: 
	attacking.connect(_attacking_update)
	change_weapon_direction.connect(_change_direction)
	weapon_hitbox.get_node("CollisionShape2D").disabled = true;
	

func _attacking_update(status:bool):
	if(status):
		weapon_hitbox.get_node("CollisionShape2D").disabled = false;
	else:
		weapon_hitbox.get_node("CollisionShape2D").disabled = true;
	
func _change_direction(direction:String):
	if(direction == "n" && last_direction != "n"):
		print("n")
		weapon_hitbox.rotation_degrees = 180
	
	elif(direction == "e" && last_direction != "e"):
		print("e")
		weapon_hitbox.rotation_degrees = 270
	elif(direction == "s" && last_direction != "s"):
		print("s")
		weapon_hitbox.rotation_degrees = 0
	elif(direction == "w" && last_direction != "w"):
		print("w")
		weapon_hitbox.rotation_degrees = 90
		
	last_direction = direction
	
