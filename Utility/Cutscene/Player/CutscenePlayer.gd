class_name CutscenePlayer
extends UIElement

## UI element that manages the cutscene.

## Node References
@onready var name_label := $"PanelContainer/VBoxContainer/Name Label"
@onready var message_label := $"PanelContainer/VBoxContainer/Message Label"
@onready var audio_player := $"Audio Player"

## Signals
signal entered 			# Entrance animation has finished.
signal exited 			# Exit animation has finished.
signal step_finished	# A line has finished playing.

func _ready() -> void:
	# Setup off screen.
	position.y += 256
	
	# Clear messages
	name_label.clear()
	message_label.clear()
	
	do_entrance_animation()

func play_scene_step(step: CutsceneStep) -> void:
	name_label.text = step.character_name
	message_label.text = '"' + step.message + '"'
	
	if step.audio:
		audio_player.stream = step.audio
		audio_player.play()
	
	await ClickManager.click_registered # Await any click.

	step_finished.emit()

func do_entrance_animation() -> void:
	var _tween = get_tree().create_tween()
	
	_tween.set_trans(Tween.TRANS_EXPO)
	_tween.set_ease(Tween.EASE_OUT)
	_tween.tween_property(self, "position:y", 0.0, 0.5)
	
	await _tween.finished
	
	entered.emit()

func do_exit_animation() -> void:
	var _tween = get_tree().create_tween()
	
	_tween.set_trans(Tween.TRANS_EXPO)
	_tween.set_ease(Tween.EASE_IN)
	_tween.tween_property(self, "position:y", 256.0, 0.5)
	
	await _tween.finished
	
	exited.emit()
