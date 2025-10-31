class_name PlayerSpawn
extends Node2D

## Defines where a player spawns in a Room.

# Properties
@export var default_spawn := true
@export var spawn_tag: StringName
@export var spawn_direction: Character.Direction = Character.Direction.S

func _init() -> void:
	visible = false

func _ready() -> void:
	# Safety-checking: Ensure all non-default spawns have a tag.
	if not default_spawn and not spawn_tag:
		push_warning("PlayerSpawn instances should have a tag if they aren't the default spawn.")
