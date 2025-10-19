class_name ClickContext
extends RefCounted

## Class that contains the full context of a mouse-click event.
## Created and passed down by ClickManager.

var screen_position: Vector2
var world_position: Vector2

func _init(_screen_pos, _world_pos) -> void:
	screen_position = _screen_pos
	world_position = _world_pos
