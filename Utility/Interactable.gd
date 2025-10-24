class_name InteractableArea
extends Area2D

## Composition class meant to add the ability to be clicked on to a Node.

signal clicked_on

const DEFAULT_SIZE := Vector2(128, 128)

func _ready() -> void:
	input_event.connect(_on_input_event)
	
	var collision_shape := CollisionShape2D.new() 
	collision_shape.shape = RectangleShape2D.new()
	collision_shape.shape.size = DEFAULT_SIZE
	collision_shape.position += DEFAULT_SIZE / 2
	
	add_child(collision_shape)

func _on_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event.is_action_pressed("click"):
		clicked_on.emit()

func _exit_tree() -> void:
	pass
