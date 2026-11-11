
class_name Hurtbox
extends Area2D
signal damage_recieved(hitbox:Hitbox)
# State to track if the entity is currently safe from damage
var is_invincible: bool = false
# Internal timer created via code to handle the cooldown window
var iframe_timer: Timer
@export var iframe_length: int = 1

func _init() -> void:
	monitoring = false
	monitorable = true

func _ready() -> void:
	area_entered.connect(_on_area_entered)
	_setup_iframe_timer()
func _setup_iframe_timer() -> void:
# Build the timer dynamically so you don't have to manually add it in the editor
	iframe_timer = Timer.new()
	iframe_timer.wait_time = iframe_length
	iframe_timer.one_shot = true
	add_child(iframe_timer)
# When the timer runs out, turn invincibility off
	iframe_timer.timeout.connect(_on_iframe_timer_timeout)
	
func _on_area_entered(incoming_area: Area2D) -> void:
# Ignore all incoming attacks if we are currently invincible
	if is_invincible:
		return
	if incoming_area is Hitbox:
		var hitbox = incoming_area as Hitbox
		damage_recieved.emit(hitbox)
		
func start_invincibility(duration: float) -> void:
	if duration <= 0.0:
		return
	is_invincible = true
	
	# Set deferred ensures the physics engine safely updatescollision states between frames
	set_deferred("monitorable", false)
	iframe_timer.start(duration)
	
func _on_iframe_timer_timeout() -> void:
	is_invincible = false
	set_deferred("monitorable", true)
