extends Node

## Global for registering clicks on the screen and passing info to dependents.

# NOTE - A click is 'valid' if it is not interrupting anything.

signal click_registered # Emitted when a click happens, valid or not.
signal click_processed # Emitted on a valid click with information.

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("click"):
		click_registered.emit()
		if not EventManager.currently_executing:
			_process_click()
		else:
			if EventManager.skip_event():
				_process_click()
			else:
				print("Click interrupted by an unskippable event.")

func _process_click() -> void:
	var world_pos = Vector2(0.0, 0.0) # get_viewport().get_camera_2d().get_global_mouse_position()
	click_processed.emit(world_pos)
