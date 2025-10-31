class_name TransitionPlayer
extends Control

## UI Element that Handles Room Transitions

signal scene_hidden
signal transition_finished

func _ready() -> void:
	await _play_entrance_tween()
	scene_hidden.emit()
	await _play_exit_tween()
	transition_finished.emit()
	
	queue_free()

func _create_alpha_tween(final_alpha = 1.0, duration = 1.0) -> Tween:
	var tween = get_tree().create_tween()
	tween.tween_property(self, "modulate:a", final_alpha, duration)
	tween.set_ease(Tween.EASE_IN_OUT)
	tween.set_trans(Tween.TRANS_QUART)
	
	return tween

func _play_entrance_tween() -> void:
	var tween = _create_alpha_tween(1.0)
	await tween.finished

func _play_exit_tween() -> void:
	var tween = _create_alpha_tween(0.0)
	await tween.finished
