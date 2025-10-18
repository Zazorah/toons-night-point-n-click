class_name EventShowMessage
extends Event

## State
var message: String
var wait_time: float

func _init(_msg: String, _wait_time := 1.0) -> void:
	message = _msg
	wait_time = _wait_time

func execute(_scene_tree: SceneTree) -> void:
	print(message)
	await _scene_tree.create_timer(wait_time).timeout
