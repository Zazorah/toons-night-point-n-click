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
	click_processed.emit(ClickContext.new(
		_mouse_get_screen_pos(),
		_mouse_get_scene_pos()
	))

func _mouse_get_screen_pos() -> Vector2:
	return get_viewport().get_mouse_position()

func _mouse_get_scene_pos() -> Vector2:
	var camera = get_viewport().get_camera_2d()
	if camera:
		return camera.get_global_mouse_position()
	
	return Vector2(-1.0, -1.0)
