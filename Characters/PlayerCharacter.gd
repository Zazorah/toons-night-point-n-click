class_name PlayerCharacter
extends Character

## Controller for the Player character.

signal arrived_at_target # Emitted when it arrives at it's target location.

## Movement Speed
@export var walk_speed := 300.0
var velocity = 0.0 

var headed_to_target: bool

## Node References
@onready var nav_agent = $NavigationAgent2D

func _ready() -> void:
	super()
	
	# Create global reference to self
	GameManager.player_character = self
	
	# Configure NavigationAgent2D
	nav_agent.path_desired_distance = 8.0  # How close to get to each waypoint
	nav_agent.target_desired_distance = 8.0  # How close to get to final target

func _on_room_click(_pos: Vector2) -> void:
	walk_to_point(_pos)

func walk_to_point(target: Vector2) -> void:
	headed_to_target = true
	nav_agent.target_position = target

func _physics_process(delta: float) -> void:
	if not headed_to_target:
		return
	
	if nav_agent.is_navigation_finished():
		arrived_at_target.emit()
		headed_to_target = false
		velocity = 0.0
		print("Arrived at target.")
		return
	
	# Move towards target position
	var next_position = nav_agent.get_next_path_position()
	var direction = (next_position - global_position).normalized()
	
	face_position(next_position)
	velocity = lerp(velocity, walk_speed, 0.2)
	
	# Move at constant speed
	position += direction * velocity * delta
