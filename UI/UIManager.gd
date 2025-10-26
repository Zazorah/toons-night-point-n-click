extends Node

## Manager for UIElement instances.

var ui_root: Control

func _ready() -> void:
	# Initialize UI Root
	ui_root = Control.new()
	get_tree().root.add_child.call_deferred(ui_root)
	
	_initialize_test_ui()

func process_click(click_context: ClickContext) -> bool:
	for child in ui_root.get_children():
		if child is UIElement and false: # child.contains_point(click_context.screen_position):
			child.handle_click()
			return true
	
	return false

func _initialize_test_ui() -> void:
	var block = UITestSquare.new()
	ui_root.add_child(block)
