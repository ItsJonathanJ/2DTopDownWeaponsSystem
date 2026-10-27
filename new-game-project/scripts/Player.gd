extends CharacterBody2D

# Signals
signal health_changed(new_health)
signal game_over # Signal to notify the Level / HUD that the player lost

@export var speed: float = 200.0
@export var max_health: int = 3

@onready var anim: AnimatedSprite2D = $AnimatedSprite2D
@onready var sword_hitbox: Area2D = $Area2D
@onready var sword_shape: CollisionShape2D = $Area2D/CollisionShape2D

var current_state: String = "idle"
var facing_direction: String = "s"

var health: int = 3
var coins: int = 0

func _ready():
	health = max_health
	anim.animation_finished.connect(_on_animated_sprite_2d_animation_finished)

func _physics_process(_delta):
	if current_state in ["attack", "hit", "die"]:
		velocity = Vector2.ZERO
		move_and_slide()
		return

	var input_dir = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	velocity = input_dir * speed

	if input_dir != Vector2.ZERO:
		current_state = "walk"
		facing_direction = get_8way_direction(input_dir)
	else:
		current_state = "idle"

	var target_anim = current_state + "_" + facing_direction
	if anim.animation != target_anim or not anim.is_playing():
		anim.play(target_anim)

	move_and_slide()

	if Input.is_action_just_pressed("action_attack"):
		set_state("attack")
	elif Input.is_action_just_pressed("action_hit"):
		take_damage(1)

func get_8way_direction(input_vector: Vector2) -> String:
	var angle = input_vector.angle()
	var step = TAU / 8.0
	var index = posmod(int(round(angle / step)), 8)
	var directions = ["e", "se", "s", "sw", "w", "nw", "n", "ne"]
	return directions[index]

func set_state(new_state: String):
	current_state = new_state
	var target_anim = current_state + "_" + facing_direction
	anim.play(target_anim)

func take_damage(amount: int = 1):
	if current_state == "die":
		return
	
	health = max(0, health - amount)
	health_changed.emit(health)
	
	if health <= 0:
		set_state("die")
	else:
		set_state("hit")

func _on_animated_sprite_2d_animation_finished():
	if current_state == "die":
		lose_game()
		return
		
	if current_state in ["attack", "hit"]:
		current_state = "idle"
		anim.play("idle_" + facing_direction)

func update_sword_position():
	var offset: float = 24.0 # Distance in pixels from player center
	match facing_direction:
		"n":  sword_hitbox.position = Vector2(0, -offset)
		"ne": sword_hitbox.position = Vector2(offset * 0.7, -offset * 0.7)
		"e":  sword_hitbox.position = Vector2(offset, 0)
		"se": sword_hitbox.position = Vector2(offset * 0.7, offset * 0.7)
		"s":  sword_hitbox.position = Vector2(0, offset)
		"sw": sword_hitbox.position = Vector2(-offset * 0.7, offset * 0.7)
		"w":  sword_hitbox.position = Vector2(-offset, 0)
		"nw": sword_hitbox.position = Vector2(-offset * 0.7, -offset * 0.7)
		
# Called automatically when the death animation finishes
func lose_game():
	print("Player has died. Game Over!")
	game_over.emit()
	GameManager.lose_game()
