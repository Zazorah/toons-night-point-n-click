extends Node

## Global for registering clicks on the screen and passing info to dependents.

# NOTE - A click is 'valid' if it is not interrupting anything.

signal click_registered # Emitted when a click happens, valid or not.
signal click_processed # Emitted on a valid click with information.

## Node References
var ui: Control = null
var interactables: Array[InteractableArea] = []
var room: Room = null

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
	var context = ClickContext.new(
		_mouse_get_scene_pos(),
		_mouse_get_scene_pos()
	)
	
	if _process_on_ui(context): # Clicked on UI
		pass
	
	if _process_on_interactables(context):
		pass
	elif _process_on_rooms(context):
		pass
	
	#click_processed.emit(ClickContext.new(
		#_mouse_get_screen_pos(),
		#_mouse_get_scene_pos()
	#))

func _process_on_ui(context: ClickContext) -> bool:
	return false

func _process_on_interactables(context: ClickContext) -> bool:
	var was_clicked = false
	
	return was_clicked

func _process_on_rooms(context: ClickContext) -> bool:
	return false

func _mouse_get_screen_pos() -> Vector2:
	return get_viewport().get_mouse_position()

func _mouse_get_scene_pos() -> Vector2:
	var camera = get_viewport().get_camera_2d()
	if camera:
		return camera.get_global_mouse_position()
	
	return Vector2(-1.0, -1.0)
