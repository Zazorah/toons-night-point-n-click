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

@onready var navigation_region: NavigationRegion2D

## Audio Properties
@export var music: AudioStream

## Signals
signal room_ready 	# Emitted when room data is finished loading.

func _init():
	centered = false

func _ready():
	# Establish Global References
	GameManager.room = self
	ClickManager.room = self
	
	# Play Music
	if music:
		AudioManager.play_music(music)
	
	await _generate_navigation_from_depth_map()
	room_ready.emit()

## Bakes a navigation region for the room for Character pathfinding.
# TODO - Set this up to bake forever as a resource. Tool script or something.
func _generate_navigation_from_depth_map():
	if not depth_map:
		return
	
	# Create NavigationRegion2D if it doesn't exist.
	if not navigation_region:
		navigation_region = NavigationRegion2D.new()
		add_child(navigation_region)
	
	var img = depth_map.get_image()
	var tex_size = depth_map.get_size()
	
	# Create a bitmap for walkable areas.
	var walkable_bitmap = BitMap.new()
	walkable_bitmap.create(tex_size)
	
	# Mark walkable pixels (alpha > 0)
	for y in range(tex_size.y):
		for x in range(tex_size.x):
			var pixel = img.get_pixel(x, y)
			if pixel.a > 0.0:
				walkable_bitmap.set_bit(x, y, true)
	
	var polygons = walkable_bitmap.opaque_to_polygons(Rect2(Vector2.ZERO, tex_size))
	
	var nav_poly = NavigationPolygon.new()
	for polygon in polygons:
		nav_poly.add_outline(polygon)
	
	nav_poly.make_polygons_from_outlines()
	
	navigation_region.navigation_polygon = nav_poly

func get_depth_at_position(pos: Vector2) -> RoomDepth:
	if depth_map == null:
		push_warning("No depth map set for this room.")
		return RoomDepth.new()
	
	var img = depth_map.get_image()
	var tex_size = depth_map.get_size()
	
	var x = clamp(int(pos.x), 0, tex_size.x - 1)
	var y = clamp(int(pos.y), 0, tex_size.y - 1)
	
	var pixel = img.get_pixel(x, y)
	var depth_value = pixel.r
	
	if pixel.a == 0.0:
		return RoomDepth.new(false)
	
	return RoomDepth.new(
		true,
		lerp(min_z_index, max_z_index, depth_value),
		lerp(min_scale, max_scale, depth_value)
	)

func _draw():
	if GameManager.debug:
		if show_debug_depth and depth_map:
			draw_texture(depth_map, position, Color(1, 1, 1, 0.5))
		
		if GameManager.debug and navigation_region and navigation_region.navigation_polygon:
			_draw_navigation_mesh()

func _draw_navigation_mesh():
	var nav_poly = navigation_region.navigation_polygon
	
	# Draw each polygon in the navigation mesh
	for i in range(nav_poly.get_polygon_count()):
		var polygon = nav_poly.get_polygon(i)
		var points = PackedVector2Array()
		
		for idx in polygon:
			points.append(nav_poly.get_vertices()[idx])
		
		# Draw filled polygon
		draw_colored_polygon(points, Color(0, 1, 0, 0.3))  # Green with transparency
		
		# Draw outline
		for j in range(points.size()):
			var next_j = (j + 1) % points.size()
			draw_line(points[j], points[next_j], Color(0, 1, 0, 0.8), 2.0)
