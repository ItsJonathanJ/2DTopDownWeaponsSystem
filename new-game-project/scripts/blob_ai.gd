extends CharacterBody2D

enum State { IDLE, PATROL, CHASE }
var current_state: State = State.IDLE

@export var speed: float = 40.0
@export var chase_speed: float = 80.0
@export var patrol_distance: float = 120.0

var start_position: Vector2
var patrol_direction: int = 1
var player_target: CharacterBody2D = null
var idle_timer: float = 0.0

@onready var sprite = $WalkAnimation
@onready var detection_area: Area2D = $DetectionArea

func _ready():
	start_position = global_position
	detection_area.body_entered.connect(_on_detection_body_entered)
	detection_area.body_exited.connect(_on_detection_body_exited)

func _physics_process(delta):
	match current_state:
		State.IDLE:
			velocity = Vector2.ZERO
			idle_timer -= delta
			if idle_timer <= 0:
				current_state = State.PATROL
				
		State.PATROL:
			velocity.x = patrol_direction * speed
			velocity.y = 0
			
			if sprite:
				sprite.flip_h = patrol_direction > 0
				
			if abs(global_position.x - start_position.x) > patrol_distance:
				patrol_direction *= -1
				current_state = State.IDLE
				idle_timer = 2.0
				
		State.CHASE:
			if player_target:
				var distance = global_position.distance_to(player_target.global_position)
				
				if distance < 15.0:
					# Stop moving right when close enough to attack/touch
					velocity = Vector2.ZERO
				else:
					# Move directly toward the player cleanly
					var direction = global_position.direction_to(player_target.global_position)
					velocity = direction * chase_speed
					
					if sprite:
						sprite.flip_h = direction.x > 0
			else:
				current_state = State.PATROL

	move_and_slide()

func _on_detection_body_entered(body):
	if body.is_in_group("player"):
		player_target = body
		current_state = State.CHASE

func _on_detection_body_exited(body):
	if body == player_target:
		player_target = null
		start_position = global_position
		current_state = State.PATROL
