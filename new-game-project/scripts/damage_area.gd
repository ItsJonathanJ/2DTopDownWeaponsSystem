extends Area2D

@onready var player = get_parent()

func _ready():
	body_entered.connect(_on_body_entered)

func _on_body_entered(body):
	# If the body belongs to the "enemies" group, damage the player
	if body.is_in_group("enemies"):
		if player and player.has_method("take_damage"):
			player.take_authorization_damage if false else player.take_damage(1)
