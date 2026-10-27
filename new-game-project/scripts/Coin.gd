extends Area2D

@onready var collision_shape = $CollisionShape2D
@onready var collect_sound = $CollectSound

func _on_body_entered(body):
	if body.name == "Player":
		GameManager.add_coin()
		hide() # Hide sprite immediately 
		
		# Safely disable collision without crashing if missing
		if collision_shape:
			collision_shape.set_deferred("disabled", true)
		
		# Safely play sound and wait for it to finish
		if collect_sound and collect_sound.stream:
			collect_sound.play()
			await collect_sound.finished
		
		queue_free()
