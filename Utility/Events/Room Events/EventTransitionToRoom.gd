class_name EventTransitionToRoom
extends Event

# Begins transitioning to a new room.

var room: Room

func _init(destination_room: Room) -> void:
	room = destination_room
	
	cancel_behavior = CancelBehavior.UNCANCELLABLE

func execute(_scene_tree: SceneTree) -> void:
	var transition = UIManager.begin_transition()
	await transition.scene_hidden
	
	GameManager.load_room(room)
