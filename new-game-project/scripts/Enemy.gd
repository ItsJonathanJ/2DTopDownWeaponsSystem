extends CharacterBody2D

@export var speed: float = 50.0
@onready var sprite = $WalkAnimation # Or AnimatedSprite2D

var direction: int = -1 # -1 is left, 1 is right

func _physics_process(_delta):
	# Move horizontally, keep vertical movement at 0
	velocity.x = direction * speed
	velocity.y = 0
	
	move_and_slide()
	
	# If the enemy hits a wall/obstacle, reverse direction
	if is_on_wall():
		direction *= -1
		# Flip the sprite visually when changing direction
		if sprite:
			sprite.flip_h = direction > 0

# Connect this to your Enemy's Hitbox (Area2D) "body_entered" signal
func _on_hitbox_body_entered(body):
	if body.name == "Player" and body.has_method("take_damage"):
		body.take_damage()
