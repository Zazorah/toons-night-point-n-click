class_name EventPlayerWalkToTarget
extends Event

# Have the player walk to a position and wait for their arrival.

var target: Vector2

func _init(_target: Vector2) -> void:
	target = _target
	
	# TODO - In the future, design a system for switching to a sprint event
	# 	     if the click is close enough to the previous target.
	cancel_behavior = CancelBehavior.UNCANCELLABLE

func execute(_scene_tree: SceneTree) -> void:
	if GameManager.player_character:
		GameManager.player_character.play_animation("walk")
		GameManager.player_character.walk_to_point(target)
		await GameManager.player_character.arrived_at_target
		GameManager.player_character.play_animation("idle")
	else:
		push_warning("Trying to execute walk event with no set Player Character.")
		await _scene_tree.create_timer(0.1).timeout
