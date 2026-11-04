extends CharacterBody2D

signal health_changed(current_health, max_health)

@export var speed = 200
@export var iframe_duration: float = 0.6
@export var max_health: int = 100

# Knockback settings
@export var knockback_friction: float = 10.0

@onready var animated_sprite = $AnimatedSprite2D
@onready var hurtbox: Hurtbox = $PlayerHurtbox

var last_direction = "s"
var is_action_playing = false
var is_dead = false

var current_health: int

# Knockback variables
var knockback_velocity: Vector2 = Vector2.ZERO
var is_in_knockback: bool = false

var flash_tween: Tween

func _ready() -> void:
	current_health = max_health

	if health_changed.get_connections().size() > 0:
		health_changed.emit(current_health, max_health)

	# Connect the hurtbox damage signal
	hurtbox.damage_recieved.connect(_on_damage_received)


func _physics_process(delta: float) -> void:
	if is_dead:
		velocity = Vector2.ZERO
		return

	var input_direction = Input.get_vector(
		"move_left",
		"move_right",
		"move_up",
		"move_down"
	)

	# Preserve directional tracking
	update_direction(input_direction)

	# Preserve movement and idle animations
	if not is_action_playing:
		update_movement_animation(input_direction)

	# Knockback temporarily overrides normal movement
	if is_in_knockback:
		velocity = knockback_velocity

		knockback_velocity = knockback_velocity.move_toward(
			Vector2.ZERO,
			knockback_friction * speed * delta
		)

		if knockback_velocity.length() < 10.0:
			is_in_knockback = false
			knockback_velocity = Vector2.ZERO
	else:
		velocity = input_direction * speed

	move_and_slide()


func update_direction(input_direction):
	if input_direction.y < 0:
		last_direction = "n"
	elif input_direction.y > 0:
		last_direction = "s"
	elif input_direction.x < 0:
		last_direction = "w"
	elif input_direction.x > 0:
		last_direction = "e"


func update_movement_animation(input_direction):
	if input_direction == Vector2.ZERO:
		animated_sprite.play("idle_" + last_direction)
	else:
		animated_sprite.play("walk_" + last_direction)


func play_action_animation(action_name):
	if is_dead and action_name != "death":
		return

	is_action_playing = true
	animated_sprite.play(action_name + "_" + last_direction)


func _unhandled_input(event):
	if is_dead:
		return

	if event.is_action_pressed("attack"):
		play_action_animation("attack")

	elif event.is_action_pressed("test_hit"):
		play_action_animation("hit")
		take_damage(25)

	elif event.is_action_pressed("test_die"):
		die()


func _on_animated_sprite_2d_animation_finished() -> void:
	if not is_dead:
		is_action_playing = false


# Receive the entire Hitbox object from the Hurtbox
func _on_damage_received(hitbox: Hitbox) -> void:
	if is_dead:
		return

	if hurtbox.is_invincible:
		return

	# Take damage from the enemy
	take_damage(hitbox.damage)

	# Apply knockback away from the enemy
	if not is_dead:
		apply_knockback(
			hitbox.global_position,
			hitbox.knockback_force
		)


func take_damage(amount: int) -> void:
	if is_dead:
		return

	if hurtbox.is_invincible:
		return

	current_health = clampi(
		current_health - amount,
		0,
		max_health
	)

	# Update health bar
	health_changed.emit(current_health, max_health)

	# Activate invincibility frames
	hurtbox.start_invincibility(iframe_duration)

	# Play hit animation
	if current_health > 0:
		play_action_animation("hit")
		flash_sprite()

	if current_health <= 0:
		die()


func apply_knockback(source_position: Vector2, force: float) -> void:
	var knockback_direction = (
		global_position - source_position
	).normalized()

	# Default direction if both objects overlap
	if knockback_direction == Vector2.ZERO:
		knockback_direction = Vector2.DOWN

	knockback_velocity = knockback_direction * force
	is_in_knockback = true


func flash_sprite() -> void:
	# Stop an existing flash animation
	if flash_tween and flash_tween.is_running():
		flash_tween.kill()

	flash_tween = create_tween()

	flash_tween.tween_property(
		animated_sprite,
		"modulate:a",
		0.4,
		iframe_duration / 4.0
	)

	flash_tween.tween_property(
		animated_sprite,
		"modulate:a",
		1.0,
		iframe_duration / 4.0
	)

	flash_tween.tween_property(
		animated_sprite,
		"modulate:a",
		0.4,
		iframe_duration / 4.0
	)

	flash_tween.tween_property(
		animated_sprite,
		"modulate:a",
		1.0,
		iframe_duration / 4.0
	)


func heal(amount: int) -> void:
	if is_dead:
		return

	current_health = clampi(
		current_health + amount,
		0,
		max_health
	)

	health_changed.emit(current_health, max_health)


func die() -> void:
	if is_dead:
		return

	is_dead = true
	is_action_playing = true
	is_in_knockback = false

	velocity = Vector2.ZERO

	# Stop flashing so the death animation is visible
	if flash_tween and flash_tween.is_running():
		flash_tween.kill()

	animated_sprite.modulate.a = 1.0

	# Preserve your directional death animation
	animated_sprite.play("death_" + last_direction)

	await animated_sprite.animation_finished

	get_tree().reload_current_scene()
