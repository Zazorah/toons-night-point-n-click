extends Node

## Global for registering clicks on the screen and passing info to dependents.

# NOTE - A click is 'valid' if it is not interrupting anything.

signal click_registered # Emitted when a click happens, valid or not.
signal click_processed # Emitted on a valid click with information.

signal clicked_on_ui # Signal emitted with the element clicked on.
signal clicked_on_interactable # Signal emitted with the interactable clicked on.
signal clicked_in_room # Signal emitted with the room depth clicked on.

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
	
	var _clicked_element = _process_on_ui(context)
	if _clicked_element: # Clicked on UI
		print("Clicked on UI!")
		clicked_on_ui.emit(_clicked_element)
		return
	
	var _clicked_interactable = _process_on_interactables(context)
	if _clicked_interactable: # Clicked on an Interactable
		print("Clicked on Interactables!")
		clicked_on_interactable.emit(_clicked_interactable)
		return
	
	var _clicked_position = _process_on_room(context)
	if _process_on_room(context): # Clicked on walkable space in a room
		print("Clicked in Room! ", _clicked_position.to_string())
		clicked_in_room.emit(_clicked_position)
		return
	
	# Clicked on nothing in particular.
	# TODO - Consider adding some kind of feedback at click position?
	print("Clicked on... NOTHING!!")


func _process_on_ui(context: ClickContext) -> bool:
	return UIManager.process_click(context)

func _process_on_interactables(context: ClickContext) -> InteractableArea:
	for interactable in get_tree().get_nodes_in_group("Interactables"):
		if interactable is InteractableArea:
			if interactable.process_click(context):
				return interactable
	
	return null

func _process_on_room(context: ClickContext) -> RoomDepth:
	if room: # If a room is currently loaded
		var _depth = room.get_depth_at_position(context.world_position)
		if _depth.walkable:
			return _depth
	
	return null

func _mouse_get_screen_pos() -> Vector2:
	return get_viewport().get_mouse_position()

func _mouse_get_scene_pos() -> Vector2:
	var camera = get_viewport().get_camera_2d()
	if camera:
		return camera.get_global_mouse_position()
	
	return Vector2(-1.0, -1.0)
