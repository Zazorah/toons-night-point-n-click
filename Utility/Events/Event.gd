class_name Event
extends RefCounted

## Class describing instructions for how state should change over time.
## Emitted from Nodes in-game and handled by the global EventManager class.

enum CancelBehavior {
	NEXTEVENT,
	CLEARSEQUENCE,
	UNCANCELLABLE
}

## State
var cancel_behavior = CancelBehavior.NEXTEVENT
var is_cancelled = false

## Debug
var owner_name: String = "Unset"

func execute(_scene_tree: SceneTree) -> void:
	## Override with behavior needed for each Event type.
	await _scene_tree.create_timer(1.0).timeout
	pass

func _on_sequence_cancelled() -> void:
	is_cancelled = true

func is_cancellable() -> bool:
	return cancel_behavior != CancelBehavior.UNCANCELLABLE

func is_last_event() -> bool:
	return EventManager.sequence.size() == 0

func will_clear_on_cancel() -> bool:
	return cancel_behavior == CancelBehavior.CLEARSEQUENCE
