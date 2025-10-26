extends Node

## Global game state manager.

# Global State
var debug := true # Whether or not we're in the debug state.

# Global Nodes
var camera: Camera

func _ready() -> void:
	_initialize_camera()

func _initialize_camera() -> void:
	if camera:
		camera.queue_free()
	
	camera = Camera.new()
	add_child(camera)
