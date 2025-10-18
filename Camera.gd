class_name Camera
extends Camera2D

const MOVE_SPD = 25.0

func _init() -> void:
	anchor_mode = Camera2D.ANCHOR_MODE_FIXED_TOP_LEFT

func _input(event: InputEvent) -> void:
	if event.is_action("ui_left"):
		position.x -= MOVE_SPD
	
	elif event.is_action("ui_right"):
		position.x += MOVE_SPD
	
	elif event.is_action("ui_up"):
		position.y -= MOVE_SPD
	
	elif event.is_action("ui_down"):
		position.y += MOVE_SPD
