class_name EventPlayerApproachCharacter
extends EventPlayerWalkToTarget

# Have the player walk to a position and wait for their arrival.

func _init(_target: Character) -> void:
	# TODO - Calculate nearest position in walkable space.
	target = _target.find_nearest_walkable_point(128.0, GameManager.player_character.position)
	
	# TODO - In the future, design a system for switching to a sprint event
	# 	     if the click is close enough to the previous target.
	cancel_behavior = CancelBehavior.UNCANCELLABLE
