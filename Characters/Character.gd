class_name Character
extends Node2D

## Node References
var character_animator: CharacterAnimator

## Position
var last_position: Vector2

## Direction
enum Direction {
	N, # North (Up)
	E, # East (Right)
	S, # South (Down)
	W, # West (West)
	NE, # North-East (Up-Right)
	NW, # North-West (Up-Left)
	SE, # South-East (Down-Right)
	SW # South-West (Down-Left)
}
var facing_direction = Direction.E:
	set(val):
		facing_direction = val
		direction_changed.emit(val)

var last_angle := 90.0 # Start facing down.

signal direction_changed

func _ready() -> void:
	last_position = position
	
	GameManager.room_loaded.connect(_update_depth_data)
	_update_depth_data()

func _process(_delta: float) -> void:
	# Update depth and z-index based on position.
	if position != last_position:
		_update_depth_data()
		
		last_position = position

func _update_depth_data(_room: Room = null) -> void:
	if GameManager.room:
		var depth_info = GameManager.room.get_depth_at_position(position)
			
		if depth_info.walkable:
			scale = Vector2(depth_info.scale, depth_info.scale)
			z_index = depth_info.z_index 

func play_animation(anim_name: StringName, ignore_directional := false) -> void:
	# Link with CharacterAnimator
	if not character_animator:
		for child in get_children():
			if child is CharacterAnimator:
				character_animator = child
				break
		
		if not character_animator:
			push_error("Tried to play an animation on a Character without a CharacterAnimator.")
			return
	
	if not ignore_directional:
		character_animator.set_state(anim_name)
	else:
		character_animator.play(anim_name)

func face_position(pos: Vector2) -> Direction:
	var direction = pos - position
	var angle = rad_to_deg(direction.angle())
	
	if abs(angle - last_angle) > 15.0:
		facing_direction = _angle_to_direction(angle)
		last_angle = angle
		print("Updated facing direction to be: ", facing_direction)
		
	return facing_direction

func _angle_to_direction(angle: float) -> Direction:
	# Handle wrapping.
	while angle < 0:
		angle += 360.0
	while angle >= 360:
		angle -= 360.0
	
	if angle >= 337.5 and angle < 22.5:
		return Direction.E
	elif angle >= 22.5 and angle < 67.5:
		return Direction.SE
	elif angle >= 67.5 and angle < 112.5:
		return Direction.S
	elif angle >= 112.5 and angle < 157.5:
		return Direction.SW
	elif angle >= 157.5 and angle < 202.5:
		return Direction.W
	elif angle >= 202.5 and angle < 247.5:
		return Direction.NW
	elif angle >= 247.5 and angle < 292.5:
		return Direction.N
	elif angle >= 292.5 and angle < 337.5:
		return Direction.NE
	
	push_warning("Something has gone wrong when calculating direction from the angle: ", angle)
	return Direction.E
