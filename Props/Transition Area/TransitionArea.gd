class_name TransitionArea
extends Area2D

## Defines a clickable space that the player will walk to before activating
## a transition to another room.

@export var room_scene: PackedScene
@export var transition_tag: StringName

func _ready() -> void:
	add_to_group("Interactables")

func on_click() -> void:
	# Instantiate Room
	var room = room_scene.instantiate()
	if not room is Room:
		push_error("Room Scene is not set to a PackedScene for a Room Node.")
		return
	
	# Update Transition Tag
	GameManager.transition_tag = transition_tag
	
	EventManager.add_events([
		EventPlayerWalkToTarget.new(global_position),
		EventTransitionToRoom.new(room)
	])
