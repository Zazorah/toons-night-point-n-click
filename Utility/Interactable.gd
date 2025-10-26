class_name InteractableArea
extends Area2D

## Composition class meant to add the ability to be clicked on to a Node.

signal clicked_on

var rect: Rect2

const DEFAULT_SIZE := Vector2(128, 128)

func _ready() -> void:
	input_event.connect(_on_input_event)
	
	add_to_group("Interactables")
	
	# Setup collision shape
	var collision_shape := CollisionShape2D.new() 
	collision_shape.shape = RectangleShape2D.new()
	collision_shape.shape.size = DEFAULT_SIZE
	collision_shape.position += DEFAULT_SIZE / 2
	
	rect = Rect2(to_global(position), DEFAULT_SIZE)
	
	add_child(collision_shape)

func process_click(context: ClickContext) -> bool:
	if rect.has_point(context.world_position):
		clicked_on.emit()
		return true
	
	return false

func _on_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event.is_action_pressed("click"):
		pass # clicked_on.emit()


func _exit_tree() -> void:
	remove_from_group("Interactables")
