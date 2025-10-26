extends Node

## Global game state manager.

# Global State
var debug := true # Whether or not we're in the debug state.

# Global Node References
var camera: Camera
var room: Room:
	set(val):
		room = val
		room_loaded.emit(room)

var player_character: PlayerCharacter:
	set(val):
		player_character = val
		player_created.emit(player_character)

# Signals
signal player_created # Emitted when a new PlayerCharacter Node is created.
signal room_loaded # Emitted when a new Room Node is loaded.

func _ready() -> void:
	_initialize_camera()

func _initialize_camera() -> void:
	if camera:
		camera.queue_free()
	
	camera = Camera.new()
	add_child(camera)
