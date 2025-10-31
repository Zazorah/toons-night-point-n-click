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


func find_nearest_walkable_point(offset_distance: float = 0.0, click_position: Vector2 = Vector2.ZERO) -> Vector2:
	if not GameManager.room:
		push_error("Character has no room reference!")
		return global_position
	
	var nav_region = GameManager.room.navigation_region
	if not nav_region:
		push_error("Room has no NavigationRegion2D!")
		return global_position
	
	var map_rid = nav_region.get_navigation_map()
	
	# If no offset needed, return the nearest point to character
	if offset_distance <= 0.0:
		return NavigationServer2D.map_get_closest_point(map_rid, global_position)
	
	# Calculate preferred direction
	var preferred_direction: Vector2
	if click_position != Vector2.ZERO:
		preferred_direction = (click_position - global_position).normalized()
	else:
		var nearest = NavigationServer2D.map_get_closest_point(map_rid, global_position)
		preferred_direction = (nearest - global_position).normalized()
	
	# Try the preferred direction first
	var best_point = global_position + preferred_direction * offset_distance
	best_point = NavigationServer2D.map_get_closest_point(map_rid, best_point)
	
	# Check if the point is actually at the desired distance
	var actual_distance = global_position.distance_to(best_point)
	
	# If close enough, return it
	if abs(actual_distance - offset_distance) < offset_distance * 0.3:
		return best_point
	
	# Otherwise, try multiple angles around the character
	var best_candidate = best_point
	var best_score = INF
	
	for i in range(8):
		var angle = i * TAU / 8.0
		var test_direction = preferred_direction.rotated(angle)
		var test_position = global_position + test_direction * offset_distance
		var nav_point = NavigationServer2D.map_get_closest_point(map_rid, test_position)
		
		# Score based on distance from desired offset and alignment with preferred direction
		var distance_error = abs(global_position.distance_to(nav_point) - offset_distance)
		var direction_to_point = (nav_point - global_position).normalized()
		var alignment = preferred_direction.dot(direction_to_point)
		var score = distance_error - alignment * 10.0  # Prefer aligned directions
		
		if score < best_score:
			best_score = score
			best_candidate = nav_point
	
	return best_candidate
