class_name Camera
extends Camera2D

## Camera Movement
const MOVE_SPD = 50.0
var camera_focus_node: Node2D
var move_target: Vector2
var move_velocity: Vector2

## Debug Properties
const DEBUG_MOVE_SPD = 500.0 # Speed for moving the camera around with debug inputs.

func _init() -> void:
	anchor_mode = Camera2D.ANCHOR_MODE_FIXED_TOP_LEFT

func _ready() -> void:
	GameManager.room_loaded.connect(_set_room_bounds)
	GameManager.player_created.connect(_attach_to_player)
	
	# Set offset.
	offset = Vector2(0, -192.0)

func _attach_to_player(_player: PlayerCharacter) -> void:
	# Follow PlayerCharacter's position
	camera_focus_node = _player

# Creates a Rect2 that is the full bounds the camera can move within.
func _set_room_bounds(_room: Room) -> void:
	var room_size = _room.texture.get_size()
	var camera_size = get_viewport_rect().size
	
	limit_enabled = true
	limit_left = 0
	limit_right = max(0, room_size.x - camera_size.x - offset.x)
	limit_top = 0
	limit_bottom = max(0, room_size.y - camera_size.y - offset.y)


func _physics_process(delta: float) -> void:
	if not camera_focus_node:
		return
	
	# Center camera on the focus node
	var camera_size = get_viewport_rect().size
	var target_position = camera_focus_node.global_position - (camera_size/2.0)
	
	global_position = global_position.lerp(target_position, MOVE_SPD * delta)

func _input(event: InputEvent) -> void:
	if GameManager.debug:
		if event.is_action("camera_left"):
			position.x -= DEBUG_MOVE_SPD
		
		elif event.is_action("camera_right"):
			position.x += DEBUG_MOVE_SPD
		
		elif event.is_action("camera_up"):
			position.y -= DEBUG_MOVE_SPD
		
		elif event.is_action("camera_down"):
			position.y += DEBUG_MOVE_SPD
