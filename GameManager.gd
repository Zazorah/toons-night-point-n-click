extends Node

## Global game state manager.

# Global State
var debug := true # Whether or not we're in the debug state.
var pickup_collection_status: Dictionary[StringName, bool] # Collection status of pickups.

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

# Inventory
@onready var inventory := Inventory.new()

# Transition Handling
var transition_tag: StringName

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

func pickup_was_collected(pickup_key: StringName) -> bool:
	return pickup_collection_status.get(pickup_key, false)

func register_pickup_status(pickup_key: StringName) -> void:
	pickup_collection_status.set(pickup_key, true)
