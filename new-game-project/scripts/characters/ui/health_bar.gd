extends TextureProgressBar

# How long the bar takes to slide to the new value
@export var animation_duration: float = 0.25
@export var entity:CharacterBody2D;

# Holds the active tween animation
var health_tween: Tween

func _ready() -> void:
	# Locate the player node using the Player group

	if entity:
		# Connect to future health changes
		entity.health_changed.connect(_on_entity_health_changed)

		# Initialize the health bar immediately
		max_value = entity.max_health
		value = entity.current_health


func _on_entity_health_changed(current_health: int, max_health: int) -> void:
	# Update maximum health
	max_value = max_health

	# Stop any existing animation
	if health_tween and health_tween.is_running():
		health_tween.kill()

	# Create a new Tween
	health_tween = create_tween()

	# Smoothly animate the health bar
	health_tween.tween_property(
		self,
		"value",
		current_health,
		animation_duration
	).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
