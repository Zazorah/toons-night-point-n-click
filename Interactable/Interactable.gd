class_name InteractableArea
extends Area2D

## Composition class meant to add the ability to be clicked on to a Node.

signal clicked_on

func _ready() -> void:
	input_event.connect(_on_input_event)

func _on_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event.is_action_pressed("click"):
		clicked_on.emit()
