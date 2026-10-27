extends ProgressBar

@export var player: CharacterBody2D # Drag and drop your player node here in the Inspector

func _ready() -> void:
	if player:
		# Set the bar's maximum value to match the player's starting health
		max_value = player.max_health
		value = player.health
		
		# Connect to the player's custom health_changed signal
		player.health_changed.connect(_on_player_health_changed)

func _on_player_health_changed(new_health: int) -> void:
	# Update the ProgressBar value whenever the signal is emitted
	value = new_health
