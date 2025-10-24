class_name Room
extends Sprite2D

## Node class representing a space that Characters and Entities inhabit.

## State
const show_debug_depth := true

## Depth Properties
@export var depth_map: Texture2D
@export_range(0.1, 2.0) var min_scale := 0.5
@export_range(0.1, 2.0) var max_scale := 1.5
@export var min_z_index := 0
@export var max_z_index := 100

func _init():
	centered = false

func _ready():
	ClickManager.room = self
	ClickManager.click_processed.connect(_handle_click)

func _handle_click(context: ClickContext) -> void:
	var depth = get_depth_at_position(context.world_position)
	print(depth)

func get_depth_at_position(pos: Vector2) -> Dictionary:
	if not depth_map:
		push_warning("No depth map set for this room.")
		return { "scale": 1.0, "z_index": 0, "walkable": true }
	
	var img = depth_map.get_image()
	var tex_size = depth_map.get_size()
	
	var x = clamp(int(pos.x), 0, tex_size.x - 1)
	var y = clamp(int(pos.y), 0, tex_size.y - 1)
	
	var pixel = img.get_pixel(x, y)
	var depth_value = pixel.r
	
	if pixel.a == 0.0:
		return { "scale": 1.0, "z_index": 0, "walkable": false }
	
	return {
		"scale": lerp(min_scale, max_scale, depth_value),
		"z_index": lerp(min_z_index, max_z_index, depth_value),
		"walkable": true
	}

func _draw():
	if show_debug_depth and (Engine.is_editor_hint() or OS.is_debug_build()):
		if depth_map and show_debug_depth:
			draw_texture(depth_map, position, Color(1, 1, 1, 1))
