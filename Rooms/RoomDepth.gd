class_name RoomDepth
extends RefCounted

## Container for information about a position in a room.

var walkable: bool
var z_index: int
var scale: float

func _init(_walkable: bool = true, _z: int = 0, _scale: float = 1.0) -> void:
	walkable = _walkable
	z_index = _z
	scale = _scale
