extends Node2D

@onready var player = $Player
@onready var hud = $HUD
@onready var camera = $Player/Camera2D

func _ready():
	setup_hud_connections()
#	setup_camera_limits()

## Connects player signals to update the HUD and manage game states
func setup_hud_connections():
	if player and hud:
		# Connect player health changes to HUD text update
		player.health_changed.connect(hud.update_health_display)
		
		# Set initial HUD values at game start
		hud.update_health_display(player.health)

## Dynamically calculates camera limits based on the CameraBounds collision box - We'll get this to work later
#func setup_camera_limits():
#	if not bounds_shape or not camera:
#		print("Warning: CameraBounds or Camera2D missing. Camera limits skipped.")
#		return
#		
#	var rect_shape = bounds_shape.shape as RectangleShape2D
#	if not rect_shape:
#		return
		
#	var rect_size = rect_shape.size
#	var rect_pos = bounds_shape.global_position
	
	# Calculate the 4 boundaries of the collision rectangle
#	camera.limit_left = int(rect_pos.x - (rect_size.x / 2))
#	camera.limit_right = int(rect_pos.x + (rect_size.x / 2))
#	camera.limit_top = int(rect_pos.y - (rect_size.y / 2))
#	camera.limit_bottom = int(rect_pos.y + (rect_size.y / 2))
